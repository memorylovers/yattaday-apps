# Riverpod実装パターン

## 概要

本プロジェクトでは、Riverpod v2 + riverpod_generatorを使用した型安全な状態管理を実装しています。

Riverpodの基本的な使い方については[公式ドキュメント](https://riverpod.dev/ja/)を参照してください。

## プロジェクトでのRiverpod使用方針

### レイヤー別の役割

| レイヤー | Providerの種類 | 用途 |
|---------|--------------|------|
| **Service** | `Provider` | 外部ライブラリのラッパー、DIコンテナとして使用、状態は持たない |
| **Repository** | `Provider` | データアクセス層、DIコンテナとして使用、状態は持たない |
| **Store** | `@riverpod class` | グローバル状態管理、Feature間で共有 |
| **Flow** | `@riverpod class` | 複数画面間の一時的な状態管理 |
| **ViewModel** | `@riverpod class` | 画面固有の状態管理 |

### Feature間の参照ルール

```dart
// ✅ 許可: 他FeatureのStore層を参照
final userProfile = ref.watch(userStoreProvider);

// ❌ 禁止: 他FeatureのViewModel/Repositoryを直接参照
final otherViewModel = ref.watch(otherFeatureViewModelProvider);
```

## レイヤー別実装パターン

### Service/Repository層 - DIコンテナパターン

```dart
// Service層: 外部ライブラリのラッパー
@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) => FirebaseFirestore.instance;

// Repository層: Serviceを注入して使用
@riverpod
RecordItemRepository recordItemRepository(Ref ref) {
  return RecordItemRepository(ref.watch(firebaseFirestoreProvider));
}
```

### Store層 - グローバル状態管理

```dart
@riverpod
class AuthStore extends _$AuthStore {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await ref.read(authRepositoryProvider).signIn(email, password);
      state = AuthState.authenticated(user);
    } on AppException catch (e) {
      state = AuthState.error(e.message);
    }
  }
}
```

### ViewModel層 - 画面固有の状態管理

```dart
@riverpod
class RecordListViewModel extends _$RecordListViewModel {
  @override
  RecordListState build() {
    // Store層の状態を監視
    ref.listen(recordItemStoreProvider, (_, __) => _updateItems());
    return const RecordListState();
  }
  
  void setFilter(RecordFilter filter) {
    state = state.copyWith(filter: filter);
    _applyFilter();
  }
  
  Future<void> deleteItem(String itemId) async {
    // Store経由で操作
    await ref.read(recordItemStoreProvider.notifier).deleteItem(itemId);
  }
}
```

### Flow層 - 一時的な状態管理

```dart
@riverpod
class OnboardingFlow extends _$OnboardingFlow {
  @override
  OnboardingState build() => const OnboardingState();

  void nextStep() => state = state.copyWith(step: state.step + 1);
  
  void complete() {
    // 完了後は状態をクリア
    ref.invalidateSelf();
  }
}
```

## プロジェクト固有のパターン

### 認証状態の監視

```dart
// Firebase Auth状態をStreamProviderで監視
@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

// 認証済みユーザーIDの提供
@riverpod
Future<String?> authUid(Ref ref) async {
  final user = await ref.watch(authStateChangesProvider.future);
  return user?.uid;
}
```

### エラーハンドリング

```dart
// ViewModelでの統一的なエラーハンドリング
try {
  await someAsyncOperation();
} on AppException catch (e) {
  state = state.copyWith(error: e);
}
```

### 初期化パターン

```dart
// main.dartでの初期化
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer(
    overrides: [
      // 初期化が必要なServiceをオーバーライド
      sharedPreferencesProvider.overrideWithValue(
        await SharedPreferences.getInstance(),
      ),
    ],
  );
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
```

## ベストプラクティス

### 1. 状態の分離

- **グローバル状態**: Store層で管理（認証、ユーザープロフィール等）
- **画面固有状態**: ViewModel層で管理（フォーム入力、フィルター等）
- **一時的状態**: Flow層で管理（マルチステップフォーム等）

### 2. 依存関係の明確化

```dart
// Store → Repository（OK）
class UserStore {
  final repository = ref.read(userRepositoryProvider);
}

// ViewModel → Store（OK）
class ProfileViewModel {
  final userStore = ref.watch(userStoreProvider);
}

// ViewModel → 他FeatureのViewModel（NG）
class CartViewModel {
  final productVM = ref.watch(productViewModelProvider); // ❌
}
```

### 3. テスタビリティ

テストパターンの詳細は[Flutterテスト実装ガイド](./07_test-implementation.md#store層のテスト)を参照してください。

## 参考リンク

- [Riverpod公式ドキュメント](https://riverpod.dev/ja/)
- [AsyncValueの使い方](https://riverpod.dev/docs/essentials/async_value)
- [riverpod_generator](https://pub.dev/packages/riverpod_generator)
