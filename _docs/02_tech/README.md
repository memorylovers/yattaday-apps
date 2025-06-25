# 技術ドキュメント

このディレクトリには、プロジェクトで使用する技術的な内容がまとめられています。これらのドキュメントは汎用的に設計されており、他のプロジェクトへの横展開が可能です。

## 概要

本ドキュメント群は以下の特徴を持ちます：

- **プロジェクト非依存**: 特定のビジネス要件に依存しない
- **再利用可能**: 他のFlutter/Webプロジェクトで活用可能
- **段階的に学習可能**: 番号順に読むことで体系的に理解

## カテゴリ別ガイド

### 01_architecture/ - アーキテクチャ設計

システム設計の基本原則と実装パターンを説明します。

**対象読者**:

- 設計に関わる開発者
- コードレビュアー
- テックリード

**主な内容**:

- 7層アーキテクチャによる責務分離
- CQRSパターンによるデータアクセス
- 統一的なエラーハンドリング
- 状態管理パターン

### 02_development/ - 開発プロセス

効率的で品質の高い開発を実現するための手法とルールです。

**対象読者**:

- 全ての開発者
- プロジェクトマネージャー
- QAエンジニア

**主な内容**:

- TDDによる品質担保
- Gitワークフロー
- コーディング規約
- レビュープロセス

### 03_flutter/ - Flutter実装技術

Flutter固有の実装パターンとツールの使い方です。

**対象読者**:

- Flutter開発者
- モバイルエンジニア

**主な内容**:

- プロジェクト構造
- Riverpod状態管理
- UIカタログ作成
- 開発ツール活用

## 横展開ガイド

### Flutterプロジェクトへの適用

1. **このディレクトリをコピー**

   ```bash
   cp -r _docs/02_tech/ <new-project>/_docs/tech/
   ```

2. **プロジェクト固有の調整**
   - Firebase → REST API の変更があれば関連箇所を修正
   - 不要な層があれば該当部分を削除
   - プロジェクト名やパッケージ名を置換

3. **チームでの合意形成**
   - アーキテクチャの採用範囲を決定
   - コーディング規約のカスタマイズ
   - テスト戦略の調整

### Web（Nuxt）プロジェクトへの適用

以下のドキュメントは言語を問わず活用可能：

- `01_architecture/01_overview.md` - 基本原則
- `01_architecture/03_cqrs-pattern.md` - CQRSパターン
- `01_architecture/04_error-handling.md` - エラー設計（言語固有部分を調整）
- `02_development/` - 全ドキュメント（開発プロセスは共通）

Flutter固有の内容は、対応するWeb技術に読み替え：

- Riverpod → Pinia/Vuex
- Widget → Component
- Dart → TypeScript

## 学習パス

### 初級者向け（1-2週間）

1. `01_architecture/01_overview.md` - 全体像の把握
2. `03_flutter/01_project-structure.md` - プロジェクト構造の理解
3. `02_development/01_development-flow.md` - 開発の流れ
4. `02_development/04_commit-convention.md` - コミット規約

### 中級者向け（2-4週間）

1. `01_architecture/02_7-layer-architecture.md` - アーキテクチャ詳細
2. `03_flutter/02_riverpod-patterns.md` - 状態管理
3. `02_development/02_test-strategy.md` - テスト戦略
4. `01_architecture/04_error-handling.md` - エラー処理

### 上級者向け（1ヶ月以上）

1. `01_architecture/03_cqrs-pattern.md` - 高度な設計パターン
2. `01_architecture/05_store-patterns.md` - 状態管理の詳細
3. `03_flutter/03_widgetbook-guide.md` - UI開発効率化
4. `03_flutter/04_flutter-tools.md` - ツール活用

## メンテナンス

### 更新タイミング

- **新技術の導入時**: 新しいパターンやツールを追加
- **ベストプラクティスの発見時**: 既存内容を改善
- **フィードバック反映**: チームからの提案を取り入れ

### バージョン管理

- 大きな変更時は変更履歴を記録
- 破壊的変更は事前にチームに通知
- 定期的なレビュー（四半期ごと）

## フィードバック

改善提案や質問は以下の方法で：

1. GitHubのIssueで提案
2. Pull Requestで直接修正
3. チームミーティングで議論

継続的な改善により、より良い開発体験を実現しましょう。
