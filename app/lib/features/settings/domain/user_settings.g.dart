// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$UserSettingsImpl(
  userId: json['userId'] as String,
  locale: json['locale'] as String,
  notificationsEnabled: json['notificationsEnabled'] as bool,
  notificationTime: json['notificationTime'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'locale': instance.locale,
      'notificationsEnabled': instance.notificationsEnabled,
      'notificationTime': instance.notificationTime,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
