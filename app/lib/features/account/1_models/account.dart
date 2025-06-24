import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/json_converter/datetime_converter.dart';

part 'account.freezed.dart';
part 'account.g.dart';

/// アカウント設定を含むユーザ情報。他のユーザには非公開
@freezed
class Account with _$Account {
  const factory Account({
    required String uid,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
