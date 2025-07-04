// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppException {
  /// エラーカテゴリ
  ExceptionCategory get category => throw _privateConstructorUsedError;

  /// エラーコード
  AppErrorCode get code => throw _privateConstructorUsedError;

  /// エラーメッセージ
  String get message => throw _privateConstructorUsedError;

  /// 元の例外オブジェクト
  Object? get originalError => throw _privateConstructorUsedError;

  /// スタックトレース
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppExceptionCopyWith<AppException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
    AppException value,
    $Res Function(AppException) then,
  ) = _$AppExceptionCopyWithImpl<$Res, AppException>;
  @useResult
  $Res call({
    ExceptionCategory category,
    AppErrorCode code,
    String message,
    Object? originalError,
    StackTrace? stackTrace,
  });
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? code = null,
    Object? message = null,
    Object? originalError = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _value.copyWith(
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as ExceptionCategory,
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as AppErrorCode,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            originalError:
                freezed == originalError ? _value.originalError : originalError,
            stackTrace:
                freezed == stackTrace
                    ? _value.stackTrace
                    : stackTrace // ignore: cast_nullable_to_non_nullable
                        as StackTrace?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$AppExceptionImplCopyWith(
    _$AppExceptionImpl value,
    $Res Function(_$AppExceptionImpl) then,
  ) = __$$AppExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ExceptionCategory category,
    AppErrorCode code,
    String message,
    Object? originalError,
    StackTrace? stackTrace,
  });
}

/// @nodoc
class __$$AppExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AppExceptionImpl>
    implements _$$AppExceptionImplCopyWith<$Res> {
  __$$AppExceptionImplCopyWithImpl(
    _$AppExceptionImpl _value,
    $Res Function(_$AppExceptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? code = null,
    Object? message = null,
    Object? originalError = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _$AppExceptionImpl(
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as ExceptionCategory,
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as AppErrorCode,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        originalError:
            freezed == originalError ? _value.originalError : originalError,
        stackTrace:
            freezed == stackTrace
                ? _value.stackTrace
                : stackTrace // ignore: cast_nullable_to_non_nullable
                    as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$AppExceptionImpl extends _AppException {
  const _$AppExceptionImpl({
    required this.category,
    required this.code,
    required this.message,
    this.originalError,
    this.stackTrace,
  }) : super._();

  /// エラーカテゴリ
  @override
  final ExceptionCategory category;

  /// エラーコード
  @override
  final AppErrorCode code;

  /// エラーメッセージ
  @override
  final String message;

  /// 元の例外オブジェクト
  @override
  final Object? originalError;

  /// スタックトレース
  @override
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppExceptionImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    code,
    message,
    const DeepCollectionEquality().hash(originalError),
    stackTrace,
  );

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppExceptionImplCopyWith<_$AppExceptionImpl> get copyWith =>
      __$$AppExceptionImplCopyWithImpl<_$AppExceptionImpl>(this, _$identity);
}

abstract class _AppException extends AppException {
  const factory _AppException({
    required final ExceptionCategory category,
    required final AppErrorCode code,
    required final String message,
    final Object? originalError,
    final StackTrace? stackTrace,
  }) = _$AppExceptionImpl;
  const _AppException._() : super._();

  /// エラーカテゴリ
  @override
  ExceptionCategory get category;

  /// エラーコード
  @override
  AppErrorCode get code;

  /// エラーメッセージ
  @override
  String get message;

  /// 元の例外オブジェクト
  @override
  Object? get originalError;

  /// スタックトレース
  @override
  StackTrace? get stackTrace;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppExceptionImplCopyWith<_$AppExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
