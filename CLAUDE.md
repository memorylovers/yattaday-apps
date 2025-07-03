# CLAUDE.md - プロジェクトコンテキスト

このファイルは、Claude Code (claude.ai/code) への指針を提供する。

## **YOU MUST: 重要事項**

- 日本語でのコミュニケーション
- ユーザからの指示や仕様に疑問があれば作業を中断し、質問すること
- 開発ガイドラインに従うこと`_docs/_guideline/`
- 計画内容や進捗状況は、AI作業用の一時ファイルの`_ai-tmp/`に配置
- DRY / YAGNIの原則に従うこと

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

## ガイドライン構成

詳細な開発ガイドラインは[_docs/_guideline/](https://github.com/memorylovers/tech_guideline)を参照

### プロジェクト共通ポリシー (./_docs/_guideline/00_process/)

- **[開発の基本思想](./_docs/_guideline/00_process/00_philosophy.md)**: 尊重する基本原則とアーキテクチャスタイル
- **[開発フロー](./_docs/_guideline/00_process/01_development-flow.md)**: makeコマンドを中心とした開発サイクル
- **[ブランチ戦略](./_docs/_guideline/00_process/02_branch-strategy.md)**: GitHub Flowベースの構造化
- **[コミット規約](./_docs/_guideline/00_process/03_commit-convention.md)**: Conventional Commitsによる履歴管理
- **[命名規則](./_docs/_guideline/00_process/04_naming-conventions.md)**: ファイル・メソッド・DTOの命名規則

### アーキテクチャ・設計 (./_docs/_guideline/01_architecture/)

- **[アーキテクチャ概要](./_docs/_guideline/01_architecture/00_overview.md)**: 重要な設計判断のクイックリファレンス
- **[プロジェクト構成](./_docs/_guideline/01_architecture/01_project-structure.md)**: monorepo構成とディレクトリ構造
- **[レイヤードアーキテクチャ](./_docs/_guideline/01_architecture/02_layered-architecture.md)**: 8層構造による責務分離
- **[エラーハンドリング](./_docs/_guideline/01_architecture/03_error-handling.md)**: 統一的な例外処理戦略
- **[Storeパターン](./_docs/_guideline/01_architecture/04_store-patterns.md)**: 状態管理の実装パターン
- **[テスト戦略](./_docs/_guideline/01_architecture/05_test-strategy.md)**: 層別のテスト方針とカバレッジ目標

### Flutter実装 (./_docs/_guideline/10_flutter/)

- **[Flutter実装ガイド概要](./_docs/_guideline/10_flutter/00_flutter-overview.md)**: 技術スタックと実装の概要
- **[monorepo構成とディレクトリ構造](10_flutter/01_project-structure-impl.md)**: パッケージ構成とディレクトリ設計
- **[レイヤードアーキテクチャのFlutter実装](10_flutter/02_layered-architecture-impl.md)**: 8層構造の具体的な実装方法
- **[エラーハンドリング実装](10_flutter/03_error-handling-impl.md)**: 統一的な例外処理の実装方法
- **[Riverpodによる状態管理実装](10_flutter/04_store-patterns-impl.md)**: Storeパターンの実装例
- **[Flutterテスト実装パターン](10_flutter/05_test-strategy-impl.md)**: 各層のテスト実装例
- **[UIカタログ作成](10_flutter/11_widgetbook-guide.md)**: Widgetbookによるコンポーネント管理
