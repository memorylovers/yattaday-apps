# システムアーキテクチャ

## 技術スタック

### フロントエンド（アプリ）

#### コア技術

- **フレームワーク**: Flutter
- **対応OS**: iOS / Android 両対応
- **プログラミング言語**: Dart

#### 状態管理・アーキテクチャ

- **状態管理**: Riverpod v2 + hooks_riverpod
- **ルーティング**: go_router + go_router_builder
- **アーキテクチャ**: Feature-First + Clean Architecture

#### 開発支援ツール

- **コード生成**: freezed + json_serializable
- **国際化**: slang
- **UIカタログ**: Widgetbook
- **静的解析**: flutter_lints

#### ローカルストレージ

- **設定保存**: SharedPreferences
- **構造化データ**: 将来的にSQLiteを検討

### バックエンド

#### Firebase サービス

- **認証**: Firebase Authentication
  - 匿名ログイン
  - Googleログイン
  - Appleログイン
- **データストア**: Cloud Firestore
  - NoSQLドキュメントデータベース
  - リアルタイム同期
- **分析**: Firebase Analytics
- **クラッシュレポート**: Firebase Crashlytics

#### 外部サービス

- **画像ストレージ**: Cloudflare R2
- **課金管理**: RevenueCat（サブスクリプション管理）
- **広告**: Google AdMob（将来実装予定）

### 開発環境

- **パッケージ管理**: fvm (Flutter Version Management)
- **モノレポ管理**: melos
- **CI/CD**: GitHub Actions
- **E2Eテスト**: Maestro

### 設計の特徴

1. **API非依存設計**
   - Repository層でデータソースを抽象化
   - 将来的なREST API移行を考慮

2. **マルチプラットフォーム対応**
   - iOS/Android共通のコードベース
   - プラットフォーム固有の実装は最小限

3. **段階的な機能追加**
   - MVPから段階的に機能を拡張
   - 技術的負債を最小限に抑える設計
