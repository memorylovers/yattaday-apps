# Maestro E2Eテスト

このディレクトリには、YattadayアプリのE2E（エンドツーエンド）テストが含まれています。

## セットアップ

### 1. Maestroのインストール

```bash
# Maestroをインストール
curl -Ls "https://get.maestro.mobile.dev" | bash

# PATHに追加（必要に応じて）
export PATH="$PATH:$HOME/.maestro/bin"
```

### 2. 開発環境の準備

```bash
# プロジェクトのセットアップ
make

# Flutterアプリのビルド（devフレーバー）
cd app
fvm flutter build ios --debug --flavor dev --simulator  # iOS
fvm flutter build apk --debug --flavor dev               # Android
```

## テストの実行

### 全てのテストを実行

```bash
# プロジェクトルートから
./_scripts/run_maestro_tests.sh
```

### 特定のテストを実行

```bash
# ログインテストのみ
./_scripts/run_maestro_tests.sh login

# 記録項目作成テストのみ
./_scripts/run_maestro_tests.sh create

# 編集・削除テストのみ
./_scripts/run_maestro_tests.sh edit

# エンドツーエンドテスト
./_scripts/run_maestro_tests.sh e2e
```

### プラットフォーム指定

```bash
# iOSシミュレータで実行
./_scripts/run_maestro_tests.sh --ios

# Androidエミュレータで実行
./_scripts/run_maestro_tests.sh --android

# 特定のデバイスで実行
./_scripts/run_maestro_tests.sh --device "iPhone 15"
```

## テストフローの構成

### 00_install_app.yaml

- アプリのインストールと初期設定
- 権限の許可
- 初回起動の確認

### 01_login_flow.yaml

- ゲストログイン
- Googleログイン（シミュレート）
- Appleログイン（iOSのみ）

### 02_record_item_create_flow.yaml

- 新規記録項目の作成
- バリデーションエラーのテスト
- 複数項目の作成
- 作成のキャンセル

### 03_record_item_edit_delete_flow.yaml

- 記録項目の編集
- 個別削除
- 削除のキャンセル
- スワイプ削除（iOSのみ）

### 04_end_to_end_flow.yaml

- アプリの初回起動から基本操作まで
- ゲストログインから記録項目作成
- 記録の追加
- 設定画面とログアウト

## テストの作成ガイドライン

### Semanticsの使用

アプリケーション側でSemantics IDを設定することで、テストが安定します：

```dart
Semantics(
  identifier: 'record_item_title_field',
  label: 'タイトル入力フィールド',
  textField: true,
  child: TextFormField(
    key: const Key('record_item_title_field'),
    // ...
  ),
)
```

### テストでの参照

```yaml
- tapOn:
    id: "record_item_title_field"
```

### ベストプラクティス

1. **待機時間の適切な設定**

   ```yaml
   - assertVisible:
       text: "記録項目"
       timeout: 5000  # 5秒待機
   ```

2. **条件付き実行**

   ```yaml
   - runFlow:
       when:
         visible: "エラーメッセージ"
       commands:
         - tapOn:
             text: "再試行"
   ```

3. **スクリーンショットの活用**

   ```yaml
   - takeScreenshot: "test_step_completed"
   ```

4. **プラットフォーム固有の処理**

   ```yaml
   - runFlow:
       when:
         platform: iOS
       commands:
         - swipe:
             direction: LEFT
   ```

## トラブルシューティング

### アプリが見つからない場合

```bash
# アプリIDを確認
maestro app-info

# 正しいフレーバーでビルドされているか確認
cd app
fvm flutter build ios --debug --flavor dev
```

### テストが失敗する場合

1. スクリーンショットを確認: `.maestro/screenshots/`
2. タイムアウトを増やす
3. Semantics IDが正しく設定されているか確認

### デバイスの問題

```bash
# iOSシミュレータのリスト
xcrun simctl list devices

# Androidエミュレータのリスト
adb devices
```

## CI/CDでの実行

GitHub ActionsやBitriseでの実行例：

```yaml
# .github/workflows/e2e.yml
- name: Run Maestro Tests
  run: |
    curl -Ls "https://get.maestro.mobile.dev" | bash
    export PATH="$PATH:$HOME/.maestro/bin"
    ./_scripts/run_maestro_tests.sh --ios
```

## 参考リンク

- [Maestro公式ドキュメント](https://maestro.mobile.dev/)
- [Maestro CLI リファレンス](https://maestro.mobile.dev/reference/cli)
- [Flutter Semantics](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
