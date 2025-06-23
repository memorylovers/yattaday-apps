enum AppErrorCode {
  // ** auth
  noAuth, // ログインが必要です
  // ** UserSetting | selectedLang
  noSupportLocale, // この言語に対応していません
  // ** UserProfile | Nickname
  nicknameDuplicate, // すでに利用されています
  // ** Auth | Link
  authAlreadyLinked, // 別のアカウントに連携済みです
  // ** AdMob
  adLoadFailed, // 広告の読み込みに失敗しました
  // ** Data
  concurrentUpdate, // 同時更新エラー
  validationError, // バリデーションエラー
  // ** Purchase
  purchaseError, // 購入エラーが発生しました
  purchaseNotConfigured, // 購入機能が初期化されていません
  // ** Storage
  storageError, // ストレージエラーが発生しました
  // ** Common
  networkError, // Network Error
  notFound, // Not Found
  unknown, // エラーが発生しました
}
