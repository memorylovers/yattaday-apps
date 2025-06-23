# Flutter Store アーキテクチャ設計ガイド

## 概要

FlutterアプリケーションにおけるStoreパターンを使用した状態管理の設計指針。AuthStore、AccountStore、PaymentStoreの責任分担と依存関係を整理。

## Store責任分担

### AuthStore（認証状態管理）

**責任範囲：**

- 認証トークンの管理（アクセストークン、リフレッシュトークン）
- 認証状態の管理（未認証、認証中、認証済み、エラー）
- 認証方法の管理（メール/パスワード、OAuth、生体認証など）
- セッション管理（有効期限、デバイス情報）
- 最小限の識別情報（userId、email）

**主要メソッド：**

```dart
- signIn(email, password)
- signOut()
- restoreSession()
- linkGoogleAccount()
- unlinkProvider(provider)
- changePassword(old, new)
- changeEmail(newEmail)
```

### AccountStore（アカウント情報管理）

**責任範囲：**

- ユーザープロファイル情報（ID、名前、メールアドレス、アバター）
- アカウント設定（通知設定、プライバシー設定、言語設定）
- アカウントステータス（アクティブ、停止中、削除予定など）
- 連携プロバイダー情報（表示用）

**主要メソッド：**

```dart
- loadUserProfile(userId)
- updateProfile(name, bio)
- updateAvatar(image)
- refreshLinkedAccounts()
- clearUserData()
```

### PaymentStore（決済・サブスクリプション管理）

**責任範囲：**

- サブスクリプション状態（active、expired、cancelled）
- 現在のプラン情報
- 決済方法の管理
- 購入履歴
- Revenue Cat/Purchases SDKとの連携

**主要メソッド：**

```dart
- initializeForUser(userId, email)
- purchaseSubscription(planId)
- restorePurchases()
- canAccessPremiumFeature(featureId)
- clearPaymentData()
```

## ユースケース別 Store依存関係

### 認証関連

```
- ログイン: AuthStore → AccountStore → PaymentStore
- ログアウト: AuthStore → AccountStore + PaymentStore (並列クリア)
- サインアップ: AuthStore → AccountStore
- セッション復元: AuthStore → AccountStore → PaymentStore
- パスワード変更: AuthStore → (完了通知のみ)
- メールアドレス変更: AuthStore → AccountStore
```

### アカウント連携

```
- Google連携追加: AuthStore → AccountStore
- Apple連携追加: AuthStore → AccountStore
- 連携解除: AuthStore → AccountStore
- 連携アカウントでログイン: AuthStore → AccountStore → PaymentStore
```

### 決済・サブスクリプション

```
- サブスク購入: PaymentStore → (AuthStoreの認証確認) → AccountStore
- プラン変更: PaymentStore → AccountStore
- 支払い方法追加: PaymentStore → (完了通知のみ)
- サブスク解約: PaymentStore → AccountStore
- 購入復元: PaymentStore → (AuthStoreのuserId参照)
```

### プロフィール・設定

```
- プロフィール更新: AccountStore → (独立)
- アバター変更: AccountStore → (独立)
- 通知設定変更: AccountStore → (独立)
- 言語設定変更: AccountStore → (独立)
```

### クロスStore操作

```
- アカウント削除: AuthStore → AccountStore + PaymentStore → (全削除)
- 強制ログアウト(401エラー): AuthStore → AccountStore + PaymentStore
- ユーザー切り替え: AuthStore → AccountStore + PaymentStore → (再初期化)
```

## 実装例

### 1. Store初期化

```dart
class StoreProvider extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. 独立したStore
        ChangeNotifierProvider(
          create: (_) => AuthStore(),
        ),
        
        // 2. AuthStoreに依存
        ChangeNotifierProxyProvider<AuthStore, AccountStore>(
          create: (_) => AccountStore(),
          update: (_, auth, account) => account!..authStore = auth,
        ),
        
        // 3. AuthStoreに依存
        ChangeNotifierProxyProvider<AuthStore, PaymentStore>(
          create: (_) => PaymentStore(),
          update: (_, auth, payment) => payment!..authStore = auth,
        ),
      ],
      child: child,
    );
  }
}
```

### 2. ログインフロー

