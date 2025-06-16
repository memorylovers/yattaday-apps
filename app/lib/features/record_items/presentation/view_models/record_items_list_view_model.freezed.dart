// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_items_list_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemsListPageState {
  DateTime get selectedDate => throw _privateConstructorUsedError;
  Set<String> get completedItemIds => throw _privateConstructorUsedError;
  AsyncValue<List<RecordItem>> get recordItemsAsync =>
      throw _privateConstructorUsedError;

  /// Create a copy of RecordItemsListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemsListPageStateCopyWith<RecordItemsListPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemsListPageStateCopyWith<$Res> {
  factory $RecordItemsListPageStateCopyWith(
    RecordItemsListPageState value,
    $Res Function(RecordItemsListPageState) then,
  ) = _$RecordItemsListPageStateCopyWithImpl<$Res, RecordItemsListPageState>;
  @useResult
  $Res call({
    DateTime selectedDate,
    Set<String> completedItemIds,
    AsyncValue<List<RecordItem>> recordItemsAsync,
  });
}

/// @nodoc
class _$RecordItemsListPageStateCopyWithImpl<
  $Res,
  $Val extends RecordItemsListPageState
>
    implements $RecordItemsListPageStateCopyWith<$Res> {
  _$RecordItemsListPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemsListPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? completedItemIds = null,
    Object? recordItemsAsync = null,
  }) {
    return _then(
      _value.copyWith(
            selectedDate:
                null == selectedDate
                    ? _value.selectedDate
                    : selectedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedItemIds:
                null == completedItemIds
                    ? _value.completedItemIds
                    : completedItemIds // ignore: cast_nullable_to_non_nullable
                        as Set<String>,
            recordItemsAsync:
                null == recordItemsAsync
                    ? _value.recordItemsAsync
                    : recordItemsAsync // ignore: cast_nullable_to_non_nullable
                        as AsyncValue<List<RecordItem>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordItemsListPageStateImplCopyWith<$Res>
    implements $RecordItemsListPageStateCopyWith<$Res> {
  factory _$$RecordItemsListPageStateImplCopyWith(
    _$RecordItemsListPageStateImpl value,
    $Res Function(_$RecordItemsListPageStateImpl) then,
  ) = __$$RecordItemsListPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime selectedDate,
    Set<String> completedItemIds,
    AsyncValue<List<RecordItem>> recordItemsAsync,
  });
}

/// @nodoc
class __$$RecordItemsListPageStateImplCopyWithImpl<$Res>
    extends
        _$RecordItemsListPageStateCopyWithImpl<
          $Res,
          _$RecordItemsListPageStateImpl
        >
    implements _$$RecordItemsListPageStateImplCopyWith<$Res> {
  __$$RecordItemsListPageStateImplCopyWithImpl(
    _$RecordItemsListPageStateImpl _value,
    $Res Function(_$RecordItemsListPageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemsListPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? completedItemIds = null,
    Object? recordItemsAsync = null,
  }) {
    return _then(
      _$RecordItemsListPageStateImpl(
        selectedDate:
            null == selectedDate
                ? _value.selectedDate
                : selectedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedItemIds:
            null == completedItemIds
                ? _value._completedItemIds
                : completedItemIds // ignore: cast_nullable_to_non_nullable
                    as Set<String>,
        recordItemsAsync:
            null == recordItemsAsync
                ? _value.recordItemsAsync
                : recordItemsAsync // ignore: cast_nullable_to_non_nullable
                    as AsyncValue<List<RecordItem>>,
      ),
    );
  }
}

/// @nodoc

class _$RecordItemsListPageStateImpl implements _RecordItemsListPageState {
  const _$RecordItemsListPageStateImpl({
    required this.selectedDate,
    final Set<String> completedItemIds = const {},
    required this.recordItemsAsync,
  }) : _completedItemIds = completedItemIds;

  @override
  final DateTime selectedDate;
  final Set<String> _completedItemIds;
  @override
  @JsonKey()
  Set<String> get completedItemIds {
    if (_completedItemIds is EqualUnmodifiableSetView) return _completedItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_completedItemIds);
  }

  @override
  final AsyncValue<List<RecordItem>> recordItemsAsync;

  @override
  String toString() {
    return 'RecordItemsListPageState(selectedDate: $selectedDate, completedItemIds: $completedItemIds, recordItemsAsync: $recordItemsAsync)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemsListPageStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            const DeepCollectionEquality().equals(
              other._completedItemIds,
              _completedItemIds,
            ) &&
            (identical(other.recordItemsAsync, recordItemsAsync) ||
                other.recordItemsAsync == recordItemsAsync));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedDate,
    const DeepCollectionEquality().hash(_completedItemIds),
    recordItemsAsync,
  );

  /// Create a copy of RecordItemsListPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemsListPageStateImplCopyWith<_$RecordItemsListPageStateImpl>
  get copyWith => __$$RecordItemsListPageStateImplCopyWithImpl<
    _$RecordItemsListPageStateImpl
  >(this, _$identity);
}

abstract class _RecordItemsListPageState implements RecordItemsListPageState {
  const factory _RecordItemsListPageState({
    required final DateTime selectedDate,
    final Set<String> completedItemIds,
    required final AsyncValue<List<RecordItem>> recordItemsAsync,
  }) = _$RecordItemsListPageStateImpl;

  @override
  DateTime get selectedDate;
  @override
  Set<String> get completedItemIds;
  @override
  AsyncValue<List<RecordItem>> get recordItemsAsync;

  /// Create a copy of RecordItemsListPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemsListPageStateImplCopyWith<_$RecordItemsListPageStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
