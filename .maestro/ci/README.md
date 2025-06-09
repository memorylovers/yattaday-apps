# Maestro E2E Tests - CI/CD統合

このディレクトリには、CI/CD環境でMaestroテストを実行するための設定とスクリプトが含まれています。

## ワークフロー

### 1. E2E Tests (`.github/workflows/e2e-test.yml`)

**実行タイミング:**

- Pull Request作成・更新時
- main/developブランチへのプッシュ時
- 手動実行（workflow_dispatch）

**テスト内容:**

- iOS/Android両プラットフォームでテスト
- 基本的なユーザーフロー（ログイン、CRUD操作）
- 失敗時のスクリーンショット保存

### 2. Nightly Tests (`.github/workflows/e2e-nightly.yml`)

**実行タイミング:**

- 毎日午前2時（JST）
- 手動実行

**テスト内容:**

- 全テストスイートの実行
- 長時間のシナリオテスト
- パフォーマンステスト

## セットアップ

### ローカル環境

```bash
# Maestroのインストール
make maestro

# テスト実行
make e2e
```

### CI環境

GitHub Actionsが自動的に以下を実行:

1. Flutter/FVMのセットアップ
2. Maestroのインストール
3. シミュレーター/エミュレーターの起動
4. アプリのビルドとインストール
5. E2Eテストの実行

## トラブルシューティング

### iOS Simulatorが起動しない

```bash
# ローカルで確認
xcrun simctl list devices
xcrun simctl boot <device-id>
```

### Android Emulatorが遅い

CI環境では以下の最適化を実施:

- ハードウェアアクセラレーション無効
- アニメーション無効化
- 軽量なエミュレーターイメージ使用

### テストが不安定

1. `waitForElement`のタイムアウトを調整
2. 明示的な待機を追加
3. ネットワーク依存を削減

## ベストプラクティス

1. **テストの独立性**: 各テストは独立して実行可能に
2. **データクリーンアップ**: テスト後は必ずデータを削除
3. **適切な待機**: 暗黙的な待機より明示的な待機を使用
4. **エラーハンドリング**: 失敗時の情報を最大化

## 参考リンク

- [Maestro Documentation](https://maestro.mobile.dev/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Flutter Testing](https://docs.flutter.dev/testing)
