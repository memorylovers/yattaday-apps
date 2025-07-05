# CLAUDE.md - プロジェクトコンテキスト

このファイルは、Claude Code (claude.ai/code) への指針を提供する。

## **YOU MUST: 重要事項**

- 日本語でのコミュニケーション
- ユーザからの指示や仕様に疑問があれば作業を中断し、質問すること
- 開発ガイドラインに従うこと: @_docs/_guideline/
- 計画内容や進捗状況は、AI作業用の一時ファイルの`_ai-tmp/`に配置
- DRY / YAGNIの原則に従うこと
- すべてのコマンドは、ルートディレクトリから`make`経由で実行
- 完了条件: `make check-all`と`make test`でエラーが無いこと
