# CLAUDE.md - プロジェクトコンテキスト

このファイルは、Claude Code (claude.ai/code) への指針を提供する。

## **YOU MUST: 重要事項**

- 日本語でのコミュニケーション
- ユーザからの指示や仕様に疑問があれば作業を中断し、質問すること
- 開発ガイドラインに従うこと`_docs/_guideline/`
- 計画内容や進捗状況は、AI作業用の一時ファイルの`_ai-tmp/`に配置
- DRY / YAGNIの原則に従うこと

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

## 開発ガイドライン

詳細な開発ガイドラインは[_docs/_guideline/](_docs/_guideline/)を参照。
