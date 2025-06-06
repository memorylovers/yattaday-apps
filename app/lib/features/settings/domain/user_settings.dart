import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/json_converter/datetime_converter.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// ユーザー設定のモデル
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    /// ユーザーID
    required String userId,

    /// 言語設定（ja, en）
    required String locale,

    /// 通知有効フラグ
    required bool notificationsEnabled,

    /// 通知時刻（HH:mm形式）
    String? notificationTime,

    /// 作成日時
    @DateTimeConverter() required DateTime createdAt,

    /// 最終更新日時
    @DateTimeConverter() required DateTime updatedAt,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  /// firestoreのcollection path
  static String get collectionPath => "user_settings";

  static FromFirestore<UserSettings> get fromFirestore =>
      (snapshot, _) => UserSettings.fromJson(snapshot.data() ?? {});

  static ToFirestore<UserSettings> get toFirestore =>
      (data, _) => data.toJson();
}

extension UserSettingsExtension on UserSettings {
  /// 通知時刻をTimeOfDayに変換
  TimeOfDay? get notificationTimeOfDay {
    if (notificationTime == null) return null;
    final parts = notificationTime!.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }
}
