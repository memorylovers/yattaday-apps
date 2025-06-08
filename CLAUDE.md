# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## **重要事項**

- 日本語でのコミュニケーションとドキュメント記載を推奨
- タスク完了時は `npx ccusage@latest` でコストを表示
- **TDD（テスト駆動開発）で実装すること**

## クイックスタート

```bash
# 初期セットアップ
make

# よく使うコマンド
make test    # テスト実行
make gen     # コード生成
make format  # フォーマット
make lint    # 静的解析

# アプリ実行（app/ディレクトリで）
fvm flutter run --flavor dev
```

## アーキテクチャ概要

**Feature-Firstアーキテクチャ** + クリーンアーキテクチャ

### プロジェクト構造

```
yattaday-apps/
├── app/                    # メインアプリ（Melosモノレポ）
│   ├── lib/
│   │   ├── features/       # 機能別モジュール
│   │   ├── common/         # 共通ユーティリティ
│   │   └── components/     # 再利用可能UIコンポーネント
│   └── test/              # テストファイル
└── widgetbook/            # UIカタログ
```

### フィーチャー構成

```
features/feature_name/
├── data/           # Repository実装
├── domain/         # モデル、エンティティ  
├── application/    # ビジネスロジック
└── presentation/   # UI（ページ、ウィジェット）
```

詳細な実装例やコード規約は [コーディングスタイル](_docs/10_cording_style_flutter.md) を参照してください。

### 技術スタック

- **状態管理**: Riverpod + hooks_riverpod
- **バックエンド**: Firebase (Auth, Firestore, Analytics)
- **決済**: RevenueCat
- **広告**: AdMob
- **国際化**: slang
- **コード生成**: freezed, json_serializable, go_router_builder

## TDD開発フロー

**Red → Green → Refactor サイクル**

1. **Red**: 失敗するテストを書く → `make test`
2. **Green**: テストを通す最小限の実装 → `make test`  
3. **Refactor**: コード改善 → `make format` → `make lint`

具体的なテスト実装方法は [コーディングスタイル - TDD](_docs/10_cording_style_flutter.md#tddテスト駆動開発) を参照してください。

## 開発ガイドライン

### Issue駆動開発フロー

**全ての作業はIssueから開始**

1. **Issue作成・分析**
   - 機能要求・バグレポート・改善提案をIssueとして作成
   - Issueテンプレートを使用して必要な情報を記載
   - ラベル・マイルストーン・担当者を設定

2. **ブランチ作成（git worktree使用）**
   - Issueに基づいてworktreeを作成
   - ブランチ名: `feature/#issue-number-brief-description`

```bash
# Issue #123 "ユーザー認証機能の追加" の場合
git worktree add ../yattaday-apps-feature-123 -b feature/#123-user-authentication

# Issue #456 "ログインバグ修正" の場合  
git worktree add ../yattaday-apps-feature-456 -b feature/#456-fix-login-bug

# 緊急修正の場合
git worktree add ../yattaday-apps-hotfix-789 -b hotfix/#789-critical-security-fix

# 作業完了後のクリーンアップ
git worktree remove ../yattaday-apps-feature-123
git branch -d feature/#123-user-authentication
```

3. **TDD開発サイクル**
   - **Red**: Issueの受け入れ条件に基づくテストを書く
   - **Green**: テストを通す最小限の実装
   - **Refactor**: コード品質向上

4. **Pull Request作成**
   - PRタイトル: `fix #123: ユーザー認証機能を追加`
   - 自動的にIssueとリンク（`fix #123`, `close #123`を使用）
   - レビュー依頼・テスト結果を記載

5. **レビュー・マージ**
   - コードレビュー実施
   - CI/CDチェック通過確認
   - mainブランチへマージ（Issueが自動クローズ）

### ブランチ戦略

- **main**: 本番環境用（常にデプロイ可能）
- **feature/#issue-number-description**: Issue対応
- **hotfix/#issue-number-description**: 緊急修正

### コーディング規約

- **アーキテクチャ**: 4層構造（presentation/application/domain/data）を厳守
- **状態管理**: Riverpodパターンに準拠
- **ドキュメント**: 日本語で記載
- **命名規則**: snake_case（ファイル）、PascalCase（クラス）

実装例とベストプラクティスは [コーディングスタイル](_docs/10_cording_style_flutter.md) で詳しく説明しています。

### コミットメッセージ

```
feat: 新機能追加
fix: バグ修正
test: テスト追加・修正
refactor: リファクタリング
docs: ドキュメント更新
chore: その他の変更
```

詳細は [コーディングスタイル](_docs/10_cording_style_flutter.md) を参照
