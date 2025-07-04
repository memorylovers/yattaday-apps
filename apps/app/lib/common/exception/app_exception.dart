import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_error_code.dart';
import 'exception_category.dart';

part 'app_exception.freezed.dart';

/// アプリケーション共通の例外クラス
///
/// エラーハンドリングガイドラインに基づいて、
/// すべての例外をこのクラスに変換して扱う。
@freezed
class AppException with _$AppException implements Exception {
  const factory AppException({
    /// エラーカテゴリ
    required ExceptionCategory category,

    /// エラーコード
    required AppErrorCode code,

    /// エラーメッセージ
    required String message,

    /// 元の例外オブジェクト
    Object? originalError,

    /// スタックトレース
    StackTrace? stackTrace,
  }) = _AppException;

  const AppException._();

  @override
  String toString() {
    return 'AppException(category: $category, code: $code, message: $message)';
  }
}
