import 'app_error_code.dart';

class AppException implements Exception {
  final AppErrorCode code;
  final String? message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException({
    this.code = AppErrorCode.unknown,
    this.message,
    this.cause,
    this.stackTrace,
  });

  // String message(L10n l10n) => code.toMessage(l10n);

  @override
  String toString() {
    return "Error: $code";
  }
}
