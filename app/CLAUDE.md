# CLAUDE.md(app)

このファイルは、このリポジトリの`app/`配下のコードを扱う際の  
Claude Code (claude.ai/code) への指針を提供する

## **重要事項**

- **TDD（テスト駆動開発）での実装**
- **クラスや関数にドキュメントコメントを必ず記載**

## 技術スタック

- **状態管理**: [Riverpod](https://riverpod.dev/) v2 + [hooks_riverpod](https://pub.dev/packages/hooks_riverpod)
- **ルーティング**: [go_router](https://pub.dev/packages/go_router) v15 + [go_router_builder](https://pub.dev/packages/go_router_builder)
- **バックエンド**: [Firebase](https://firebase.google.com/docs/flutter/setup) (Auth, Firestore, Analytics)
- **決済**: [RevenueCat](https://pub.dev/packages/purchases_flutter)
- **広告**: [AdMob](https://pub.dev/packages/google_mobile_ads)
- **国際化**: [slang](https://pub.dev/packages/slang) v4
- **コード生成**: [freezed](https://pub.dev/packages/freezed) v2, [json_serializable](https://pub.dev/packages/json_serializable)

## 開発ガイドライン

### **開発・設計の原則**

本プロジェクトでは以下の手法・原則に従う

- **単一責任の原則(Single responsibility principle)**
- **一方向のデータフロー(Unidirectional data flow / UDF)**
- **テスト駆動開発(TDD)**

### 開発の流れ

TDDを用いて開発を行う

1. **テスト作成**: Red フェーズ
1. **コードの実装**: Green フェーズ
1. **Widgetbook実装**: Page/Componentがあれば、UIカタログ追加
1. **フォーマット**: `make format` - コードスタイル統一
1. **コード生成**: `make gen` - Freezed・build_runner実行
1. **リント**: `make lint` - 静的解析チェック
1. **テスト**: `make test` - 全テスト実行

### **完了条件**

- [ ] **フォーマットが適用されていること**: `make format`
- [ ] **コード生成が最新化されていること**: `make gen`
- [ ] **テストが通過していること**: `make test`
- [ ] **静的解析が通過していること**: `make lint`
- [ ] **Page/ComponentがすべてWidgetbook登録されていること**: `lib/main.directories.g.dart`で確認

### コーディング規約

- **アーキテクチャ**: 6層構造を厳守
  - models (1_models)
  - repository (2_repository)
  - application (3_application)
  - view_model (4_view_model)
  - component (5_component)
  - page (6_page)
- **状態管理**: Riverpodパターンに準拠
- **ドキュメント**: 日本語で記載
- **命名規則**: snake_case（ファイル）、PascalCase（クラス）

## アーキテクチャ概要

**Feature-Firstアーキテクチャ** + クリーンアーキテクチャ

### app/配下の構成

```
app/
├── assets/          # 画像、言語ファイルなど
├── lib/
│   ├── _gen/        # 自動生成ファイル。編集禁止
│   ├── common/      # 共通ユーティリティ
│   ├── components/  # アプリ全体で使用する共通UIコンポーネント
│   ├── services/    # 外部ライブラリのラッパー（Firebase、AdMob等）
│   ├── features/    # 機能別モジュール
│   └── routing/     # ルーティング
└── test/            # テストファイル
```

### assets/配下の構成

```
app/assets/
├── google_fonts/     # google_fontsのfontファイルの配置場所
├── i18n/             # slangの言語ファイルの配置場所
│   ├── en.i18n.json  # 英語（デフォルト）
│   └── ja.i18n.json  # 日本語
└── icons/            # icon画像の配置場所
```

- リソース/assetsの配置場所
- ライブラリなどからdartを生成するため、直接参照はしない
- i18nファイルは`make gen`で`_gen/i18n/strings.g.dart`を生成

### app/lib/common/配下の構成

```
app/lib/common/
├── exception/       # 例外関連
├── extensions/      # Extensions関連
├── firebase/        # firebase関連
├── json_converter/  # json_converter関連
├── logger/          # ロギング(talker)
├── theme/           # テーマ関連
├── types/           # 共通の型定義
└── utils/           # その他のutil
```

- アプリ全体で共通的に利用する処理や定義など

### app/lib/services/配下の構成

```
app/lib/services/
├── firebase/           # Firebase関連サービス
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── analytics_service.dart
├── admob/             # AdMob関連サービス
│   └── admob_service.dart
├── revenue_cat/       # RevenueCat関連サービス
│   └── purchase_service.dart
└── shared_preferences/ # SharedPreferences関連サービス
    └── storage_service.dart
```

- 外部ライブラリ（3rd party）のラッパー層
- ライブラリ固有の実装詳細を隠蔽
- エラーハンドリングを統一的に処理
- Repository層から参照される

### app/lib/routing/配下の構成

```
app/lib/routing/
├── router_routes.dart      # ルート定義（@TypedGoRoute）
├── router_provider.dart    # GoRouterのProvider定義
├── router_redirect.dart    # リダイレクトロジック（認証ガード等）
├── router_listenable.dart  # ルート変更の監視
└── my_navigator_observer.dart  # ナビゲーション監視
```

- go_router_builderを使用したタイプセーフなルーティング
- 命名規則: `<PageName>Route` (例: `SettingsPageRoute`)
- 各Pageは対応するRouteクラスから呼び出される
- `make gen`でルート定義を自動生成

### app/lib/features配下の構成

```
features/
└── <feature_name>/
    ├── 1_models/         # モデル、エンティティ
    ├── 2_repository/     # Repository。永続化・データアクセス層
    ├── 3_application/    # 外部のfeatureに公開
    ├── 4_view_model/     # コントローラー。UIと1対1
    ├── 5_component/      # UI コンポーネント
    └── 6_page/           # UI ページ
```

#### ディレクトリ番号の意味

**目的**: ディレクトリ名でソートした際に、クリーンアーキテクチャの層順序と一致させる

- **1_models**: 最内層（ビジネスモデル）
- **2_repository**: データアクセス層
- **3_application**: アプリケーション層
- **4_view_model**: プレゼンテーション層（ロジック）
- **5_component**: プレゼンテーション層（UI部品）
- **6_page**: プレゼンテーション層（画面）

**効果**:

- IDEのファイルツリーで依存関係の流れが視覚的に分かりやすい
- 新しい開発者がアーキテクチャを理解しやすい
- ディレクトリの並び順が設計意図を表現

- `* -> models`: modelsはどこからでも参照できる
- `page -> component`: pageは、componentを使って構築する
- `page -> view_model`: UI Stateを持つpageは、view_modelと1対1で対応する
- `component -> view_model`: UI Stateを持つcomponentは、view_modelと1対1で対応する
- `view_model -> application or repository`: view_modelは、application or repositoryのみ参照できる
- `application -> repository`: applicationは、repositoryのみ参照できる
- `repository -> models, services`: repositoryは、modelsとservicesのみ参照できる
- 別のfeatureからは、`application`のみが参照できる

### Models: ビジネスモデル

```
1_models/
└── <name>.dart
```

- モデル、エンティティ、データクラスの配置場所
- freezedを利用したimutableなclassやenum
- ビジネスロジックを持たないデータ構造

### Repository: データアクセス層(Repositoryパターン)

```
2_repository/
├── dto/
│   └── <name>_param.dart  # 引数パラメタのDTO
└── <name>_repository.dart
```

- API、DB、SharedPreferenceなどの外部のデータにアクセスする永続化層
- riverpodの使用禁止。状態を持たない
- repositoryの返り値は、primitiveな型か、1_modelsのモデルのみ
- repositoryの引数は、dto配下に配置
- 外部ライブラリへのアクセスは、services層を経由

### Application: 共通のUI Stateや処理。外部featureへの公開ポイント

```
3_application/
├── <name>_store.dart   # Global Stateを持つStore。StateNotifierProviderを利用
└── <name>_usecase.dart # 状態を持たない関数
```

- 同一featureの複数view_modelで共有したい状態(store)
- 別featureのview_modelから参照したい状態(store)や処理(usecase)
- 別featureは、3_applicationのみ参照可能

### ViewModel: UIに対応づくUI Stateと処理

```
4_view_model/
└── <name>_view_model.dart # UI Stateを持つViewModel。StateNotifierProviderを利用
```

- 5_component/6_page内のpageやcomponentと、1対1のViewModel
- 対応するpageやcomponentのUI StateやEvent Actionを管理

### Component: UIコンポーネント

```
5_component/
└── <name>.dart # UI Component
```

- UIコンポーネントの配置場所
- routingのgo_routerからpushしない対象

### コンポーネントの使い分け

- **lib/components/**: アプリ全体で使用する汎用的なUIコンポーネント
  - 例: PrimaryButton、LoadingIndicator、CustomTextField
  - 特定のfeatureに依存しない
  - 複数のfeatureから参照される

- **features/<feature_name>/5_component/**: feature固有のUIコンポーネント
  - 例: RecordItemCard、UserProfileHeader
  - 特定のfeatureのドメインモデルに依存
  - 他のfeatureからは参照されない

### Page: 画面/ダイアログ

```
6_page/
├── <name>_page.dart         # UI: ページ
└── <name>_dialog.dart       # UI: ダイアログ
```

- UIコンポーネントの配置場所
- ページ、ダイアログなど、種類を示すsuffixを付与
- routingのgo_routerからpushする対象

## テスト方針

### app/test/配下の構成

```
app/test/
├── components/          # 共通コンポーネントのテスト
├── features/           # 機能別モジュールのテスト
│   └── <feature_name>/ # lib/features/<feature_name>と対応
│       ├── models/     # モデルのテスト
│       ├── repository/ # Repositoryのテスト
│       ├── application/# Application層のテスト
│       ├── view_model/ # ViewModelのテスト
│       ├── component/  # Componentのテスト
│       └── page/       # Pageのテスト
├── test_helpers/       # テスト用ヘルパー
│   ├── fake_*.dart     # フェイク実装
│   └── *_helpers.dart  # テストヘルパー関数
└── test_utils/         # テストユーティリティ
```

- **テストファイルの命名規則**: `<対象ファイル名>_test.dart`
- **テストファイルの配置**: 本体コードと同じディレクトリ構造をtest/配下に再現
- **Riverpodのテスト**: ProviderContainerとoverrideを活用

#### テストの種類と方針

- **Models層**: 純粋な単体テスト（外部依存なし、カバレッジ100%目標）
- **Repository層**: モック/フェイクを使用（カバレッジ90%以上）
- **Application/ViewModel層**: 状態管理のテスト（カバレッジ80%以上）
- **Component/Page層**: Widgetテスト（カバレッジ70%以上）

### app/e2e/配下の構成

```
app/e2e/
├── config.yaml         # Maestro設定ファイル
├── flows/             # E2Eテストフロー
│   ├── 01_login_flow.yaml
│   ├── 02_record_item_create_flow.yaml
│   ├── 03_record_item_edit_delete_flow.yaml
│   └── 04_end_to_end_flow.yaml
└── ci/                # CI/CD関連スクリプト
```

- **E2Eテストフレームワーク**: Maestro
- **実行コマンド**: `make e2e` (app/e2e/配下を実行)
- **テストスコープ**: app/の機能のみ（widgetbook/は対象外）
- **CI/CD**: GitHub Actionsで自動実行

### テストデータ管理

```
app/test/
├── fixtures/                    # 静的テストデータ
│   ├── record_items/
│   │   ├── valid_items.json     # 正常データセット
│   │   ├── invalid_items.json   # 異常データセット
│   │   └── edge_cases.json      # エッジケース
│   └── users/
│       └── test_users.json
├── test_helpers/                # 共通ヘルパー
│   ├── factories/               # ファクトリパターン
│   │   ├── record_item_factory.dart
│   │   ├── user_factory.dart
│   │   └── test_data_factory.dart
│   ├── mocks/                   # モック・フェイク実装
│   │   ├── fake_record_item_repository.dart
│   │   └── fake_auth_repository.dart
│   └── builders/                # テストデータビルダー
│       └── record_item_builder.dart
└── test_utils/                  # テストユーティリティ
    ├── fixture_loader.dart      # JSONローダー
    └── test_data_matcher.dart   # カスタムマッチャー
```

#### テストデータ作成パターン

- **ファクトリパターン**: `RecordItemFactory.create()` で一般的なテストデータ生成
- **ビルダーパターン**: 複雑な条件のテストデータを段階的に構築
- **JSON Fixtures**: 大量データや複雑なデータセットをJSONで管理
- **共通フェイク実装**: 重複を避け、test_helpers/mocks/に統一配置

## エラーハンドリング

### 例外処理の方針

#### 基本原則

**🚨 重要**: アプリ内で発生するすべての例外は**必ず`AppException`に変換**すること

#### 各層での責任分担

- **Repository層**: 外部APIの例外を`handleError()`で**必ず**AppExceptionに変換
- **Application層**: ビジネスロジックの例外を**必ず**AppExceptionとして発生
- **ViewModel層**: **AppExceptionのみ**をキャッチしてUI状態（loading/error）に変換
- **Page/Component層**: エラー状態の表示のみ（例外処理は行わない）

#### 例外変換の必須化

- **Service層**: 外部ライブラリの例外を`AppException`に変換
- **Repository層**: `try-catch`で`handleError()`を**必ず**呼び出す
- **Application層**: ビジネスエラーは`throw AppException()`で発生
- **外部ライブラリ**: Service層ですべての例外を`AppException`にラップ
- **直接的なthrow**: `AppException`以外の例外は**禁止**

#### エラーコードの管理

```dart
// common/exception/app_error_code.dart
enum AppErrorCode {
  // 認証関連
  noAuth,              // ログインが必要
  authAlreadyLinked,   // 別アカウントに連携済み
  
  // 共通エラー
  networkError,        // ネットワークエラー
  notFound,           // データが見つからない
  unknown,            // 予期しないエラー
}
```

#### Service層での例外処理

```dart
class FirestoreService {
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (error) {
      // FirebaseExceptionをAppExceptionに変換
      if (error is FirebaseException) {
        throw AppException(
          code: AppErrorCode.networkError,
          message: 'データの保存に失敗しました',
        );
      }
      throw AppException(
        code: AppErrorCode.unknown,
        message: '予期しないエラーが発生しました',
      );
    }
  }
}
```

#### Repository層での例外処理

```dart
class RecordItemRepository {
  final FirestoreService _firestoreService;
  
  RecordItemRepository(this._firestoreService);
  
  Future<void> create(RecordItem item) async {
    try {
      await _firestoreService.addDocument('items', item.toJson());
    } catch (error) {
      handleError(error); // AppExceptionに変換して再throw
    }
  }
}
```

#### ViewModel層での例外処理

```dart
Future<void> createItem() async {
  state = state.copyWith(isLoading: true, error: null);
  try {
    await _repository.create(item);
    state = state.copyWith(isLoading: false);
  } on AppException catch (e) {
    state = state.copyWith(isLoading: false, error: e);
  }
}
```

#### ユーザーへのエラー表示

- **AppException**: ユーザーフレンドリーなメッセージを表示
- **ネットワークエラー**: 再試行を促すメッセージ
- **認証エラー**: ログイン画面への誘導
- **予期しないエラー**: 技術的詳細を隠した汎用メッセージ
