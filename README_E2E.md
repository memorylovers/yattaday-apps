# E2E Testing with Maestro

このプロジェクトでは、MaestroフレームワークをE2Eテストに採用しています。

## 🚀 クイックスタート

```bash
# Maestroのインストール
make maestro

# E2Eテストの実行
make e2e          # 全プラットフォーム
make e2e-ios      # iOSのみ
make e2e-android  # Androidのみ
```

## 📁 ディレクトリ構造

```
.maestro/
├── config.yaml              # Maestro設定
├── flows/                   # テストフロー
│   ├── 00_install_app.yaml
│   ├── 01_login_flow.yaml
│   ├── 02_record_item_create_flow.yaml
│   ├── 03_record_item_edit_delete_flow.yaml
│   └── 04_end_to_end_flow.yaml
└── ci/                      # CI/CD設定
    └── setup-emulator.sh
```

## 🧪 テストフロー

### 1. ログインフロー (`01_login_flow.yaml`)

- ゲストログイン
- Googleログイン
- Appleログイン

### 2. RecordItem作成フロー (`02_record_item_create_flow.yaml`)

- 新規作成
- バリデーション確認
- 保存確認

### 3. RecordItem編集・削除フロー (`03_record_item_edit_delete_flow.yaml`)

- 既存項目の編集
- 削除確認ダイアログ
- 削除実行

### 4. エンドツーエンドフロー (`04_end_to_end_flow.yaml`)

- アプリ起動から基本操作まで
- 複数機能の統合テスト

## 🏃 ローカル実行

### 個別テストの実行

```bash
# ログインテストのみ
make e2e-login

# 作成テストのみ
make e2e-create

# 編集テストのみ
make e2e-edit

# 統合テストのみ
make e2e-full
```

### デバイス指定

```bash
# 特定のiOSデバイスで実行
_scripts/run_maestro_tests.sh --ios --device "iPhone 15 Pro"

# Android実機で実行
_scripts/run_maestro_tests.sh --android --device "emulator-5554"
```

## 🔄 CI/CD統合

### GitHub Actions

**PR時の自動実行:**

- `.github/workflows/e2e-test.yml`
- iOS/Android両プラットフォームでテスト
- 失敗時のスクリーンショット保存

**夜間定期実行:**

- `.github/workflows/e2e-nightly.yml`
- 全テストスイートを実行
- 失敗時はIssue自動作成

### 手動実行

GitHub ActionsのUIから手動実行も可能:

1. Actions タブを開く
2. "E2E Tests" ワークフローを選択
3. "Run workflow" をクリック
4. テストタイプを選択（all/login/create/edit/full）

## 🛠️ トラブルシューティング

### テストが見つからない

```bash
maestro test .maestro/flows/
```

### シミュレーターが起動しない

```bash
# iOS
xcrun simctl list devices
xcrun simctl boot <device-id>

# Android
adb devices
emulator -list-avds
```

### テストが不安定

1. `waitForElement`のタイムアウトを増やす
2. `assertVisible`の前に明示的な待機を追加
3. ネットワーク依存を減らす

## 📝 新しいテストの追加

1. `.maestro/flows/`に新しいYAMLファイルを作成
2. テストフローを記述
3. `_scripts/run_maestro_tests.sh`に必要に応じて追加
4. Makefileにショートカットを追加

例:

```yaml
appId: com.memorylovers.yattaday.dev
---
- launchApp
- tapOn: "新しい機能"
- assertVisible: "期待される画面"
```

## 🔗 参考リンク

- [Maestro公式ドキュメント](https://maestro.mobile.dev/)
- [Maestro YAML リファレンス](https://maestro.mobile.dev/reference/api-reference)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
