# Flutterプロジェクト構造

## 概要

本プロジェクトは、melosを利用したmonorepo構成で、
Feature-Firstアーキテクチャと[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)で定義された7層構造を組み合わせた設計になっています。

### 重要：コマンド実行規約

プロジェクト内でのコマンド実行は、必ず**makeコマンド**を使用してください。
dart/flutterコマンドの直接実行は避け、Makefileで定義されたコマンドを利用します。

詳細は[開発フロー](../02_development/01_development-flow.md#makeコマンドリファレンス)を参照してください。

## 全体構造

```
yattaday-apps/                    # ルートディレクトリ
├── app/                         # メインアプリケーション
├── widgetbook/                  # UIカタログ（Widgetbook）
├── common_widget/               # 共通UIコンポーネントパッケージ
├── _docs/                       # ドキュメント
├── _planning/                   # 計画ドキュメント
├── melos.yaml                   # Melos設定
├── Makefile                     # 共通コマンド定義
└── CLAUDE.md                    # プロジェクト全体の指針
```

## app/ の詳細構造

### ディレクトリ構成

```
app/
├── assets/                      # アセットファイル
│   ├── google_fonts/           # カスタムフォント
│   └── i18n/                   # 多言語対応ファイル
│       ├── en.i18n.json        # 英語（デフォルト）
│       └── ja.i18n.json        # 日本語
│
├── lib/
│   ├── _gen/                   # 自動生成ファイル（編集禁止）
│   │   ├── assets/             # flutter_genによるアセット
│   │   ├── firebase/           # flutterfire_cliによる設定
│   │   └── i18n/               # slangによる言語ファイル
│   │
│   ├── common/                 # アプリ全体の共通処理
│   │   ├── exception/          # 例外クラス
│   │   ├── extensions/         # 拡張メソッド
│   │   ├── firebase/           # Firebase関連ヘルパー
│   │   ├── json_converter/     # JSON変換ユーティリティ
│   │   ├── logger/             # ロギング（Talker）
│   │   ├── theme/              # テーマ定義
│   │   ├── types/              # 共通型定義
│   │   └── utils/              # その他ユーティリティ
│   │
│   ├── components/             # アプリ共通UIコンポーネント
│   │   ├── buttons/            # ボタン類
│   │   ├── dialogs/            # ダイアログ類
│   │   └── loading/            # ローディング表示
│   │
│   ├── services/               # 外部ライブラリのラッパー
│   │   ├── firebase/           # Firebase関連
│   │   ├── admob/              # 広告
│   │   ├── revenue_cat/        # 課金
│   │   └── shared_preferences/ # ローカルストレージ
│   │
│   ├── features/               # 機能別モジュール
│   │   └── <feature_name>/     # 各機能の7層構造
│   │
│   ├── routing/                # ルーティング設定
│   │   ├── router_routes.dart  # ルート定義
│   │   ├── router_provider.dart # GoRouterプロバイダ
│   │   └── router_redirect.dart # リダイレクトロジック
│   │
│   └── main.dart               # エントリーポイント
│
├── test/                       # テストファイル
├── e2e/                        # E2Eテスト（Maestro）
└── pubspec.yaml                # パッケージ定義
```

### features/ の7層構造

各層の責務と設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)を参照してください。

```
features/<feature_name>/
├── 1_models/
│   ├── <name>.dart            # エンティティ定義
│   └── <name>.freezed.dart    # 自動生成（編集禁止）
│
├── 2_repository/
│   ├── dto/                    # データ転送オブジェクト
│   │   └── <name>_param.dart
│   ├── <name>_query_repository.dart    # 読み取り専用（Query）
│   └── <name>_command_repository.dart  # 書き込み専用（Command）
│
├── 3_store/
│   └── <name>_store.dart       # Riverpodプロバイダ
│
├── 4_flow/
│   └── <name>_flow.dart        # 複数画面の調整
│
├── 5_view_model/
│   └── <name>_view_model.dart # 画面固有のロジック
│
├── 6_component/
│   └── <name>_card.dart        # 再利用可能な部品
│
└── 7_page/
    ├── <name>_page.dart        # メイン画面
    └── <name>_dialog.dart      # ダイアログ
```

