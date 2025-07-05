// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_edit_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemsEditPageState {
  RecordItemFormState get formState => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  RecordItem get recordItem => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemsEditPageStateCopyWith<RecordItemsEditPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemsEditPageStateCopyWith<$Res> {
  factory $RecordItemsEditPageStateCopyWith(
    RecordItemsEditPageState value,
    $Res Function(RecordItemsEditPageState) then,
  ) = _$RecordItemsEditPageStateCopyWithImpl<$Res, RecordItemsEditPageState>;
  @useResult
  $Res call({
    RecordItemFormState formState,
    String? userId,
    RecordItem recordItem,
  });

  $RecordItemFormStateCopyWith<$Res> get formState;
  $RecordItemCopyWith<$Res> get recordItem;
}

/// @nodoc
class _$RecordItemsEditPageStateCopyWithImpl<
  $Res,
  $Val extends RecordItemsEditPageState
>
    implements $RecordItemsEditPageStateCopyWith<$Res> {
  _$RecordItemsEditPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formState = null,
    Object? userId = freezed,
    Object? recordItem = null,
  }) {
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
            recordItem:
                null == recordItem
                    ? _value.recordItem
                    : recordItem // ignore: cast_nullable_to_non_nullable
                        as RecordItem,
          )
          as $Val,
    );
  }

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecordItemFormStateCopyWith<$Res> get formState {
    return $RecordItemFormStateCopyWith<$Res>(_value.formState, (value) {
      return _then(_value.copyWith(formState: value) as $Val);
    });
  }

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecordItemCopyWith<$Res> get recordItem {
    return $RecordItemCopyWith<$Res>(_value.recordItem, (value) {
      return _then(_value.copyWith(recordItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordItemsEditPageStateImplCopyWith<$Res>
    implements $RecordItemsEditPageStateCopyWith<$Res> {
  factory _$$RecordItemsEditPageStateImplCopyWith(
    _$RecordItemsEditPageStateImpl value,
    $Res Function(_$RecordItemsEditPageStateImpl) then,
  ) = __$$RecordItemsEditPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecordItemFormState formState,
    String? userId,
    RecordItem recordItem,
  });

  @override
  $RecordItemFormStateCopyWith<$Res> get formState;
  @override
  $RecordItemCopyWith<$Res> get recordItem;
}

/// @nodoc
class __$$RecordItemsEditPageStateImplCopyWithImpl<$Res>
    extends
        _$RecordItemsEditPageStateCopyWithImpl<
          $Res,
          _$RecordItemsEditPageStateImpl
        >
    implements _$$RecordItemsEditPageStateImplCopyWith<$Res> {
  __$$RecordItemsEditPageStateImplCopyWithImpl(
    _$RecordItemsEditPageStateImpl _value,
    $Res Function(_$RecordItemsEditPageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formState = null,
    Object? userId = freezed,
    Object? recordItem = null,
  }) {
    return _then(
      _$RecordItemsEditPageStateImpl(
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
        recordItem:
            null == recordItem
                ? _value.recordItem
                : recordItem // ignore: cast_nullable_to_non_nullable
                    as RecordItem,
      ),
    );
  }
}

/// @nodoc

class _$RecordItemsEditPageStateImpl implements _RecordItemsEditPageState {
  const _$RecordItemsEditPageStateImpl({
    required this.formState,
    required this.userId,
    required this.recordItem,
  });

  @override
  final RecordItemFormState formState;
  @override
  final String? userId;
  @override
  final RecordItem recordItem;

  @override
  String toString() {
    return 'RecordItemsEditPageState(formState: $formState, userId: $userId, recordItem: $recordItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemsEditPageStateImpl &&
            (identical(other.formState, formState) ||
                other.formState == formState) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordItem, recordItem) ||
                other.recordItem == recordItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, formState, userId, recordItem);

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemsEditPageStateImplCopyWith<_$RecordItemsEditPageStateImpl>
  get copyWith => __$$RecordItemsEditPageStateImplCopyWithImpl<
    _$RecordItemsEditPageStateImpl
  >(this, _$identity);
}

abstract class _RecordItemsEditPageState implements RecordItemsEditPageState {
  const factory _RecordItemsEditPageState({
    required final RecordItemFormState formState,
    required final String? userId,
    required final RecordItem recordItem,
  }) = _$RecordItemsEditPageStateImpl;

  @override
  RecordItemFormState get formState;
  @override
  String? get userId;
  @override
  RecordItem get recordItem;

  /// Create a copy of RecordItemsEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemsEditPageStateImplCopyWith<_$RecordItemsEditPageStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
