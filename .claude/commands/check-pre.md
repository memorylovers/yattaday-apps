---
description: CLAUDE.mdから前提条件を読み込み、開発開始前の確認事項を表示
allowed-tools:
  - Read
  - LS
  - Glob
---

# 前提条件確認

## CLAUDE.mdを読み込み

@CLAUDE.md を読み込み、以下の前提条件を確認してください：

### ルートCLAUDE.mdの重要事項

1. **日本語でのコミュニケーション**を推奨
2. **軽量化TDD（テスト駆動開発）**で実装すること
   - ビジネスロジック層（models、repository、store、flow）はTDD必須
   - UI層（component、page）はWidgetbookでビジュアル確認
3. **`_planning/`ディレクトリ**に計画ドキュメントを統一配置
   - 命名規則: `YYMMDD_HHMM_<説明>.md`
   - 作成コマンド: `make plan-new name=<説明>`

### ブランチルール

- **main**: 本番環境用（常にデプロイ可能）
- **feature/issue-[number]**: 機能追加
- **bugfix/issue-[number]**: バグ修正
- **hotfix/issue-[number]**: 緊急修正

### コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)を採用

- `feat`: 新機能追加
- `fix`: バグ修正
- `test`: テスト追加・修正
- `refactor`: リファクタリング
- `docs`: ドキュメント更新
- `chore`: その他の変更

## app/CLAUDE.mdを読み込み（存在する場合）

@app/CLAUDE.md を読み込み、以下を確認：

### 開発の重要事項

1. **TDD（テスト駆動開発）での実装**
2. **クラスや関数にドキュメントコメントを必ず記載**

### 軽量化TDD戦略

**TDD必須層**（ビジネスロジック中心）:

- **1_models、2_repository、3_store、4_flow**: 先にテストを書いてから実装

**柔軟なアプローチ層**:

- **5_view_model**: 複雑なロジックがある場合のみTDD

**Widgetbook代替層**（UI中心）:

- **6_component、7_page**: Widgetbookでビジュアル確認

### エラーハンドリング

- アプリ内で発生するすべての例外は**必ず`AppException`に変換**すること

## 確認事項のサマリー

上記の前提条件を理解し、開発を開始する準備ができているか確認してください。
特に以下の点に注意：

- TDDの実施
- ドキュメントコメントの記載
- ブランチとコミットの規約
- エラーハンドリングの方針
