# システムアーキテクチャ

## フロントエンド（アプリ）

- 使用フレームワーク：Flutter
- 対応OS：iOS / Android 両対応
- UI構築：Flutter標準Widget＋Riverpodで状態管理
- データ保存（ローカル）：SharedPreferences（設定など）

## バックエンド

- Firebase Authentication（匿名ログイン / Google / Apple対応）
- Cloud Firestore（データの保存）
- Cloudflare R2（画像アップロード）
- RevenueCat（サブスクリプション管理）

## その他

- アナリティクス：Firebase Analytics
- エラートラッキング：Firebase Crashlytics
- 多言語対応：slang（<https://pub.dev/packages/slang）を使用し、アプリ内で言語切替対応>