## widgetbook/ の構造

```
widgetbook/
├── lib/
│   ├── components/             # 共通コンポーネントのカタログ
│   ├── features/               # 機能別コンポーネント
│   └── pages/                  # ページのカタログ
│
├── main.dart                   # Widgetbookエントリーポイント
└── pubspec.yaml
```

## common_widget/ の構造

```
common_widget/
├── lib/
│   ├── components/             # 共通UIコンポーネント
│   │   └── app_logo.dart       # アプリロゴ
│   └── common_widget.dart      # パッケージのエクスポート
│
├── assets/                     # 共通アセット
│   └── icons/                  # アイコン画像
│
└── pubspec.yaml
```

## 重要なファイル

### 設定ファイル

| ファイル | 説明 |
|---------|------|
| `melos.yaml` | Monorepo管理設定 |
| `analysis_options.yaml` | Dart/Flutter静的解析ルール |
| `pubspec.yaml` | パッケージ依存関係 |
| `.gitignore` | Git除外設定 |

### 自動生成ファイル

| パターン | 生成元 | 説明 |
|----------|--------|------|
| `*.g.dart` | build_runner | JSON serialization |
| `*.freezed.dart` | freezed | Immutableクラス |
| `*.gen.dart` | 各種Generator | その他の生成ファイル |

### ドキュメント

| ファイル | 内容 |
|---------|------|
| `CLAUDE.md` | プロジェクト全体の指針 |
| `app/CLAUDE.md` | アプリ固有の指針 |
| `widgetbook/CLAUDE.md` | Widgetbook固有の指針 |
| `README.md` | プロジェクト概要 |

## 命名規則

### ディレクトリ名

- **snake_case**: すべて小文字、アンダースコア区切り
- **番号prefix**: 7層構造では`1_models`のように番号を付与
- **複数形**: 複数のファイルを含む場合は複数形（例: `components`）

### ファイル名

- **snake_case**: すべて小文字、アンダースコア区切り
- **suffixで種類を明示**:
  - `_page.dart`: 画面
  - `_dialog.dart`: ダイアログ
  - `_card.dart`: カード型コンポーネント
  - `_repository.dart`: リポジトリ
  - `_store.dart`: ストア
  - `_view_model.dart`: ビューモデル

### クラス名

- **PascalCase**: 各単語の先頭を大文字
- **明確な責務を表す名前**:
  - `RecordItem`: モデル
  - `RecordItemRepository`: リポジトリ
  - `RecordListPage`: 画面

## アセット管理

### 画像・アイコン

```yaml
# common_widget/pubspec.yaml
flutter:
  assets:
    - assets/icons/
```

```dart
// 使用例
Image.asset(
  'packages/common_widget/assets/icons/app_icon.png',
)
```

### フォント

```yaml
# app/pubspec.yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/google_fonts/CustomFont-Regular.ttf
```

### 多言語対応

```json
// app/assets/i18n/ja.i18n.json
{
  "common": {
    "yes": "はい",
    "no": "いいえ",
    "cancel": "キャンセル"
  }
}
```

```dart
// 使用例
Text(t.common.yes)  // slangによる型安全なアクセス
```

## ベストプラクティス

1. **自動生成ファイルは編集しない**
   - `_gen/`ディレクトリ内のファイル
   - `*.g.dart`、`*.freezed.dart`ファイル

2. **featureの独立性を保つ**
   - 他のfeatureからは`3_store`のみ参照
   - feature内で完結する設計を心がける

3. **共通コンポーネントの配置**
   - アプリ固有: `app/lib/components/`
   - パッケージ共通: `common_widget/lib/components/`

4. **テストファイルの配置**
   - `lib/`の構造を`test/`にミラーリング
   - 同じ階層構造を維持
   - 詳細は[Flutterテスト実装ガイド](./07_test-implementation.md#テストファイルの構造)を参照

5. **定期的な依存関係の更新**

   ```bash
   # melosを使用した一括更新（プロジェクトルートで実行）
   melos exec -- flutter pub outdated
   melos exec -- flutter pub upgrade
   ```
