// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordItemImpl _$$RecordItemImplFromJson(
  Map<String, dynamic> json,
) => _$RecordItemImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  icon: json['icon'] as String,
  unit: json['unit'] as String?,
  sortOrder: (json['sortOrder'] as num).toInt(),
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$$RecordItemImplToJson(_$RecordItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'unit': instance.unit,
      'sortOrder': instance.sortOrder,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
