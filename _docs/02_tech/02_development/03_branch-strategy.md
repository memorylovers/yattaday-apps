# ブランチ戦略

## 概要

本プロジェクトでは、シンプルで効果的な**GitHub Flow**を採用しています。

## ブランチの種類

### main ブランチ

- **役割**: 本番環境用（常にデプロイ可能な状態）
- **保護設定**: 
  - 直接プッシュ禁止
  - PRレビュー必須
  - CIテスト通過必須
- **デプロイ**: mainへのマージで自動デプロイ

### feature ブランチ

- **命名規則**: `feature/issue-[番号]`
- **用途**: 新機能の追加
- **例**: `feature/issue-123-add-record-export`

### bugfix ブランチ

- **命名規則**: `bugfix/issue-[番号]`
- **用途**: バグの修正
- **例**: `bugfix/issue-456-fix-login-error`

### hotfix ブランチ

- **命名規則**: `hotfix/issue-[番号]`
- **用途**: 本番環境の緊急修正
- **例**: `hotfix/issue-789-critical-crash`

## 開発フロー

### 1. Issue作成

```markdown
## 概要
記録データをCSV形式でエクスポートする機能を追加

## 詳細
- エクスポート対象期間を選択可能
- ファイル名は自動生成
- 共有機能と連携

## 完了条件
- [ ] エクスポート機能の実装
- [ ] テストの作成
- [ ] Widgetbookへの追加
```

### 2. ブランチ作成

```bash
# 最新のmainを取得
git checkout main
git pull origin main

# featureブランチを作成
git checkout -b feature/issue-123-add-record-export
```

### 3. 開発とコミット

```bash
# 変更をステージング
git add .

# コミット（Conventional Commitsに従う）
git commit -m "feat: 記録データのCSVエクスポート機能を追加"

# 定期的にプッシュ
git push origin feature/issue-123-add-record-export
```

### 4. Pull Request作成

#### PRテンプレート

```markdown
## 概要
closes #123

記録データをCSV形式でエクスポートする機能を追加しました。

## 変更内容
- RecordExportService の追加
- エクスポート画面の実装
- 期間選択UIの追加

## テスト
- [x] 単体テスト追加
- [x] Widgetbook登録
- [x] 手動テスト完了

## スクリーンショット
[必要に応じて画面キャプチャを添付]

## チェックリスト
- [x] コードレビュー依頼前にセルフレビュー実施
- [x] テストが全て通過
- [x] ドキュメント更新（必要な場合）
```

### 5. レビューとマージ

1. レビュワーの指摘に対応
2. CIが全て通過することを確認
3. Squash and mergeでmainに統合

## ブランチ運用ルール

### 命名規則の詳細

```
<type>/issue-<number>-<short-description>

type: feature | bugfix | hotfix
number: GitHubのIssue番号
short-description: 簡潔な説明（ケバブケース）
```

### コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)に従う：

```
feat: 新機能追加
fix: バグ修正
test: テスト追加・修正
refactor: リファクタリング
docs: ドキュメント更新
chore: その他の変更
```

### マージ戦略

- **Squash and merge**: 通常の開発
  - コミット履歴をきれいに保つ
  - 1つのPR = 1つのコミット

- **Merge commit**: 大規模な機能（稀）
  - 開発履歴を保持したい場合
  - 事前にチームで協議

## 長期ブランチの管理

### リベースによる最新化

```bash
# mainの最新を取得
git checkout main
git pull origin main

# featureブランチに戻る
git checkout feature/issue-123

# リベース
git rebase main

# コンフリクトがある場合は解決
git add .
git rebase --continue

# 強制プッシュ
git push -f origin feature/issue-123
```

### スタッシュの活用

```bash
# 作業中の変更を一時保存
git stash

# mainを最新化
git checkout main
git pull origin main

# ブランチに戻って変更を復元
git checkout feature/issue-123
git stash pop
```

## トラブルシューティング

### コンフリクトの解決

```bash
# コンフリクトファイルを確認
git status

# エディタで手動解決
# <<<<<<<, =======, >>>>>>> マーカーを削除

# 解決済みとしてマーク
git add <resolved-file>

# マージ/リベースを続行
git merge --continue  # or git rebase --continue
```

### 間違ったブランチで作業してしまった

```bash
# 変更を一時保存
git stash

# 正しいブランチを作成/切り替え
git checkout -b feature/issue-999

# 変更を適用
git stash pop
```

### プッシュ済みコミットの修正

```bash
# 直前のコミットメッセージを修正
git commit --amend -m "fix: 正しいメッセージ"

# 強制プッシュ（PRレビュー前のみ）
git push -f origin feature/issue-123
```

## CI/CD連携

### 自動実行されるチェック

1. **コード品質**
   - `make format` - フォーマットチェック
   - `make lint` - 静的解析

2. **テスト**
   - `make test` - 単体テスト
   - カバレッジレポート生成

3. **ビルド**
   - iOS/Androidビルド確認

### ブランチ保護ルール

mainブランチの設定：
- PR必須
- レビュー承認1名以上
- CIチェック全通過
- 最新のmainとの同期必須
- 管理者も規則に従う

## ベストプラクティス

1. **小さなPR**: レビューしやすい単位で分割
2. **早めのPR**: WIPでも早めにPRを作成しフィードバックを得る
3. **定期的な同期**: mainの変更を定期的に取り込む
4. **明確な説明**: PRの目的と変更内容を詳しく記載
5. **セルフレビュー**: PR作成後、自分でもう一度確認