# ドキュメント構成

このディレクトリには、YattaDayプロジェクトのドキュメントが体系的に整理されています。

## ディレクトリ構造

```
_docs/
├── 01_domain/    # プロジェクト固有のドメイン知識
└── 02_tech/      # 汎用的な技術ドキュメント（横展開可能）
```

## 01_domain/ - ドメイン知識

YattaDay固有のビジネス要件やドメイン知識をまとめています。

| ファイル | 内容 |
|----------|------|
| `01_requirements.md` | アプリの要件定義、対応プラットフォーム、主要機能 |
| `02_features.md` | 機能の詳細仕様、ユーザーストーリー |
| `03_screens.md` | 画面仕様、画面遷移、UI要件 |
| `04_data_models.md` | データモデル定義、エンティティ関係 |
| `05_designs.md` | デザイン仕様、UIガイドライン |
| `06_system-architecture.md` | 使用する技術スタック、外部サービス |

## 02_tech/ - 技術ドキュメント

プロジェクトに依存しない汎用的な技術内容です。他プロジェクトへの横展開が可能です。

### 01_architecture/ - アーキテクチャ

| ファイル | 内容 |
|----------|------|
| `01_overview.md` | アーキテクチャ全体の概要と基本原則 |
| `02_7-layer-architecture.md` | 7層アーキテクチャの詳細説明 |
| `03_cqrs-pattern.md` | CQRSパターンの実装方法 |
| `04_error-handling.md` | エラーハンドリング戦略 |
| `05_store-patterns.md` | Store実装パターン |

### 02_development/ - 開発手法

| ファイル | 内容 |
|----------|------|
| `01_development-flow.md` | 開発フロー全体の流れ |
| `02_tdd-strategy.md` | TDD（テスト駆動開発）戦略 |
| `03_branch-strategy.md` | Gitブランチ運用ルール |
| `04_commit-convention.md` | コミットメッセージ規約 |

### 03_flutter/ - Flutter固有

| ファイル | 内容 |
|----------|------|
| `01_project-structure.md` | Flutterプロジェクトの構造 |
| `02_riverpod-patterns.md` | Riverpod実装パターン |
| `03_widgetbook-guide.md` | Widgetbook統合ガイド |
| `04_flutter-tools.md` | Flutter関連ツールと使い方 |
| `05_coding-style.md` | Flutterコーディングスタイル |

## 読む順序

### 新規メンバー向け

1. **ドメイン理解**
   - `01_domain/01_requirements.md` - 何を作るのか理解
   - `01_domain/02_features.md` - 機能の詳細を把握

2. **アーキテクチャ理解**
   - `02_tech/01_architecture/01_overview.md` - 全体像を掴む
   - `02_tech/01_architecture/02_7-layer-architecture.md` - 構造を理解

3. **開発手法**
   - `02_tech/02_development/01_development-flow.md` - 開発の流れ
   - `02_tech/02_development/02_tdd-strategy.md` - テスト方針

4. **実装詳細**
   - `02_tech/03_flutter/01_project-structure.md` - プロジェクト構造
   - `02_tech/03_flutter/02_riverpod-patterns.md` - 状態管理

### 横展開する場合

`02_tech/`ディレクトリをコピーして、新プロジェクトで以下を調整：

1. **技術スタックの確認**
   - Flutter + Riverpod は共通
   - Firebase → REST API などの変更があれば該当箇所を修正

2. **プロジェクト固有の調整**
   - ディレクトリ名やパッケージ名を変更
   - 不要な機能の説明を削除

3. **ドメイン知識の追加**
   - 新プロジェクト用の`01_domain/`を作成
   - ビジネス要件に合わせてドキュメント作成

## ドキュメントの更新

- **CLAUDE.mdとの整合性**: 実装方針が変更された場合は両方を更新
- **実装との同期**: コードの変更に合わせてドキュメントも更新
- **定期的なレビュー**: 四半期ごとに内容の妥当性を確認

## 関連ドキュメント

- `/CLAUDE.md` - プロジェクト全体のAI向け指針
- `/app/CLAUDE.md` - メインアプリのAI向け指針
- `/widgetbook/CLAUDE.md` - WidgetbookのAI向け指針
- `/_planning/` - 個別機能の計画ドキュメント