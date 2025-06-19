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

---

### **🔥 Widget/Page実装時の必須チェックリスト**

**すべてのPresentation層コンポーネント（Widget・Page）で必須**

#### **実装フロー（厳守）**

1. **テスト作成**: Red フェーズ
2. **Widget/Page実装**: Green フェーズ
3. **Widgetbook実装**: **必須** - UIカタログ追加
4. **コード生成**: `fvm flutter packages pub run build_runner build`

#### **Widgetbook要件**

- [ ] **最低3つのUseCase**: Default・Error・Edge Case
- [ ] **MockRepository**: 各状態を模擬するリポジトリ
- [ ] **実際のデータ**: リアルなサンプルデータ使用
- [ ] **コールバック**: onSuccess・onError等の動作確認

#### **完了確認**

- [ ] **テスト全通過**: `fvm flutter test`
- [ ] **Widgetbook登録確認**: `lib/main.directories.g.dart`で確認
- [ ] **動作確認**: 各UseCaseの表示・操作確認

#### **⚠️ 重要ルール**

- **Widget実装完了 = Widgetbook実装完了**
- **Widgetbookを忘れた場合は即座に作成**
- **コミット前にWidgetbook確認必須**
- **レビュー時にWidgetbook動作確認**
