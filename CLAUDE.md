# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## **重要事項**

- 日本語でのコミュニケーションとドキュメント記載を推奨
- **TDD（テスト駆動開発）で実装すること**

## コマンド一覧

```bash
# 初期セットアップ
make

# よく使うコマンド
make test    # テスト実行
make gen     # コード生成
make format  # フォーマット
make lint    # 静的解析
make run     # アプリ実行
```

## プロジェクト構造

本プロジェクトは、melosを利用したmonorepo構成

```
yattaday-apps/
├── app/          # メインアプリ
│   └── CLAUDE.md # メインアプリのCLAUDE.md
├── widgetbook/   # UIカタログ(Widgetbook)
│   └── CLAUDE.md # UIカタログのCLAUDE.md
└── CLAUDE.md     # このファイル
```

## 開発ガイドライン

### ブランチルール

```
**main**: 本番環境用（常にデプロイ可能）
**feature/issue-[number]**: 機能追加
**bugfix/issue-[number]**: バグ修正
**hotfix/issue-[number]**: 緊急修正
```

- GitHub Flowを採用
- 各機能を実装する際、`feature`ブランチを作成する
- GitHub上でPRをマージする

### コミットメッセージ

- [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)を採用
- 以下に従い、シンプルな1行のコミットメッセージにする

```
feat: 新機能追加
fix: バグ修正
test: テスト追加・修正
refactor: リファクタリング
docs: ドキュメント更新
chore: その他の変更
```
