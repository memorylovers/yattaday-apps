# コミット規約

## 概要

本プロジェクトでは[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)を採用し、  
シンプルな1行のコミットメッセージで統一しています。

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

## 記述ルール

1. **日本語推奨、技術用語は英語OK**
   - ✅ `feat: FirestoreにrecordItemsコレクションを追加`
   - ❌ `feat: Add record items collection to Firestore`

2. **簡潔かつ具体的に**
   - ✅ `fix: 日付選択時のタイムゾーン問題を修正`
   - ❌ `fix: バグ修正` （曖昧すぎる）

3. **「〜を追加」「〜を修正」「〜を削除」などの動詞で終わる**

4. **スコープは必要に応じて追加**
   - `feat(auth): Googleログイン機能を追加`
   - `fix(ui): ダークモードでのテキスト色を修正`

5. **破壊的変更はBREAKING CHANGEを明記**
   - `feat: APIレスポンス形式を変更 BREAKING CHANGE: v1 APIは廃止`

## ベストプラクティス

- **1コミット1目的**: 複数の変更を混ぜない
- **定期的にコミット**: 大きな変更は小さく分割
- **意味のある単位**: 後から`git revert`しやすい単位で

## アンチパターン

```bash
# ❌ 曖昧すぎる
git commit -m "update"

# ❌ 複数の変更を混在
git commit -m "feat: ログイン機能追加、バグ修正、テスト追加"

# ❌ 実装詳細を書きすぎ
git commit -m "feat: RecordItemRepositoryクラスにcreateIfNotExistsメソッドを追加してFirestoreのdocumentの存在チェックをしてから作成するようにした"
```

## 参照

- [開発フロー](./01_development-flow.md) - 開発プロセス全体
- [ブランチ戦略](./03_branch-strategy.md) - ブランチ運用ルール
