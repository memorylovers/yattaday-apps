// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecordItemHistory _$RecordItemHistoryFromJson(Map<String, dynamic> json) {
  return _RecordItemHistory.fromJson(json);
}

/// @nodoc
mixin _$RecordItemHistory {
  /// 日次記録ID（uuid v7）
  String get id => throw _privateConstructorUsedError;

  /// ユーザーID
  String get userId => throw _privateConstructorUsedError;

  /// 記録日（yyyy-MM-dd形式）
  String get date => throw _privateConstructorUsedError;

  /// 記録項目ID
  String get recordItemId => throw _privateConstructorUsedError;

  /// メモ（将来拡張用）
  String? get note => throw _privateConstructorUsedError;

  /// 作成日時
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最終更新日時
  @DateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RecordItemHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordItemHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemHistoryCopyWith<RecordItemHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemHistoryCopyWith<$Res> {
  factory $RecordItemHistoryCopyWith(
    RecordItemHistory value,
    $Res Function(RecordItemHistory) then,
  ) = _$RecordItemHistoryCopyWithImpl<$Res, RecordItemHistory>;
  @useResult
  $Res call({
    String id,
    String userId,
    String date,
    String recordItemId,
    String? note,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$RecordItemHistoryCopyWithImpl<$Res, $Val extends RecordItemHistory>
    implements $RecordItemHistoryCopyWith<$Res> {
  _$RecordItemHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItemHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? recordItemId = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as String,
            recordItemId:
                null == recordItemId
                    ? _value.recordItemId
                    : recordItemId // ignore: cast_nullable_to_non_nullable
                        as String,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordItemHistoryImplCopyWith<$Res>
    implements $RecordItemHistoryCopyWith<$Res> {
  factory _$$RecordItemHistoryImplCopyWith(
    _$RecordItemHistoryImpl value,
    $Res Function(_$RecordItemHistoryImpl) then,
  ) = __$$RecordItemHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String date,
    String recordItemId,
    String? note,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$RecordItemHistoryImplCopyWithImpl<$Res>
    extends _$RecordItemHistoryCopyWithImpl<$Res, _$RecordItemHistoryImpl>
    implements _$$RecordItemHistoryImplCopyWith<$Res> {
  __$$RecordItemHistoryImplCopyWithImpl(
    _$RecordItemHistoryImpl _value,
    $Res Function(_$RecordItemHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItemHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? recordItemId = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RecordItemHistoryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as String,
        recordItemId:
            null == recordItemId
                ? _value.recordItemId
                : recordItemId // ignore: cast_nullable_to_non_nullable
                    as String,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecordItemHistoryImpl implements _RecordItemHistory {
  const _$RecordItemHistoryImpl({
    required this.id,
    required this.userId,
    required this.date,
    required this.recordItemId,
    this.note,
    @DateTimeConverter() required this.createdAt,
    @DateTimeConverter() required this.updatedAt,
  });

  factory _$RecordItemHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordItemHistoryImplFromJson(json);

  /// 日次記録ID（uuid v7）
  @override
  final String id;

  /// ユーザーID
  @override
  final String userId;

  /// 記録日（yyyy-MM-dd形式）
  @override
  final String date;

  /// 記録項目ID
  @override
  final String recordItemId;

  /// メモ（将来拡張用）
  @override
  final String? note;

  /// 作成日時
  @override
  @DateTimeConverter()
  final DateTime createdAt;

  /// 最終更新日時
  @override
  @DateTimeConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RecordItemHistory(id: $id, userId: $userId, date: $date, recordItemId: $recordItemId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.recordItemId, recordItemId) ||
                other.recordItemId == recordItemId) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    date,
    recordItemId,
    note,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RecordItemHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemHistoryImplCopyWith<_$RecordItemHistoryImpl> get copyWith =>
      __$$RecordItemHistoryImplCopyWithImpl<_$RecordItemHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordItemHistoryImplToJson(this);
  }
}

abstract class _RecordItemHistory implements RecordItemHistory {
  const factory _RecordItemHistory({
    required final String id,
    required final String userId,
    required final String date,
    required final String recordItemId,
    final String? note,
    @DateTimeConverter() required final DateTime createdAt,
    @DateTimeConverter() required final DateTime updatedAt,
  }) = _$RecordItemHistoryImpl;

  factory _RecordItemHistory.fromJson(Map<String, dynamic> json) =
      _$RecordItemHistoryImpl.fromJson;

  /// 日次記録ID（uuid v7）
  @override
  String get id;

  /// ユーザーID
  @override
  String get userId;

  /// 記録日（yyyy-MM-dd形式）
  @override
  String get date;

  /// 記録項目ID
  @override
  String get recordItemId;

  /// メモ（将来拡張用）
  @override
  String? get note;

  /// 作成日時
  @override
  @DateTimeConverter()
  DateTime get createdAt;

  /// 最終更新日時
  @override
  @DateTimeConverter()
  DateTime get updatedAt;

  /// Create a copy of RecordItemHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemHistoryImplCopyWith<_$RecordItemHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
