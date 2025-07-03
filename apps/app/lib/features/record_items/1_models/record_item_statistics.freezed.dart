// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecordItemStatistics _$RecordItemStatisticsFromJson(Map<String, dynamic> json) {
  return _RecordItemStatistics.fromJson(json);
}

/// @nodoc
mixin _$RecordItemStatistics {
  /// 合計記録回数
  int get totalCount => throw _privateConstructorUsedError;

  /// 現在の連続記録日数
  int get currentStreak => throw _privateConstructorUsedError;

  /// 最長連続記録日数
  int get longestStreak => throw _privateConstructorUsedError;

  /// 最初の記録日
  DateTime? get firstRecordDate => throw _privateConstructorUsedError;

  /// 最後の記録日
  DateTime? get lastRecordDate => throw _privateConstructorUsedError;

  /// 今月の記録回数
  int get thisMonthCount => throw _privateConstructorUsedError;

  /// 今週の記録回数
  int get thisWeekCount => throw _privateConstructorUsedError;

  /// Serializes this RecordItemStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemStatisticsCopyWith<RecordItemStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemStatisticsCopyWith<$Res> {
  factory $RecordItemStatisticsCopyWith(
    RecordItemStatistics value,
    $Res Function(RecordItemStatistics) then,
  ) = _$RecordItemStatisticsCopyWithImpl<$Res, RecordItemStatistics>;
  @useResult
  $Res call({
    int totalCount,
    int currentStreak,
    int longestStreak,
    DateTime? firstRecordDate,
    DateTime? lastRecordDate,
    int thisMonthCount,
    int thisWeekCount,
  });
}

/// @nodoc
class _$RecordItemStatisticsCopyWithImpl<
  $Res,
  $Val extends RecordItemStatistics
>
    implements $RecordItemStatisticsCopyWith<$Res> {
  _$RecordItemStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? firstRecordDate = freezed,
    Object? lastRecordDate = freezed,
    Object? thisMonthCount = null,
    Object? thisWeekCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalCount:
                null == totalCount
                    ? _value.totalCount
                    : totalCount // ignore: cast_nullable_to_non_nullable
                        as int,
            currentStreak:
                null == currentStreak
                    ? _value.currentStreak
                    : currentStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            longestStreak:
                null == longestStreak
                    ? _value.longestStreak
                    : longestStreak // ignore: cast_nullable_to_non_nullable
                        as int,
            firstRecordDate:
                freezed == firstRecordDate
                    ? _value.firstRecordDate
                    : firstRecordDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastRecordDate:
                freezed == lastRecordDate
                    ? _value.lastRecordDate
                    : lastRecordDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            thisMonthCount:
                null == thisMonthCount
                    ? _value.thisMonthCount
                    : thisMonthCount // ignore: cast_nullable_to_non_nullable
                        as int,
            thisWeekCount:
                null == thisWeekCount
                    ? _value.thisWeekCount
                    : thisWeekCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordItemStatisticsImplCopyWith<$Res>
    implements $RecordItemStatisticsCopyWith<$Res> {
  factory _$$RecordItemStatisticsImplCopyWith(
    _$RecordItemStatisticsImpl value,
    $Res Function(_$RecordItemStatisticsImpl) then,
  ) = __$$RecordItemStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCount,
    int currentStreak,
    int longestStreak,
    DateTime? firstRecordDate,
    DateTime? lastRecordDate,
    int thisMonthCount,
    int thisWeekCount,
  });
}

