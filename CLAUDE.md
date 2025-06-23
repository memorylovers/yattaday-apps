# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## **重要事項**

- 日本語でのコミュニケーションとドキュメント記載を推奨
- **軽量化TDD（テスト駆動開発）で実装すること**
  - ビジネスロジック層（models、repository、store、flow）はTDD必須
  - UI層（component、page）はWidgetbookでビジュアル確認
- **`_planning/`ディレクトリに計画ドキュメントを統一配置**
  - 命名規則: `YYMMDD_HHMM_<説明>.md`
  - 作成コマンド: `make plan-new name=<説明>`

## コマンド一覧

```bash
# 初期セットアップ
make

# よく使うコマンド
make test    # テスト実行
make gen     # コード生成
make format  # フォーマット
make lint    # 静的解析
make run     # アプリ実行
```

## プロジェクト構造

本プロジェクトは、melosを利用したmonorepo構成

```
yattaday-apps/
├── app/          # メインアプリ
│   └── CLAUDE.md # メインアプリのCLAUDE.md
├── widgetbook/   # UIカタログ(Widgetbook)
│   └── CLAUDE.md # UIカタログのCLAUDE.md
├── common_widget/ # 共通UIコンポーネントパッケージ
│   └── README.md # パッケージの説明
└── CLAUDE.md     # このファイル
```

### common_widgetパッケージ

appとwidgetbookで共有する共通UIコンポーネントとアセットを管理するパッケージです。

- **アセット管理**: アイコンなどの共通アセット
- **共通コンポーネント**: AppLogoなど、両方のプロジェクトで使用するUI部品
- **依存関係**: app/pubspec.yamlとwidgetbook/pubspec.yamlから参照

## 開発ガイドライン

### ブランチルール

```
**main**: 本番環境用（常にデプロイ可能）
**feature/issue-[number]**: 機能追加
**bugfix/issue-[number]**: バグ修正
**hotfix/issue-[number]**: 緊急修正
```

- GitHub Flowを採用
- 各機能を実装する際、`feature`ブランチを作成する
- GitHub上でPRをマージする

### コミットメッセージ

- [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)を採用
- 以下に従い、シンプルな1行のコミットメッセージにする

```
feat: 新機能追加
fix: バグ修正
test: テスト追加・修正
refactor: リファクタリング
docs: ドキュメント更新
chore: その他の変更
```
