// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_detail_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordItemDetailPageState {
  DateTime get selectedMonth => throw _privateConstructorUsedError;
  AsyncValue<RecordItem?> get recordItem => throw _privateConstructorUsedError;
  AsyncValue<RecordItemStatistics> get statistics =>
      throw _privateConstructorUsedError;
  AsyncValue<bool> get todayRecordExists => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  String? get deleteError => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemDetailPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemDetailPageStateCopyWith<RecordItemDetailPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemDetailPageStateCopyWith<$Res> {
  factory $RecordItemDetailPageStateCopyWith(
    RecordItemDetailPageState value,
    $Res Function(RecordItemDetailPageState) then,
  ) = _$RecordItemDetailPageStateCopyWithImpl<$Res, RecordItemDetailPageState>;
  @useResult
  $Res call({
    DateTime selectedMonth,
    AsyncValue<RecordItem?> recordItem,
    AsyncValue<RecordItemStatistics> statistics,
    AsyncValue<bool> todayRecordExists,
    bool isDeleting,
    String? deleteError,
  });
}

/// @nodoc
class _$RecordItemDetailPageStateCopyWithImpl<
  $Res,
  $Val extends RecordItemDetailPageState
>
    implements $RecordItemDetailPageStateCopyWith<$Res> {
  _$RecordItemDetailPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemDetailPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMonth = null,
    Object? recordItem = null,
    Object? statistics = null,
    Object? todayRecordExists = null,
    Object? isDeleting = null,
    Object? deleteError = freezed,
  }) {
    return _then(
      _value.copyWith(
            selectedMonth:
                null == selectedMonth
                    ? _value.selectedMonth
                    : selectedMonth // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            recordItem:
                null == recordItem
                    ? _value.recordItem
                    : recordItem // ignore: cast_nullable_to_non_nullable
                        as AsyncValue<RecordItem?>,
            statistics:
                null == statistics
                    ? _value.statistics
                    : statistics // ignore: cast_nullable_to_non_nullable
                        as AsyncValue<RecordItemStatistics>,
            todayRecordExists:
                null == todayRecordExists
                    ? _value.todayRecordExists
                    : todayRecordExists // ignore: cast_nullable_to_non_nullable
                        as AsyncValue<bool>,
            isDeleting:
                null == isDeleting
                    ? _value.isDeleting
                    : isDeleting // ignore: cast_nullable_to_non_nullable
                        as bool,
            deleteError:
                freezed == deleteError
                    ? _value.deleteError
                    : deleteError // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordItemDetailPageStateImplCopyWith<$Res>
    implements $RecordItemDetailPageStateCopyWith<$Res> {
  factory _$$RecordItemDetailPageStateImplCopyWith(
    _$RecordItemDetailPageStateImpl value,
    $Res Function(_$RecordItemDetailPageStateImpl) then,
  ) = __$$RecordItemDetailPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime selectedMonth,
    AsyncValue<RecordItem?> recordItem,
    AsyncValue<RecordItemStatistics> statistics,
    AsyncValue<bool> todayRecordExists,
    bool isDeleting,
    String? deleteError,
  });
}

/// @nodoc
class __$$RecordItemDetailPageStateImplCopyWithImpl<$Res>
    extends
        _$RecordItemDetailPageStateCopyWithImpl<
          $Res,
          _$RecordItemDetailPageStateImpl
        >
    implements _$$RecordItemDetailPageStateImplCopyWith<$Res> {
  __$$RecordItemDetailPageStateImplCopyWithImpl(
    _$RecordItemDetailPageStateImpl _value,
    $Res Function(_$RecordItemDetailPageStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemDetailPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMonth = null,
    Object? recordItem = null,
    Object? statistics = null,
    Object? todayRecordExists = null,
    Object? isDeleting = null,
    Object? deleteError = freezed,
  }) {
    return _then(
      _$RecordItemDetailPageStateImpl(
        selectedMonth:
            null == selectedMonth
                ? _value.selectedMonth
                : selectedMonth // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        recordItem:
            null == recordItem
                ? _value.recordItem
                : recordItem // ignore: cast_nullable_to_non_nullable
                    as AsyncValue<RecordItem?>,
        statistics:
            null == statistics
                ? _value.statistics
                : statistics // ignore: cast_nullable_to_non_nullable
                    as AsyncValue<RecordItemStatistics>,
        todayRecordExists:
            null == todayRecordExists
                ? _value.todayRecordExists
                : todayRecordExists // ignore: cast_nullable_to_non_nullable
                    as AsyncValue<bool>,
        isDeleting:
            null == isDeleting
                ? _value.isDeleting
                : isDeleting // ignore: cast_nullable_to_non_nullable
                    as bool,
        deleteError:
            freezed == deleteError
                ? _value.deleteError
                : deleteError // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$RecordItemDetailPageStateImpl implements _RecordItemDetailPageState {
  const _$RecordItemDetailPageStateImpl({
    required this.selectedMonth,
    required this.recordItem,
    required this.statistics,
    required this.todayRecordExists,
    this.isDeleting = false,
    this.deleteError,
  });

  @override
  final DateTime selectedMonth;
  @override
  final AsyncValue<RecordItem?> recordItem;
  @override
  final AsyncValue<RecordItemStatistics> statistics;
  @override
  final AsyncValue<bool> todayRecordExists;
  @override
  @JsonKey()
  final bool isDeleting;
  @override
  final String? deleteError;

  @override
  String toString() {
    return 'RecordItemDetailPageState(selectedMonth: $selectedMonth, recordItem: $recordItem, statistics: $statistics, todayRecordExists: $todayRecordExists, isDeleting: $isDeleting, deleteError: $deleteError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemDetailPageStateImpl &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            (identical(other.recordItem, recordItem) ||
                other.recordItem == recordItem) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics) &&
            (identical(other.todayRecordExists, todayRecordExists) ||
                other.todayRecordExists == todayRecordExists) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.deleteError, deleteError) ||
                other.deleteError == deleteError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedMonth,
    recordItem,
    statistics,
    todayRecordExists,
    isDeleting,
    deleteError,
  );

  /// Create a copy of RecordItemDetailPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemDetailPageStateImplCopyWith<_$RecordItemDetailPageStateImpl>
  get copyWith => __$$RecordItemDetailPageStateImplCopyWithImpl<
    _$RecordItemDetailPageStateImpl
  >(this, _$identity);
}

abstract class _RecordItemDetailPageState implements RecordItemDetailPageState {
  const factory _RecordItemDetailPageState({
    required final DateTime selectedMonth,
    required final AsyncValue<RecordItem?> recordItem,
    required final AsyncValue<RecordItemStatistics> statistics,
    required final AsyncValue<bool> todayRecordExists,
    final bool isDeleting,
    final String? deleteError,
  }) = _$RecordItemDetailPageStateImpl;

  @override
  DateTime get selectedMonth;
  @override
  AsyncValue<RecordItem?> get recordItem;
  @override
  AsyncValue<RecordItemStatistics> get statistics;
  @override
  AsyncValue<bool> get todayRecordExists;
  @override
  bool get isDeleting;
  @override
  String? get deleteError;

  /// Create a copy of RecordItemDetailPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemDetailPageStateImplCopyWith<_$RecordItemDetailPageStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
