// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecordItem _$RecordItemFromJson(Map<String, dynamic> json) {
  return _RecordItem.fromJson(json);
}

/// @nodoc
mixin _$RecordItem {
  /// 記録項目ID（uuid v7）
  String get id => throw _privateConstructorUsedError;

  /// 所有者のユーザーID
  String get userId => throw _privateConstructorUsedError;

  /// 記録項目の名前
  String get title => throw _privateConstructorUsedError;

  /// 記録項目の説明（オプション）
  String? get description => throw _privateConstructorUsedError;

  /// 単位（例：回、分、ページなど）
  String? get unit => throw _privateConstructorUsedError;

  /// 表示順序
  int get sortOrder => throw _privateConstructorUsedError;

  /// 作成日時
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最終更新日時
  @DateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RecordItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecordItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecordItemCopyWith<RecordItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordItemCopyWith<$Res> {
  factory $RecordItemCopyWith(
    RecordItem value,
    $Res Function(RecordItem) then,
  ) = _$RecordItemCopyWithImpl<$Res, RecordItem>;
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String? description,
    String? unit,
    int sortOrder,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$RecordItemCopyWithImpl<$Res, $Val extends RecordItem>
    implements $RecordItemCopyWith<$Res> {
  _$RecordItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecordItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? unit = freezed,
    Object? sortOrder = null,
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
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            unit:
                freezed == unit
                    ? _value.unit
                    : unit // ignore: cast_nullable_to_non_nullable
                        as String?,
            sortOrder:
                null == sortOrder
                    ? _value.sortOrder
                    : sortOrder // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$RecordItemImplCopyWith<$Res>
    implements $RecordItemCopyWith<$Res> {
  factory _$$RecordItemImplCopyWith(
    _$RecordItemImpl value,
    $Res Function(_$RecordItemImpl) then,
  ) = __$$RecordItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String title,
    String? description,
    String? unit,
    int sortOrder,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$RecordItemImplCopyWithImpl<$Res>
    extends _$RecordItemCopyWithImpl<$Res, _$RecordItemImpl>
    implements _$$RecordItemImplCopyWith<$Res> {
  __$$RecordItemImplCopyWithImpl(
    _$RecordItemImpl _value,
    $Res Function(_$RecordItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecordItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? unit = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RecordItemImpl(
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
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        unit:
            freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                    as String?,
        sortOrder:
            null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$RecordItemImpl implements _RecordItem {
  const _$RecordItemImpl({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.unit,
    required this.sortOrder,
    @DateTimeConverter() required this.createdAt,
    @DateTimeConverter() required this.updatedAt,
  });

  factory _$RecordItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecordItemImplFromJson(json);

  /// 記録項目ID（uuid v7）
  @override
  final String id;

  /// 所有者のユーザーID
  @override
  final String userId;

  /// 記録項目の名前
  @override
  final String title;

  /// 記録項目の説明（オプション）
  @override
  final String? description;

  /// 単位（例：回、分、ページなど）
  @override
  final String? unit;

  /// 表示順序
  @override
  final int sortOrder;

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
    return 'RecordItem(id: $id, userId: $userId, title: $title, description: $description, unit: $unit, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
    title,
    description,
    unit,
    sortOrder,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RecordItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordItemImplCopyWith<_$RecordItemImpl> get copyWith =>
      __$$RecordItemImplCopyWithImpl<_$RecordItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecordItemImplToJson(this);
  }
}

abstract class _RecordItem implements RecordItem {
  const factory _RecordItem({
    required final String id,
    required final String userId,
    required final String title,
    final String? description,
    final String? unit,
    required final int sortOrder,
    @DateTimeConverter() required final DateTime createdAt,
    @DateTimeConverter() required final DateTime updatedAt,
  }) = _$RecordItemImpl;

  factory _RecordItem.fromJson(Map<String, dynamic> json) =
      _$RecordItemImpl.fromJson;

  /// 記録項目ID（uuid v7）
  @override
  String get id;

  /// 所有者のユーザーID
  @override
  String get userId;

  /// 記録項目の名前
  @override
  String get title;

  /// 記録項目の説明（オプション）
  @override
  String? get description;

  /// 単位（例：回、分、ページなど）
  @override
  String? get unit;

  /// 表示順序
  @override
  int get sortOrder;

  /// 作成日時
  @override
  @DateTimeConverter()
  DateTime get createdAt;

  /// 最終更新日時
  @override
  @DateTimeConverter()
  DateTime get updatedAt;

  /// Create a copy of RecordItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecordItemImplCopyWith<_$RecordItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
