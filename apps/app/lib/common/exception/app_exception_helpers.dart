import 'app_error_code.dart';
import 'app_exception.dart';
import 'exception_category.dart';

/// AppExceptionのヘルパークラス
///
/// よく使うエラーパターンの生成を簡略化する
/// ファクトリメソッドを提供する。
class AppExceptions {
  AppExceptions._();

  // ============== Logic Category ==============

  /// バリデーションエラー
  static AppException validationError(String message) => AppException(
    category: ExceptionCategory.logic,
    code: AppErrorCode.validationError,
    message: message,
  );

  /// 認証が必要なエラー
  static AppException noAuth([String? message]) => AppException(
    category: ExceptionCategory.logic,
    code: AppErrorCode.noAuth,
    message: message ?? 'ログインが必要です',
  );

  /// 重複エラー
  static AppException duplicate(String message) => AppException(
    category: ExceptionCategory.logic,
    code: AppErrorCode.nicknameDuplicate,
    message: message,
  );

  /// 既に連携済みエラー
  static AppException alreadyLinked([String? message]) => AppException(
    category: ExceptionCategory.logic,
    code: AppErrorCode.authAlreadyLinked,
    message: message ?? '別のアカウントに連携済みです',
  );

  /// サポートされていない言語エラー
  static AppException noSupportLocale(String locale) => AppException(
    category: ExceptionCategory.logic,
    code: AppErrorCode.noSupportLocale,
    message: '言語「$locale」はサポートされていません',
  );

  // ============== System Category ==============

  /// ネットワークエラー
  static AppException networkError([String? message, Object? originalError]) =>
      AppException(
        category: ExceptionCategory.system,
        code: AppErrorCode.networkError,
        message: message ?? 'ネットワークエラーが発生しました',
        originalError: originalError,
      );

  /// リソースが見つからないエラー
  static AppException notFound(String resource) => AppException(
    category: ExceptionCategory.system,
    code: AppErrorCode.notFound,
    message: '$resourceが見つかりません',
  );

  /// 同時更新エラー
  static AppException concurrentUpdate([String? message]) => AppException(
    category: ExceptionCategory.system,
    code: AppErrorCode.concurrentUpdate,
    message: message ?? 'データが他のユーザーによって更新されました',
  );

  /// ストレージエラー
  static AppException storageError([String? message, Object? originalError]) =>
      AppException(
        category: ExceptionCategory.system,
        code: AppErrorCode.storageError,
        message: message ?? 'ストレージエラーが発生しました',
        originalError: originalError,
      );

  /// 広告読み込みエラー
  static AppException adLoadFailed([Object? originalError]) => AppException(
    category: ExceptionCategory.system,
    code: AppErrorCode.adLoadFailed,
    message: '広告の読み込みに失敗しました',
    originalError: originalError,
  );

  /// 購入エラー
  static AppException purchaseError([String? message, Object? originalError]) =>
      AppException(
        category: ExceptionCategory.system,
        code: AppErrorCode.purchaseError,
        message: message ?? '購入処理中にエラーが発生しました',
        originalError: originalError,
      );

  /// 購入機能未設定エラー
  static AppException purchaseNotConfigured() => const AppException(
    category: ExceptionCategory.system,
    code: AppErrorCode.purchaseNotConfigured,
    message: '購入機能が初期化されていません',
  );

  // ============== Fatal Category ==============

  /// 不明なエラー
  static AppException unknown([String? message, Object? originalError]) =>
      AppException(
        category: ExceptionCategory.fatal,
        code: AppErrorCode.unknown,
        message: message ?? '予期しないエラーが発生しました',
        originalError: originalError,
      );

  /// カスタムエラー
  ///
  /// 特定のケースに合わせてカスタムエラーを作成する
  static AppException custom({
    required ExceptionCategory category,
    required AppErrorCode code,
    required String message,
    Object? originalError,
    StackTrace? stackTrace,
  }) => AppException(
    category: category,
    code: code,
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}