```dart
class AuthStore extends ChangeNotifier {
  final AccountStore accountStore;
  final PaymentStore paymentStore;
  
  Future<void> signIn(String email, String password) async {
    try {
      // 1. 認証処理
      final response = await _api.signIn(email, password);
      
      // 2. 認証情報を保存
      accessToken = response.accessToken;
      userId = response.userId;
      this.email = email;
      status = AuthStatus.authenticated;
      
      // 3. AccountStoreに指示
      await accountStore.loadUserProfile(userId);
      
      // 4. PaymentStoreを初期化
      await paymentStore.initializeForUser(userId, email);
      
    } catch (e) {
      status = AuthStatus.error;
      throw e;
    }
  }
}
```

### 3. セッション復元

```dart
class AppInitializer {
  final AuthStore authStore;
  final AccountStore accountStore;
  final PaymentStore paymentStore;
  
  Future<void> initialize() async {
    // 1. 認証状態の復元
    await authStore.restoreSession();
    
    if (authStore.status == AuthStatus.authenticated) {
      // 2. アカウント情報の復元（キャッシュから）
      await accountStore.restoreCachedProfile();
      
      // 3. 決済状態の初期化
      await paymentStore.initializeForUser(
        userId: authStore.userId!,
        email: authStore.email,
      );
      
      // 4. バックグラウンドで最新情報取得
      accountStore.loadLatestProfile(authStore.userId!);
    }
  }
}
```

### 4. アカウント連携

```dart
class AuthStore extends ChangeNotifier {
  Future<void> linkGoogleAccount() async {
    if (!isAuthenticated) throw Exception('ログインが必要です');
    
    try {
      // 1. Googleで認証
      final googleCredential = await _googleSignIn.signIn();
      
      // 2. バックエンドに連携をリクエスト
      await _api.linkAuthProvider(
        userId: userId!,
        provider: 'google',
        providerToken: googleCredential.idToken,
        currentToken: accessToken,
      );
      
      // 3. AccountStoreに最新情報の取得を指示
      await accountStore.refreshLinkedAccounts();
      
    } catch (e) {
      // エラーハンドリング
      throw e;
    }
  }
}
```

### 5. サブスクリプション購入

```dart
class PaymentStore extends ChangeNotifier {
  final AuthStore authStore;
  
  Future<bool> purchaseSubscription(String planId) async {
    // 1. 認証確認
    if (!authStore.isAuthenticated) {
      throw Exception('認証が必要です');
    }
    
    try {
      // 2. アプリ内購入の実行
      final result = await _purchases.purchasePackage(planId);
      
      // 3. サーバーに購入情報を送信
      await _api.verifyPurchase(
        userId: authStore.userId!,
        receipt: result.receipt,
        token: authStore.accessToken,
      );
      
      // 4. 状態を更新
      status = SubscriptionStatus.active;
      currentPlanId = planId;
      
      // 5. AccountStoreのプラン情報も更新
      await accountStore.refreshUserProfile();
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

## 設計原則

### 1. 単方向データフロー

- AuthStore → AccountStore/PaymentStore の単方向依存
- AccountStore、PaymentStoreはAuthStoreを直接変更しない

### 2. 責任の明確化

- AuthStore: 認証の「動作」を担当
- AccountStore: ユーザー情報の「保持」を担当
- PaymentStore: 決済状態の「管理」を担当

### 3. 真実の源泉（Single Source of Truth）

- userId: AuthStoreが管理（AccountStoreは表示用にコピー保持）
- サブスク状態: PaymentStoreが管理
- ユーザープロファイル: AccountStoreが管理

### 4. エラーハンドリング

- 各Storeは自身の責任範囲のエラーを処理
- 認証エラー（401）はAuthStoreが検知し、全Storeをクリア

## ストレージ戦略

### セキュアストレージ（機密情報）

```dart
// iOS: Keychain, Android: Keystore
FlutterSecureStorage()
- アクセストークン
- リフレッシュトークン
- 認証関連の機密情報
```

### 通常ストレージ（一般情報）

```dart
// SharedPreferences
- ユーザープロファイル（キャッシュ）
- アプリ設定
- 非機密の状態情報
```

## ベストプラクティス

1. **初期化順序を守る**
   - AuthStore → AccountStore → PaymentStore

2. **キャッシュ戦略**
   - 起動時は即座にキャッシュから表示
   - バックグラウンドで最新情報を取得

3. **エラー復旧**
   - ネットワークエラーは自動リトライ
   - 認証エラーは再ログインを促す

4. **テスタビリティ**
   - 各Storeは独立してテスト可能
   - モックを使用した依存性注入

5. **パフォーマンス**
   - 不要なAPI呼び出しを避ける
   - 適切なキャッシュ戦略を実装
