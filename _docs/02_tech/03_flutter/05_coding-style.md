# コーディングスタイル(Flutter)

## TDD（テスト駆動開発）

TDDの基本概念とサイクルについては[テスト戦略](../02_development/02_test-strategy.md)を参照してください。

### Flutterプロジェクトでのテスト作成指針

- **各機能は必ずテストから始める**
- **Repository層は`fake_cloud_firestore`を使用してテスト**
- **Provider層はRiverpodのテストユーティリティを活用**
- **UI層はWidgetTestでテスト**

## アーキテクチャ

アーキテクチャの概要と層構成については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)を参照してください。

Flutter固有の実装については[Flutter レイヤードアーキテクチャ実装ガイド](./06_layered-architecture-implementation.md)を参照してください。

## ディレクトリ構成

プロジェクトの詳細なディレクトリ構成については[Flutterプロジェクト構造](./01_project-structure.md)を参照してください。

### **features配下での重要事項**

- presentaionのpage/widgetから直接applicationを参照を禁止
- applicationは、以下を満たさない場合、作成を禁止
  - 複数のpage/view_modelが同一の状態を参照する場合
- 状態を持つのは、view_modelとapplicationのみ

```
features/feature_name/
     ├── presentation/
     │   ├── pages/        # applicationを参照しない
     │   ├── widgets/      # applicationを参照しない
     │   └── view_models/  # applicationを参照可能
     ├── application/      # 複数のview_modelから参照される場合のみ存在
     ├── domain/
     └── data/
```

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

1. **withConverterの使用**
   - `fromFirestore` / `toFirestore`メソッドを活用
   - 型安全なコレクション参照を実現
   - 手動JSON変換を排除

2. **ヘルパーメソッド**
   - `_col(userId)`でコレクション参照の重複を排除
   - 一貫したコンバーター適用

3. **CRUD操作**
   - 作成: `SetOptions(merge: false)`
   - 更新: `SetOptions(merge: true)`
   - 削除: `docRef.delete()`
   - 取得: `docSnapshot.data()`で直接モデル取得

4. **エラーハンドリング**
   - すべての操作で`handleError()`を使用
   - 適切なデフォルト値を返却

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

1. **責務の分離**
   - ViewModel: 状態管理・ビジネスロジック
   - View: UI表示・ユーザー入力

2. **依存関係の方向**
   - View → ViewModel（一方向）
   - ViewModelはViewを知らない

3. **状態管理**
   - AsyncValueを活用したエラーハンドリング
   - riverpod_generatorによるコード生成

## 広告

- TDB

## 課金

- TDB

## 強制アップデート

- TDB

## コードフォーマット

生成するコードは必ずフォーマットを実行する：

```bash
# 推奨: 生成ファイルを除外してフォーマット
make format

# 手動でフォーマットする場合
cd app && dart format .
cd widgetbook && dart format .
```

### 重要な点

1. **自動フォーマット**
   - コード生成後は必ず `dart format` を実行
   - build_runnerによる生成ファイルは対象外
   - 一貫したコードスタイルを維持

2. **フォーマット対象**
   - 全ての`.dart`ファイル
   - 生成ファイル（`*.g.dart`, `*.freezed.dart`）は含まない
   - Widgetbookファイルも対象

3. **タイミング**
   - ファイル作成・編集後
   - コード生成（build_runner）実行後
   - コミット前
