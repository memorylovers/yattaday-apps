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

## 開発ガイドライン

### コーディング規約

- **アーキテクチャ**: 4層構造（presentation/application/domain/data）を厳守
- **状態管理**: Riverpodパターンに準拠
- **ドキュメント**: 日本語で記載
- **命名規則**: snake_case（ファイル）、PascalCase（クラス）

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
