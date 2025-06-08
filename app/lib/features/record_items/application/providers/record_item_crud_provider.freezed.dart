// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_crud_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemCrudState {
  bool get isProcessing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemCrudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemCrudStateCopyWith<RecordItemCrudState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemCrudStateCopyWith<$Res> {
  factory $RecordItemCrudStateCopyWith(
    RecordItemCrudState value,
    $Res Function(RecordItemCrudState) then,
  ) = _$RecordItemCrudStateCopyWithImpl<$Res, RecordItemCrudState>;
  @useResult
  $Res call({bool isProcessing, String? errorMessage});
}

/// @nodoc
class _$RecordItemCrudStateCopyWithImpl<$Res, $Val extends RecordItemCrudState>
    implements $RecordItemCrudStateCopyWith<$Res> {
  _$RecordItemCrudStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemCrudState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isProcessing = null, Object? errorMessage = freezed}) {
    return _then(
      _value.copyWith(
            isProcessing:
                null == isProcessing
                    ? _value.isProcessing
                    : isProcessing // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordItemCrudStateImplCopyWith<$Res>
    implements $RecordItemCrudStateCopyWith<$Res> {
  factory _$$RecordItemCrudStateImplCopyWith(
    _$RecordItemCrudStateImpl value,
    $Res Function(_$RecordItemCrudStateImpl) then,
  ) = __$$RecordItemCrudStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isProcessing, String? errorMessage});
}

/// @nodoc
class __$$RecordItemCrudStateImplCopyWithImpl<$Res>
    extends _$RecordItemCrudStateCopyWithImpl<$Res, _$RecordItemCrudStateImpl>
    implements _$$RecordItemCrudStateImplCopyWith<$Res> {
  __$$RecordItemCrudStateImplCopyWithImpl(
    _$RecordItemCrudStateImpl _value,
    $Res Function(_$RecordItemCrudStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemCrudState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isProcessing = null, Object? errorMessage = freezed}) {
    return _then(
      _$RecordItemCrudStateImpl(
        isProcessing:
            null == isProcessing
                ? _value.isProcessing
                : isProcessing // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$RecordItemCrudStateImpl implements _RecordItemCrudState {
  const _$RecordItemCrudStateImpl({
    this.isProcessing = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RecordItemCrudState(isProcessing: $isProcessing, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemCrudStateImpl &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isProcessing, errorMessage);

  /// Create a copy of RecordItemCrudState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemCrudStateImplCopyWith<_$RecordItemCrudStateImpl> get copyWith =>
      __$$RecordItemCrudStateImplCopyWithImpl<_$RecordItemCrudStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RecordItemCrudState implements RecordItemCrudState {
  const factory _RecordItemCrudState({
    final bool isProcessing,
    final String? errorMessage,
  }) = _$RecordItemCrudStateImpl;

  @override
  bool get isProcessing;
  @override
  String? get errorMessage;

  /// Create a copy of RecordItemCrudState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemCrudStateImplCopyWith<_$RecordItemCrudStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
