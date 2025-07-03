# Services Directory

このディレクトリは、外部サービスやライブラリとのインテグレーションを管理するためのサービスレイヤーです。

## ディレクトリ構造

```
services/
├── firebase/            # Firebase関連サービス
├── admob/              # 広告関連サービス（Google AdMob）
├── revenuecat/         # 支払い関連サービス（RevenueCat）
└── shared_preferences/ # ローカルストレージサービス（SharedPreferences）
```

## 設計方針

1. **抽象化**: 外部ライブラリへの直接的な依存を避け、インターフェースを通じて利用
2. **テスタビリティ**: モックやフェイクの実装を容易にする
3. **責任の分離**: ビジネスロジックとサービス統合を明確に分離
4. **エラーハンドリング**: 各サービスで適切なエラーハンドリングを実装

## 各サービスの責務

### Firebase Services

- **firebase_service.dart**: Firebase初期化と設定
- **auth_service.dart**: 認証機能のラッパー
- **firestore_service.dart**: Firestoreデータベース操作
- **analytics_service.dart**: アナリティクス機能
- **crashlytics_service.dart**: クラッシュレポート

### AdMob Services

- **admob_service.dart**: AdMob広告の管理
- **ad_consent_service.dart**: 広告同意の管理

### RevenueCat Services

- **revenuecat_service.dart**: RevenueCatを使用したアプリ内課金

### SharedPreferences Services

- **local_storage_service.dart**: SharedPreferencesのラッパー
