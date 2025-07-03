# ドキュメント構成

このディレクトリには、YattaDayプロジェクトのドキュメントが体系的に整理されています。

## ディレクトリ構造

```
_docs/
├── _guideline/          # 弊社の技術ガイドライン（サブモジュール）
│   ├── 00_process/      # 開発プロセス（ブランチ戦略、コミット規約など）
│   ├── 01_architecture/ # アーキテクチャ概念（言語非依存）
│   └── 10_flutter/      # Flutter実装ガイド
└── 01_domain/    # YattaDay固有のドメイン知識
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

## _guideline/ - 技術ガイドライン（サブモジュール）

[memorylovers/tech_guideline](https://github.com/memorylovers/tech_guideline)リポジトリのサブモジュール。
プロジェクトに依存しない汎用的な技術内容で、他プロジェクトへの横展開が可能です。

### 00_process/ - プロジェクト共通ポリシー

開発プロセスに関する基本的なガイドライン。

### 01_architecture/ - アーキテクチャ・設計

言語非依存のアーキテクチャ概念と設計パターン。

### 10_flutter/ - Flutter実装

Flutter固有の実装ガイドとベストプラクティス。

詳細は[_guideline/README.md](_guideline/README.md)を参照してください。

## 読む順序

### 新規メンバー向け

1. **ドメイン理解**
   - `01_domain/01_requirements.md` - 何を作るのか理解
   - `01_domain/02_features.md` - 機能の詳細を把握

2. **アーキテクチャ理解**
   - `_guideline/00_process/00_philosophy.md` - 基本思想
   - `_guideline/01_architecture/00_overview.md` - 全体像を掴む
   - `_guideline/01_architecture/02_layered-architecture.md` - 構造を理解

3. **開発手法**
   - `_guideline/00_process/01_development-flow.md` - 開発の流れ
   - `_guideline/01_architecture/05_test-strategy.md` - テスト方針

4. **実装詳細**
   - `_guideline/10_flutter/01_project-structure-impl.md` - プロジェクト構造
   - `_guideline/10_flutter/04_store-patterns-impl.md` - 状態管理

### 横展開する場合

新プロジェクトでtech_guidelineを使用する場合：

1. **サブモジュールとして追加**（推奨）

   ```bash
   git submodule add https://github.com/memorylovers/tech_guideline.git _docs/_guideline
   ```

2. **プロジェクト固有のドメイン知識を追加**
   - 新プロジェクト用の`01_domain/`を作成
   - ビジネス要件に合わせてドキュメント作成

3. **必要に応じてガイドラインをカスタマイズ**
   - tech_guidelineの最新版を取り込みながら運用可能

## ドキュメントの更新

- **CLAUDE.mdとの整合性**: 実装方針が変更された場合は両方を更新
- **実装との同期**: コードの変更に合わせてドキュメントも更新
- **定期的なレビュー**: 四半期ごとに内容の妥当性を確認

## 関連ドキュメント

- `/CLAUDE.md` - プロジェクト全体のAI向け指針
- `/app/CLAUDE.md` - メインアプリのAI向け指針
- `/widgetbook/CLAUDE.md` - WidgetbookのAI向け指針
- `/_planning/` - 個別機能の計画ドキュメント