/// @nodoc
class __$$RecordItemStatisticsImplCopyWithImpl<$Res>
    extends _$RecordItemStatisticsCopyWithImpl<$Res, _$RecordItemStatisticsImpl>
    implements _$$RecordItemStatisticsImplCopyWith<$Res> {
  __$$RecordItemStatisticsImplCopyWithImpl(
    _$RecordItemStatisticsImpl _value,
    $Res Function(_$RecordItemStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? firstRecordDate = freezed,
    Object? lastRecordDate = freezed,
    Object? thisMonthCount = null,
    Object? thisWeekCount = null,
  }) {
    return _then(
      _$RecordItemStatisticsImpl(
        totalCount:
            null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                    as int,
        currentStreak:
            null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        longestStreak:
            null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                    as int,
        firstRecordDate:
            freezed == firstRecordDate
                ? _value.firstRecordDate
                : firstRecordDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastRecordDate:
            freezed == lastRecordDate
                ? _value.lastRecordDate
                : lastRecordDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        thisMonthCount:
            null == thisMonthCount
                ? _value.thisMonthCount
                : thisMonthCount // ignore: cast_nullable_to_non_nullable
                    as int,
        thisWeekCount:
            null == thisWeekCount
                ? _value.thisWeekCount
                : thisWeekCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordItemStatisticsImpl implements _RecordItemStatistics {
  const _$RecordItemStatisticsImpl({
    required this.totalCount,
    required this.currentStreak,
    required this.longestStreak,
    this.firstRecordDate,
    this.lastRecordDate,
    required this.thisMonthCount,
    required this.thisWeekCount,
  });

  factory _$RecordItemStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordItemStatisticsImplFromJson(json);

  /// 合計記録回数
  @override
  final int totalCount;

  /// 現在の連続記録日数
  @override
  final int currentStreak;

  /// 最長連続記録日数
  @override
  final int longestStreak;

  /// 最初の記録日
  @override
  final DateTime? firstRecordDate;

  /// 最後の記録日
  @override
  final DateTime? lastRecordDate;

  /// 今月の記録回数
  @override
  final int thisMonthCount;

  /// 今週の記録回数
  @override
  final int thisWeekCount;

  @override
  String toString() {
    return 'RecordItemStatistics(totalCount: $totalCount, currentStreak: $currentStreak, longestStreak: $longestStreak, firstRecordDate: $firstRecordDate, lastRecordDate: $lastRecordDate, thisMonthCount: $thisMonthCount, thisWeekCount: $thisWeekCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemStatisticsImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.firstRecordDate, firstRecordDate) ||
                other.firstRecordDate == firstRecordDate) &&
            (identical(other.lastRecordDate, lastRecordDate) ||
                other.lastRecordDate == lastRecordDate) &&
            (identical(other.thisMonthCount, thisMonthCount) ||
                other.thisMonthCount == thisMonthCount) &&
            (identical(other.thisWeekCount, thisWeekCount) ||
                other.thisWeekCount == thisWeekCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    currentStreak,
    longestStreak,
    firstRecordDate,
    lastRecordDate,
    thisMonthCount,
    thisWeekCount,
  );

  /// Create a copy of RecordItemStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemStatisticsImplCopyWith<_$RecordItemStatisticsImpl>
  get copyWith =>
      __$$RecordItemStatisticsImplCopyWithImpl<_$RecordItemStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordItemStatisticsImplToJson(this);
  }
}

abstract class _RecordItemStatistics implements RecordItemStatistics {
  const factory _RecordItemStatistics({
    required final int totalCount,
    required final int currentStreak,
    required final int longestStreak,
    final DateTime? firstRecordDate,
    final DateTime? lastRecordDate,
    required final int thisMonthCount,
    required final int thisWeekCount,
  }) = _$RecordItemStatisticsImpl;

  factory _RecordItemStatistics.fromJson(Map<String, dynamic> json) =
      _$RecordItemStatisticsImpl.fromJson;

  /// 合計記録回数
  @override
  int get totalCount;

  /// 現在の連続記録日数
  @override
  int get currentStreak;

  /// 最長連続記録日数
  @override
  int get longestStreak;

  /// 最初の記録日
  @override
  DateTime? get firstRecordDate;

  /// 最後の記録日
  @override
  DateTime? get lastRecordDate;

  /// 今月の記録回数
  @override
  int get thisMonthCount;

  /// 今週の記録回数
  @override
  int get thisWeekCount;

  /// Create a copy of RecordItemStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemStatisticsImplCopyWith<_$RecordItemStatisticsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
