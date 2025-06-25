# Riverpod実装パターン

## 概要

本プロジェクトでは、Riverpod v2 + riverpod_generatorを使用した型安全な状態管理を実装しています。

## プロジェクトでのRiverpod使用パターン

本プロジェクトでは、レイヤードアーキテクチャに基づき、以下の用途でRiverpodを使用：

- **Store層**: グローバル状態管理（`@riverpod class`）
- **ViewModel層**: 画面固有の状態管理（`@riverpod class`）
- **Repository注入**: DIコンテナとして活用
- **認証状態**: Firebase Authの状態監視（`StreamProvider`）

## 非同期処理パターン

### StreamProvider（リアルタイムデータ）

```dart
@riverpod
Stream<List<RecordItem>> recordItemList(Ref ref) async* {
  final uid = await ref.watch(authUidProvider.future);
  if (uid == null) {
    yield [];
    return;
  }
  
  yield* recordItemRepository.watchByUserId(uid);
}

// 使用側
class RecordListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(recordItemListProvider);
    
    return itemsAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => RecordItemCard(items[index]),
      ),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### FutureProvider（一度きりのデータ取得）

```dart
@riverpod
Future<UserStats> userStats(Ref ref, String userId) async {
  final repository = ref.read(statsRepositoryProvider);
  return repository.getUserStats(userId);
}

// キャッシュの無効化
ref.invalidate(userStatsProvider);
```

## StateNotifierProvider（状態管理）

### Store層の実装

エラーハンドリングの基本戦略については[エラーハンドリング戦略](../01_architecture/04_error-handling.md)を参照してください。以下はRiverpodでのAppException使用例です。

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

@riverpod
class AuthStore extends _$AuthStore {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final user = await _authRepository.signIn(email, password);
      state = AuthState.authenticated(user);
    } on AppException catch (e) {
      state = AuthState.error(e.message);
    }
  }
  
  void signOut() {
    _authRepository.signOut();
    state = const AuthState.unauthenticated();
  }
}
```

### ViewModel層の実装

```dart
@freezed
class RecordListState with _$RecordListState {
  const factory RecordListState({
    @Default([]) List<RecordItem> items,
    @Default(false) bool isLoading,
    @Default(null) AppException? error,
    @Default('') String searchQuery,
  }) = _RecordListState;
}

@riverpod
class RecordListViewModel extends _$RecordListViewModel {
  @override
  RecordListState build() {
    // Storeの変更を監視
    ref.listen(recordItemStoreProvider, (previous, next) {
      _updateItems();
    });
    
    return const RecordListState();
  }
  
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _filterItems();
  }
  
  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await ref.read(recordItemStoreProvider.notifier).deleteItem(itemId);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
```

## 依存関係の管理

### ref.watch vs ref.read

```dart
@riverpod
class ExampleViewModel extends _$ExampleViewModel {
  @override
  ExampleState build() {
    // ✅ build内ではwatchを使用（リアクティブ）
    final authState = ref.watch(authStateProvider);
    
    return ExampleState(isAuthenticated: authState is Authenticated);
  }
  
  Future<void> someAction() async {
    // ✅ メソッド内ではreadを使用（一度きり）
    final repository = ref.read(exampleRepositoryProvider);
    await repository.doSomething();
  }
}
```

### select による最適化

```dart
@riverpod
class CartSummary extends _$CartSummary {
  @override
  CartSummaryState build() {
    // カート内のアイテム数のみを監視
    final itemCount = ref.watch(
      cartStoreProvider.select((cart) => cart.items.length),
    );
    
    // 合計金額のみを監視
    final totalPrice = ref.watch(
      cartStoreProvider.select((cart) => cart.totalPrice),
    );
    
    return CartSummaryState(
      itemCount: itemCount,
      totalPrice: totalPrice,
    );
  }
}
```

## ライフサイクル管理

### 自動破棄とキープアライブ

```dart
// デフォルト：使用されなくなったら自動破棄
@riverpod
Future<Data> temporaryData(Ref ref) async {
  return fetchData();
}

// 明示的にキープアライブ
@Riverpod(keepAlive: true)
Future<Config> appConfig(Ref ref) async {
  return loadConfig();
}

// 条件付きキープアライブ
@riverpod
Future<UserData> userData(Ref ref) async {
  // 認証中のみキープアライブ
  final isAuthenticated = ref.watch(authStateProvider) is Authenticated;
  if (isAuthenticated) {
    ref.keepAlive();
  }
  
  return fetchUserData();
}
```

### リソースのクリーンアップ

```dart
@riverpod
class WebSocketConnection extends _$WebSocketConnection {
  @override
  Stream<Message> build() {
    final channel = WebSocketChannel.connect(wsUrl);
    
    // クリーンアップ処理を登録
    ref.onDispose(() {
      channel.sink.close();
    });
    
    return channel.stream.map((data) => Message.fromJson(data));
  }
}
```

## テストパターン

Riverpodのテスト実装パターンについては[Flutterテスト実装ガイド](./07_test-implementation.md#store層のテスト)を参照してください。

## パフォーマンス最適化

### 1. 不必要な再ビルドの回避

```dart
// ❌ 悪い例：全体を監視
final cart = ref.watch(cartProvider);
return Text('Items: ${cart.items.length}');

// ✅ 良い例：必要な部分のみ監視
final itemCount = ref.watch(
  cartProvider.select((cart) => cart.items.length),
);
return Text('Items: $itemCount');
```

### 2. 高価な計算の最適化

```dart
@riverpod
Future<ExpensiveResult> expensiveComputation(Ref ref) async {
  // 自動的にキャッシュされる
  return await heavyCalculation();
}

// 必要に応じて手動でキャッシュを無効化
ref.invalidate(expensiveComputationProvider);
```

### 3. デバウンス処理

```dart
@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounceTimer;
  
  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    
    return const SearchState();
  }
  
  void updateSearchQuery(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }
}
```

## プロジェクト固有のベストプラクティス

1. **レイヤー別の使用方法**
   - Store層: `@riverpod class`で状態管理
   - ViewModel層: 画面固有のロジックは`@riverpod class`
   - Repository層: DIとして注入、状態は持たない

2. **Feature間の参照ルール**
   - 他Featureの参照はStore層のProviderのみ許可
   - ViewModelやRepositoryの直接参照は禁止

3. **テスト戦略**
   - 詳細は[Flutterテスト実装ガイド](./07_test-implementation.md)を参照
