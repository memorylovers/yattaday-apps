# コミット規約

## 概要

本プロジェクトでは[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)を採用し、シンプルな1行のコミットメッセージで統一しています。

## 基本フォーマット

```
<type>: <description>
```

- **type**: コミットの種類を表すプレフィックス
- **description**: 変更内容の簡潔な説明（日本語推奨）

## コミットタイプ

| タイプ | 説明 | 例 |
|--------|------|-----|
| `feat` | 新機能追加 | `feat: 記録データのエクスポート機能を追加` |
| `fix` | バグ修正 | `fix: ログイン時のクラッシュを修正` |
| `test` | テスト追加・修正 | `test: RecordItemのテストケースを追加` |
| `refactor` | リファクタリング | `refactor: Repository層の重複コードを整理` |
| `docs` | ドキュメント更新 | `docs: READMEにセットアップ手順を追加` |
| `chore` | その他の変更 | `chore: 依存関係を更新` |

## 詳細なルール

### 1. 言語

- 日本語を推奨（チームメンバーが日本語話者の場合）
- 技術用語は英語のまま使用してOK

```bash
# 良い例
git commit -m "feat: FirestoreにrecordItemsコレクションを追加"
git commit -m "fix: AsyncValueのエラーハンドリングを修正"

# 避けるべき例
git commit -m "feat: Add record items collection to Firestore"  # 全て英語
git commit -m "feat: 記録項目コレクションを追加"  # 技術用語も日本語化
```

### 2. 文体

- 簡潔に、かつ具体的に
- 「〜を追加」「〜を修正」「〜を削除」などの動詞で終わる
- 句読点は不要

```bash
# 良い例
git commit -m "feat: ユーザープロフィール編集機能を追加"
git commit -m "fix: 日付選択時のタイムゾーン問題を修正"

# 避けるべき例
git commit -m "feat: 機能追加"  # 曖昧すぎる
git commit -m "fix: バグを修正しました。"  # 句読点は不要
```

### 3. スコープ（オプション）

必要に応じてスコープを追加できます：

```
<type>(<scope>): <description>
```

```bash
git commit -m "feat(auth): Googleログイン機能を追加"
git commit -m "fix(ui): ダークモードでのテキスト色を修正"
git commit -m "test(repository): RecordItemRepositoryのモックを追加"
```

### 4. Breaking Change

破壊的変更の場合は説明に`BREAKING CHANGE:`を含める：

```bash
git commit -m "feat: APIレスポンス形式を変更 BREAKING CHANGE: v1 APIは廃止"
```

## 実践例

### 機能追加

```bash
# 新しい画面
git commit -m "feat: 設定画面を追加"

# 新しいコンポーネント
git commit -m "feat: RecordItemCardコンポーネントを追加"

# 新しいビジネスロジック
git commit -m "feat: 連続記録日数の計算ロジックを追加"
```

### バグ修正

```bash
# クラッシュ修正
git commit -m "fix: nullチェック漏れによるクラッシュを修正"

# UI修正
git commit -m "fix: iPadでのレイアウト崩れを修正"

# ロジック修正
git commit -m "fix: 日付計算のタイムゾーン考慮漏れを修正"
```

### リファクタリング

```bash
# コード整理
git commit -m "refactor: Repository層の共通処理を抽出"

# パフォーマンス改善
git commit -m "refactor: リスト描画のパフォーマンスを改善"

# 構造変更
git commit -m "refactor: features配下を7層構造に再編成"
```

### テスト

```bash
# テスト追加
git commit -m "test: AuthStoreの認証フローテストを追加"

# テスト修正
git commit -m "test: flaky testを修正"

# テストヘルパー
git commit -m "test: RepositoryのFake実装を追加"
```

### その他

```bash
# 依存関係
git commit -m "chore: Riverpodを2.5.0に更新"

# 設定ファイル
git commit -m "chore: analysis_options.yamlにカスタムルールを追加"

# CI/CD
git commit -m "chore: GitHub Actionsのキャッシュ設定を追加"
```

## アンチパターン

### 避けるべきコミットメッセージ

```bash
# ❌ 曖昧すぎる
git commit -m "fix: バグ修正"
git commit -m "feat: 機能追加"
git commit -m "update"

# ❌ 複数の変更を1つにまとめている
git commit -m "feat: ログイン機能追加、バグ修正、テスト追加"

# ❌ 実装詳細を書きすぎ
git commit -m "feat: RecordItemRepositoryクラスにcreateIfNotExistsメソッドを追加してFirestoreのdocumentの存在チェックをしてから作成するようにした"

# ❌ 感情的
git commit -m "fix: やっとこのクソバグを修正できた！！！"
```

## 複数の変更がある場合

1つのコミットには1つの目的を持たせる：

```bash
# ❌ 悪い例：複数の変更を1つのコミットに
git add .
git commit -m "feat: エクスポート機能追加とバグ修正"

# ✅ 良い例：変更を分割してコミット
git add lib/features/export/
git commit -m "feat: CSVエクスポート機能を追加"

git add lib/features/auth/
git commit -m "fix: ログアウト時のエラーを修正"
```

## コミットの修正

### 直前のコミットメッセージを修正

```bash
# タイポを見つけた場合
git commit --amend -m "feat: 正しいメッセージ"
```

### 過去のコミットを整理（PR前のみ）

```bash
# 過去3つのコミットを整理
git rebase -i HEAD~3

# エディタで以下のように編集
# pick -> squash に変更して複数のコミットを統合
# pick -> reword に変更してメッセージを編集
```

## Git Hooks（オプション）

コミットメッセージの規約を自動チェック：

```bash
# .gitmessage テンプレートの設定
git config commit.template .gitmessage

# commitlint の導入（Node.js環境）
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

## ベストプラクティス

1. **コミット前に差分を確認**
   ```bash
   git diff --staged
   ```

2. **関連する変更をまとめる**
   - 1機能 = 1コミット
   - テストは実装と同じコミットに含める

3. **WIPコミットは避ける**
   - 作業途中なら`git stash`を使用
   - どうしても必要なら`chore: WIP`として後で整理

4. **定期的にコミット**
   - 大きな変更を小さく分割
   - レビューしやすい単位で

5. **意味のある単位で**
   - 後から`git revert`しやすい単位
   - 履歴を追いやすい単位