# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## **重要**

- このプロジェクトでは日本語でのコミュニケーションと、コメントおよびドキュメントの記載を推奨します。
- タスクを終えたら `npx ccusage@latest` を実行して、コストを表示してください。

## 開発環境セットアップ

### 初期セットアップ

開発環境の初回セットアップには以下のコマンドを実行してください：

```bash
make
```

これによりfvm、melos、flutterfire_cliがインストールされ、Flutter環境がセットアップされます。

### 共通コマンド

**開発コマンド:**

```bash
# ワークスペースをブートストラップし、依存関係をインストール
melos bootstrap

# すべてのパッケージをクリーン
melos clean

# コード生成（freezed、json_serializable等）
melos run gen --no-select

# Flutterコマンド用にappディレクトリに移動
cd app
```

**Flutterコマンド（app/ディレクトリから実行）:**

```bash
# 異なるフレーバーでアプリを実行
fvm flutter run --flavor dev
fvm flutter run --flavor stag  
fvm flutter run --flavor prod

# 異なるプラットフォームとフレーバーでビルド
fvm flutter build apk --flavor dev
fvm flutter build ios --flavor prod
fvm flutter build web

# テスト実行
fvm flutter test

# コード解析
fvm flutter analyze

# コードフォーマット
make format
```

**リント:**

- flutter_lints、custom_lint、riverpod_lintを使用
- `app/analysis_options.yaml`で設定
- 生成ファイル（*.g.dart、*.freezed.dart）を除外

## アーキテクチャ

このFlutterアプリは**Feature-Firstアーキテクチャ**とクリーンアーキテクチャの原則を使用しています：

### プロジェクト構造

- **Melosを使用したMonorepoセットアップ**、メインアプリは`app/`ディレクトリ内
- **マルチフレーバー対応**（dev/stag/prod）、独立したFirebase設定
- **Feature-first構成**、`lib/features/`配下

### 主要なアーキテクチャパターン

**状態管理:**

- hooks_riverpodを使用したRiverpodによる状態管理
- riverpod_generatorによるコード生成を伴うProviderパターン

**データレイヤー:**

- データアクセスのためのRepositoryパターン
- プライマリバックエンドとしてのFirebase（Auth、Firestore、Analytics、Crashlytics）
- サブスクリプション管理のためのRevenueCat
- 画像ストレージのためのCloudflare R2

**コード生成:**

- イミュータブルデータクラスのためのFreezed
- JSONシリアライゼーションのためのjson_serializable
- 国際化のためのslang
- タイプセーフルーティングのためのgo_router_builder
- アセット管理のためのflutter_gen

### フィーチャー構成

各フィーチャーはクリーンアーキテクチャレイヤーに従います：

```
features/feature_name/
├── data/           # Repository実装、DTO、データソース
├── domain/         # モデル、エンティティ
├── application/    # ユースケース、ビジネスロジック
└── presentation/   # UIウィジェット、ページ、コントローラ
```

**コアフィーチャー:**

- `_authentication/` - Firebase Auth（匿名、Google、Apple）
- `_payment/` - サブスクリプション用RevenueCat連携
- `_advertisement/` - 同意管理を伴うAdMob連携
- `_startup/` - アプリ初期化とルーティングロジック
- `_force_update/` - バージョンチェックと強制アップデート
- `account/` - ユーザープロフィールと設定

### Firebase連携

- 独立したFirebaseプロジェクトによるマルチ環境対応
- `lib/_gen/firebase/`に生成された設定
- `lib/flavors.dart`内のフレーバー固有設定

### 国際化

- タイプセーフi18nのためのslangパッケージを使用
- `assets/i18n/`内の翻訳ファイル
- `lib/_gen/i18n/`内の生成された文字列

### 共通ユーティリティ

- `common/theme/` - アプリ全体のテーマとスタイル
- `common/logger/` - Crashlytics連携を伴うTalkerベースのロギング
- `common/firebase/` - Firebase認証ユーティリティ
- `components/` - 再利用可能UIコンポーネント

## 開発ワークフロー

1. **変更を加える場合**: モデル/プロバイダー変更後は必ずコード生成を実行：

   ```bash
   melos run gen --no-select
   ```

2. **異なるフレーバーのテスト**: 環境固有の設定をテストするためにフレーバー固有のコマンドを使用

3. **国際化**: `assets/i18n/`ファイルに翻訳を追加して再生成

4. **Firebase**: フレーバー固有のFirebase設定はflutterfire_cliにより自動生成

## コーディング規約とベストプラクティス

詳細なコーディングスタイルについては [コーディングスタイル(Flutter)](_docs/10_cording_style_flutter.md) を参照してください。

**主な規約:**

- プレゼンテーション、アプリケーション、ドメイン、データの4層アーキテクチャに従う
- Riverpodを使用した状態管理パターンに準拠
- Firebase認証、エラーハンドリング、ロギングの共通基盤を活用
- 日本語でのコメントとドキュメント記載を推奨

## コミットメッセージ規約

**Conventional Commits形式を使用し、1行で簡潔に記載する:**

- `feat: 新機能追加`
- `fix: バグ修正`
- `docs: ドキュメント更新`
- `style: コードフォーマット`
- `refactor: リファクタリング`
- `test: テスト追加・修正`
- `chore: その他の変更`

## ファイル命名規則

- ファイルとディレクトリにはsnake_caseを使用
- 生成ファイルには`.g.dart`または`.freezed.dart`接尾辞
- コアフィーチャーのディレクトリにはアンダースコアプレフィックスを使用（例：`_authentication`）

## コードフォーマット規則

### 必須事項: 生成したコードは必ずフォーマットを実行すること

```bash
# 推奨: 生成ファイルを除外してフォーマット
make format

# 手動でフォーマットする場合
cd app && fvm dart format .
cd widgetbook && fvm dart format .
```

### フォーマット実行タイミング

1. **ファイル作成・編集後**
   - 新規ファイル作成時
   - 既存ファイル編集時

2. **コード生成実行後**
   - `melos run gen --no-select` 実行後
   - `build_runner build` 実行後

3. **コミット前**
   - git add前に必ず実行
   - 一貫したコードスタイルを維持

### 重要な点

- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）は対象外
- Widgetbookファイルも含むすべての`.dart`ファイルが対象
- フォーマット未実行のコードは品質基準を満たさないため修正対象
