// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_create_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemsCreatePageState {
  RecordItemFormState get formState => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemsCreatePageStateCopyWith<RecordItemsCreatePageState>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemsCreatePageStateCopyWith<$Res> {
  factory $RecordItemsCreatePageStateCopyWith(
    RecordItemsCreatePageState value,
    $Res Function(RecordItemsCreatePageState) then,
  ) =
      _$RecordItemsCreatePageStateCopyWithImpl<
        $Res,
        RecordItemsCreatePageState
      >;
  @useResult
  $Res call({RecordItemFormState formState, String? userId});

  $RecordItemFormStateCopyWith<$Res> get formState;
}

/// @nodoc
class _$RecordItemsCreatePageStateCopyWithImpl<
  $Res,
  $Val extends RecordItemsCreatePageState
>
    implements $RecordItemsCreatePageStateCopyWith<$Res> {
  _$RecordItemsCreatePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? formState = null, Object? userId = freezed}) {
    return _then(
      _value.copyWith(
            formState:
                null == formState
                    ? _value.formState
                    : formState // ignore: cast_nullable_to_non_nullable
                        as RecordItemFormState,
            userId:
                freezed == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecordItemFormStateCopyWith<$Res> get formState {
    return $RecordItemFormStateCopyWith<$Res>(_value.formState, (value) {
      return _then(_value.copyWith(formState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordItemsCreatePageStateImplCopyWith<$Res>
    implements $RecordItemsCreatePageStateCopyWith<$Res> {
  factory _$$RecordItemsCreatePageStateImplCopyWith(
    _$RecordItemsCreatePageStateImpl value,
    $Res Function(_$RecordItemsCreatePageStateImpl) then,
  ) = __$$RecordItemsCreatePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RecordItemFormState formState, String? userId});

  @override
  $RecordItemFormStateCopyWith<$Res> get formState;
}

/// @nodoc
class __$$RecordItemsCreatePageStateImplCopyWithImpl<$Res>
    extends
        _$RecordItemsCreatePageStateCopyWithImpl<
          $Res,
          _$RecordItemsCreatePageStateImpl
        >
    implements _$$RecordItemsCreatePageStateImplCopyWith<$Res> {
  __$$RecordItemsCreatePageStateImplCopyWithImpl(
    _$RecordItemsCreatePageStateImpl _value,
    $Res Function(_$RecordItemsCreatePageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? formState = null, Object? userId = freezed}) {
    return _then(
      _$RecordItemsCreatePageStateImpl(
        formState:
            null == formState
                ? _value.formState
                : formState // ignore: cast_nullable_to_non_nullable
                    as RecordItemFormState,
        userId:
            freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$RecordItemsCreatePageStateImpl implements _RecordItemsCreatePageState {
  const _$RecordItemsCreatePageStateImpl({
    required this.formState,
    required this.userId,
  });

  @override
  final RecordItemFormState formState;
  @override
  final String? userId;

  @override
  String toString() {
    return 'RecordItemsCreatePageState(formState: $formState, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemsCreatePageStateImpl &&
            (identical(other.formState, formState) ||
                other.formState == formState) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, formState, userId);

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemsCreatePageStateImplCopyWith<_$RecordItemsCreatePageStateImpl>
  get copyWith => __$$RecordItemsCreatePageStateImplCopyWithImpl<
    _$RecordItemsCreatePageStateImpl
  >(this, _$identity);
}

abstract class _RecordItemsCreatePageState
    implements RecordItemsCreatePageState {
  const factory _RecordItemsCreatePageState({
    required final RecordItemFormState formState,
    required final String? userId,
  }) = _$RecordItemsCreatePageStateImpl;

  @override
  RecordItemFormState get formState;
  @override
  String? get userId;

  /// Create a copy of RecordItemsCreatePageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemsCreatePageStateImplCopyWith<_$RecordItemsCreatePageStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
