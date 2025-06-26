# ブランチ戦略

## 概要

本プロジェクトでは、シンプルで効果的な**GitHub Flow**を採用しています。  
すべての変更はfeatureブランチからPull Request経由でmainブランチにマージされます。

## ブランチ構成

### mainブランチ

- **役割**: 本番環境用（常にデプロイ可能な状態を維持）
- **保護設定**:
  - 直接プッシュ禁止
  - PRレビュー承認必須（1名以上）
  - CIテスト全通過必須
  - 最新のmainとの同期必須

### 作業ブランチ

| タイプ | 用途 | 命名規則 | 例 |
|--------|------|----------|-----|
| feature | 新機能追加 | `feature/issue-<番号>-<説明>` | `feature/issue-123-add-export` |
| bugfix | バグ修正 | `bugfix/issue-<番号>-<説明>` | `bugfix/issue-456-fix-crash` |
| hotfix | 緊急修正 | `hotfix/issue-<番号>-<説明>` | `hotfix/issue-789-critical-fix` |

## プロジェクト固有のルール

### マージ戦略

- **Squash and merge**を推奨
  - コミット履歴をきれいに保つ
  - 1つのPR = 1つのコミット

### Pull Request要件

**必須項目:**

- [ ] Issue番号との紐付け（`closes #123`）
- [ ] 変更内容の明確な説明
- [ ] テストの追加/更新
- [ ] セルフレビュー完了
- [ ] CI全項目グリーン

### レビュープロセス

1. 最低1名のレビュー承認が必要
2. CIが全て通過していること
3. mainブランチとの競合がないこと

## ベストプラクティス

- **小さなPR**: レビューしやすい単位で分割
- **早めのPR作成**: WIPでも早めにPRを作成しフィードバックを得る
- **定期的な同期**: mainの変更を定期的に取り込む
- **明確な説明**: PRの目的と変更内容を詳しく記載

## 参照

- [コミット規約](./04_commit-convention.md) - コミットメッセージのルール
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) - GitHub Flow公式ガイド
