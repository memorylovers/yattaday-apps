import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/json_converter/datetime_converter.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// アカウントのプロフィール。他のユーザに公開可
@freezed
class AccountProfile with _$AccountProfile {
  const factory AccountProfile({
    required String uid,

    /// 表示名
    @Default("") String displayName,

    /// アバター画像のURL
    String? avatarUrl,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _AccountProfile;

  factory AccountProfile.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileFromJson(json);
}
