# 技術ドキュメント

このディレクトリ（02_tech）は**プロジェクト非依存**の技術ドキュメントです。
他のプロジェクトへそのまま流用・カスタマイズして使用できます。

## 🚨 必読：基本原則

1. **makeコマンド必須** - すべての操作は`make`経由で実行
2. **レイヤードアーキテクチャ** - Feature-First + 8層構造による責務分離
3. **CQRSパターン** - Repository層でQuery/Command分離
4. **AppException統一** - すべての例外は必ずAppExceptionに変換
5. **TDD推進** - ビジネスロジック層は必須、UI層はWidgetbook
6. **Feature間参照ルール** - Store層のみ他Featureを参照可能

## 📁 目次

### 01_concepts/ - 言語非依存の概念・方針

- [01_overview.md](01_concepts/01_overview.md) - アーキテクチャ全体像と基本原則
- [02_layered-architecture.md](01_concepts/02_layered-architecture.md) - 8層構造の詳細定義
- [03_error-handling.md](01_concepts/03_error-handling.md) - 統一的なエラー処理
- [04_store-patterns.md](01_concepts/04_store-patterns.md) - Store層の実装パターン
- [05_development-flow.md](01_concepts/05_development-flow.md) - makeコマンドによる開発フロー
- [06_test-strategy.md](01_concepts/06_test-strategy.md) - テスト戦略とカバレッジ目標
- [07_branch-strategy.md](01_concepts/07_branch-strategy.md) - GitHub Flowとブランチルール
- [08_commit-convention.md](01_concepts/08_commit-convention.md) - コミットメッセージ規約

### 03_flutter/ - Flutter実装

- [01_project-structure.md](03_flutter/01_project-structure.md) - monorepo構成とディレクトリ構造
- [02_layered-architecture-impl.md](03_flutter/02_layered-architecture-impl.md) - レイヤードアーキテクチャのFlutter実装
- [04_store-patterns-impl.md](03_flutter/04_store-patterns-impl.md) - Riverpodによる状態管理実装
- [05_development-flow-impl.md](03_flutter/05_development-flow-impl.md) - Flutter開発ツールとコマンド
- [06_test-strategy-impl.md](03_flutter/06_test-strategy-impl.md) - Flutterテスト実装パターン
- [07_widgetbook-guide.md](03_flutter/07_widgetbook-guide.md) - UIカタログ作成
- [09_coding-style.md](03_flutter/09_coding-style.md) - Flutterコーディングスタイル

※ `-impl.md` が付いているファイルは、01_concepts/ の対応するファイルの Flutter 実装です
