# 技術ドキュメント

## 🚨 必読：基本原則

1. **makeコマンド必須** - すべての操作は`make`経由で実行
2. **レイヤードアーキテクチャ** - Feature-First + 8層構造による責務分離
3. **CQRSパターン** - Repository層でQuery/Command分離
4. **AppException統一** - すべての例外は必ずAppExceptionに変換
5. **TDD推進** - ビジネスロジック層は必須、UI層はWidgetbook
6. **Feature間参照ルール** - Store層のみ他Featureを参照可能

## 📁 目次

### 01_architecture/

- [01_overview.md](01_architecture/01_overview.md) - アーキテクチャ全体像と基本原則
- [02_layered-architecture.md](01_architecture/02_layered-architecture.md) - 8層構造の詳細定義
- [04_error-handling.md](01_architecture/04_error-handling.md) - 統一的なエラー処理
- [05_store-implementation-guide.md](01_architecture/05_store-implementation-guide.md) - Store層の実装パターン

### 02_development/

- [01_development-flow.md](02_development/01_development-flow.md) - makeコマンドによる開発フロー
- [02_test-strategy.md](02_development/02_test-strategy.md) - テスト戦略とカバレッジ目標
- [03_branch-strategy.md](02_development/03_branch-strategy.md) - GitHub Flowとブランチルール
- [04_commit-convention.md](02_development/04_commit-convention.md) - コミットメッセージ規約

### 03_flutter/

- [01_project-structure.md](03_flutter/01_project-structure.md) - monorepo構成とディレクトリ構造
- [02_riverpod-patterns.md](03_flutter/02_riverpod-patterns.md) - Riverpod状態管理パターン
- [03_widgetbook-guide.md](03_flutter/03_widgetbook-guide.md) - UIカタログ作成
- [04_flutter-tools.md](03_flutter/04_flutter-tools.md) - 開発ツールとコマンド
- [05_coding-style.md](03_flutter/05_coding-style.md) - コーディングスタイル
- [06_layered-architecture-implementation.md](03_flutter/06_layered-architecture-implementation.md) - Flutter実装例
- [07_test-implementation.md](03_flutter/07_test-implementation.md) - テスト実装パターン
