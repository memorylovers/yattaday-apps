# CLAUDE.md(app)

このファイルは、このリポジトリの`app/`配下のコードを扱う際の  
Claude Code (claude.ai/code) への指針を提供する

## **重要事項**

- **TDD（テスト駆動開発）での実装**
- **クラスや関数にドキュメントコメントを必ず記載**

## 技術スタック

- **状態管理**: Riverpod + hooks_riverpod
- **バックエンド**: Firebase (Auth, Firestore, Analytics)
- **決済**: RevenueCat
- **広告**: AdMob
- **国際化**: slang
- **コード生成**: freezed, json_serializable, go_router_builder

## 開発ガイドライン

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
  - page
  - component
  - view_model
  - application
  - repository
  - domain
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
│   ├── components/  # 再利用可能UIコンポーネント
│   ├── features/    # 機能別モジュール
│   └── routing/     # ルーティング
└── test/            # テストファイル
```

### assets/配下の構成

```
app/assets/
├── google_fonts/     # google_fontsのfontファイルの配置場所
├── i18n              # slangの言語ファイルの配置場所
│   ├── en.i18n.json
│   └── ja.i18n.json
└── icons/            # icon画像の配置場所
```

- リソース/assetsの配置場所
- ライブラリなどからdartを生成するため、直接参照はしない

### app/lib/common/配下の構成

```
app/lib/common/
├── exception/       # 例外関連
├── extentions/      # Extensions関連
├── firebase/        # firebase関連
├── json_converter/  # json_converter関連
├── logger/          # ロギング(talker)
├── theme/           # テーマ関連
├── types/           # 共通の型定義
└── utils/           # その他のutil
```

- アプリ全体で共通的に利用する処理や定義など

### app/lib/features配下の構成

```
features/
└── <feature_name>/
    ├── 1_domain/         # モデル、エンティティ
    ├── 2_repository/     # Repository。永続化・データアクセス層
    ├── 3_application/    # 外部のfeatureに公開
    ├── 4_view_model/     # コントローラー。UIと1対1
    ├── 5_component/      # UI コンポーネント
    └── 6_page/           # UI ページ
```

- `* -> domain`: domainはどこからでも参照できる
- `page -> component`: pageは、componentを使って構築する
- `page -> view_model`: UI Stateを持つpageは、view_modelと1対1で対応する
- `component -> view_model`: UI Stateを持つcomponentは、view_modelと1対1で対応する
- `view_model -> application or repository`: view_modelは、application or repositoryのみ参照できる
- `application -> repository`: applicationは、repositoryのみ参照できる
- `repository -> domain`: repositoryは、domainのみ参照できる
- 別のfeatureからは、`application`のみが参照できる

### Domain: ドメインモデル

```
1_domain/
└── <name>.dart
```

- モデル、エンティティ、データクラスの配置場所
- freezedを利用したimutableなclassやenum

### Repository: データアクセス層(Repositoryパターン)

```
2_repository/
├── dto/
│   └── <name>_param.dart  # 引数パラメタのDTO
└── <name>_repository.dart
```

- API、DB、SharedPreferenceなどの外部のデータにアクセスする永続化層
- riverpodの使用禁止。状態を持たない
- repositoryの返り値は、primitiveな型か、1_domainのモデルのみ
- repositoryの引数は、dto配下に配置

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

- 5_presentation内のpageやcomponentと、1対1のViewModel
- 対応するpageやcomponentのUI StateやEvent Actionを管理

### Component: UIコンポーネント

```
5_component/
└── <name>.dart # UI Component
```

- UIコンポーネントの配置場所
- routingのgo_routerからpushしない対象

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
│       ├── domain/     # ドメインモデルのテスト
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

- **Domain層**: 純粋な単体テスト（外部依存なし、カバレッジ100%目標）
- **Repository層**: モック/フェイクを使用（カバレッジ90%以上）
- **Application/ViewModel層**: 状態管理のテスト（カバレッジ80%以上）
- **Component/Page層**: Widgetテスト（カバレッジ70%以上）
