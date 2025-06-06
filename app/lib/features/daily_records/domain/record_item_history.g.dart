// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordItemHistoryImpl _$$RecordItemHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$RecordItemHistoryImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: json['date'] as String,
  recordItemId: json['recordItemId'] as String,
  note: json['note'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$$RecordItemHistoryImplToJson(
  _$RecordItemHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date,
  'recordItemId': instance.recordItemId,
  'note': instance.note,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
};
