// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordItemStatisticsImpl _$$RecordItemStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$RecordItemStatisticsImpl(
  totalCount: (json['totalCount'] as num).toInt(),
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  firstRecordDate:
      json['firstRecordDate'] == null
          ? null
          : DateTime.parse(json['firstRecordDate'] as String),
  lastRecordDate:
      json['lastRecordDate'] == null
          ? null
          : DateTime.parse(json['lastRecordDate'] as String),
  thisMonthCount: (json['thisMonthCount'] as num).toInt(),
  thisWeekCount: (json['thisWeekCount'] as num).toInt(),
);

Map<String, dynamic> _$$RecordItemStatisticsImplToJson(
  _$RecordItemStatisticsImpl instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'firstRecordDate': instance.firstRecordDate?.toIso8601String(),
  'lastRecordDate': instance.lastRecordDate?.toIso8601String(),
  'thisMonthCount': instance.thisMonthCount,
  'thisWeekCount': instance.thisWeekCount,
};
