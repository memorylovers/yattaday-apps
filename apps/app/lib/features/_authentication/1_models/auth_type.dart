/// 認証プロバイダーの種類
///
/// アプリケーションで利用可能な認証方法を定義する。
/// Firebase Authenticationのプロバイダーと対応。
enum AuthType {
  /// Google認証
  ///
  /// Googleアカウントを使用した認証
  google,

  /// Apple認証
  ///
  /// Apple IDを使用した認証（iOS/macOSで利用可能）
  apple,

  /// 匿名認証
  ///
  /// アカウント作成なしでアプリを利用するための認証
  anonymous,
}

/// Firebase Auth プロバイダーIDからAuthTypeへの変換
///
/// FirebaseのプロバイダーIDをアプリケーション内部の
/// AuthType enumに変換するヘルパー。
///
/// [providerId] FirebaseのプロバイダーID
///
/// 戻り値: 対応するAuthType、未知の場合はnull
AuthType? authTypeFromProviderId(String providerId) {
  switch (providerId) {
    case 'google.com':
      return AuthType.google;
    case 'apple.com':
      return AuthType.apple;
    default:
      return null;
  }
}
