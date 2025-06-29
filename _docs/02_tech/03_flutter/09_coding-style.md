# コーディングスタイル(Flutter)

## コマンド実行規約

### makeコマンドの使用（必須）

本プロジェクトでは、すべてのビルド・テスト・フォーマット操作は**makeコマンド経由**で実行します：

- `make gen` - コード生成
- `make format` - フォーマット
- `make test` - テスト実行

dart/flutterコマンドの直接実行は禁止されています。

## TDD（テスト駆動開発）

TDDの基本概念とサイクルについては[テスト戦略](../02_development/02_test-strategy.md)を参照してください。

### Flutterプロジェクトでのテスト作成指針

- **各機能は必ずテストから始める**
- **Repository層は`fake_cloud_firestore`を使用してテスト**
- **Provider層はRiverpodのテストユーティリティを活用**
- **UI層はWidgetTestでテスト**

具体的なテスト実装方法については[Flutterテスト実装ガイド](./07_test-implementation.md)を参照してください。

## アーキテクチャ

アーキテクチャの概要と層構成については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)を参照してください。

Flutter固有の実装については[Flutter レイヤードアーキテクチャ実装ガイド](./06_layered-architecture-implementation.md)を参照してください。

## ディレクトリ構成

プロジェクトの詳細なディレクトリ構成については[Flutterプロジェクト構造](./01_project-structure.md)を参照してください。

### **features配下での重要事項**

- PageやComponentから直接Store/Flowを参照禁止（ViewModelを経由）
- Storeは、以下を満たす場合のみ作成
  - アプリ全体で共有されるグローバルな状態
  - 複数のViewModelから参照される状態
  - 別の機能モジュールから参照される状態
- 状態を持つのは、Store、Flow、ViewModelのみ

7層構造の詳細については[Flutterプロジェクト構造](./01_project-structure.md#features-の7層構造)を参照してください。

## 利用ライブラリ

- 状態管理:
  - [riverpod](https://pub.dev/packages/riverpod)
  - [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)
- データクラス:
  - [freezed](https://pub.dev/packages/freezed)
  - [json_serializable](https://pub.dev/packages/json_serializable)
- 多言語対応:
  - [slang](https://pub.dev/packages/slang)
- コード生成:
  - [build_runner](https://pub.dev/packages/build_runner)
  - [flutter_gen](https://pub.dev/packages/flutter_gen)
- ルーティング:
  - [go_router](https://pub.dev/packages/go_router)
  - [go_router_builder](https://pub.dev/packages/go_router_builder)
- ロギング:
  - [talker](https://pub.dev/packages/talker)
- lint:
  - [custom_lint](https://pub.dev/packages/custom_lint)
  - [riverpod_lint](https://pub.dev/packages/riverpod_lint)
- 決済/マネタイズ:
  - [purchases_flutter](https://pub.dev/packages/purchases_flutter)
  - [google_mobile_ads](https://pub.dev/packages/google_mobile_ads)
- その他:
  - shared_preferences
  - google_fonts
  - flutter_animate

## 認証

- 認証はFirebase Authを用いる
- 認証中かどうかの判断は、Firebase Authの認証状態を用いる

## エラーハンドリング

エラーハンドリングの基本戦略については[エラーハンドリング戦略](../01_architecture/04_error-handling.md)を参照してください。

### Flutter固有の実装

- Firebase Crashlyticsを使用したクラッシュレポートの送信
- Flutter エラーハンドラーとの統合

## ロギング

- Talkerを使用したロギング
- Crashlyticsへのログ送信
- デバッグモードでのログ表示

## Firestoreリポジトリ実装

### 基本パターン

Firestoreリポジトリでは、型安全性と保守性を高めるため以下のパターンを使用する：

```dart
class FirebaseExampleRepository implements IExampleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コレクション参照ヘルパーメソッド（コンバーター付き）
  CollectionReference<ExampleModel> _col(String userId) => _firestore
      .collection(ExampleModel.collectionPath(userId))
      .withConverter(
        fromFirestore: ExampleModel.fromFirestore,
        toFirestore: ExampleModel.toFirestore,
      );

  @override
  Future<void> create(ExampleModel model) async {
    try {
      final docRef = _col(model.userId).doc(model.id);
      await docRef.set(model, SetOptions(merge: false));
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update(ExampleModel model) async {
    try {
      final docRef = _col(model.userId).doc(model.id);
      await docRef.set(model, SetOptions(merge: true));
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<ExampleModel?> getById(String userId, String id) async {
    try {
      final docSnapshot = await _col(userId).doc(id).get();
      if (!docSnapshot.exists) return null;
      return docSnapshot.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Stream<List<ExampleModel>> watchByUserId(String userId) {
    try {
      return _col(userId)
          .orderBy('createdAt')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (error) {
      handleError(error);
      return Stream.value([]);
    }
  }
}
```

### 重要なポイント

- **withConverter**: 型安全なコレクション参照
- **ヘルパーメソッド**: `_col(userId)`で重複排除
- **CRUD操作**: 作成は`merge: false`、更新は`merge: true`
- **エラーハンドリング**: AppExceptionで統一

## Presentation層の構成

### ディレクトリ構造

```
features/feature_name/presentation/
├── view_model/             # ViewModel層
│   └── feature_providers.dart  # Riverpodプロバイダー
└── pages/                  # View層
    ├── feature_page.dart   # メインページ
    └── widgets/            # 専用ウィジェット
        └── feature_widget.dart
```

### ViewModel層の実装

ViewModelはRiverpodプロバイダーとして実装し、以下のパターンを使用する：

```dart
// repositories
final IExampleRepository exampleRepository = FirebaseExampleRepository();

/// 一覧取得プロバイダー
@riverpod
Stream<List<ExampleModel>> exampleList(Ref ref) async* {
  final uid = await ref.watch(authUidProvider.future);
  if (uid == null) {
    yield [];
    return;
  }
  yield* exampleRepository.watchByUserId(uid);
}

/// 作成プロバイダー
@riverpod
class ExampleCreator extends _$ExampleCreator {
  @override
  FutureOr<void> build() {}

  Future<void> create({required String title}) async {
    final uid = await ref.read(authUidProvider.future);
    if (uid == null) throw Exception('ユーザーが認証されていません');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await exampleRepository.create(/* ... */);
    });
  }
}
```

### View層の実装

ViewはHookConsumerWidgetとして実装し、ViewModelとの結合を最小限にする：

```dart
class ExamplePage extends HookConsumerWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exampleListAsync = ref.watch(exampleListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: exampleListAsync.when(
        data: (examples) => _buildExampleList(context, ref, examples),
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stackTrace) => _buildError(context, ref, error),
      ),
    );
  }
}
```

### 重要な原則

- **責務の分離**: ViewModelが状態管理、ViewがUI表示
- **依存関係**: View → ViewModel（一方向）
- **状態管理**: AsyncValueでエラーハンドリング

## コードフォーマット

生成するコードは必ずフォーマットを実行する：

```bash
# 生成ファイルを除外してフォーマット
make format
```

**重要**: コード生成後は必ず`make format`を実行してください。
