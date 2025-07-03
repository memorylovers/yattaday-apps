import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_type.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// 認証ユーザー情報のドメインモデル
///
/// Firebase Authに依存しない、アプリケーション独自の認証ユーザーモデル。
/// Repository層でFirebaseのUserオブジェクトから変換される。
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    /// ユーザーID
    required String uid,

    /// メールアドレス
    String? email,

    /// 表示名
    String? displayName,

    /// プロフィール画像URL
    String? photoUrl,

    /// 匿名ユーザーかどうか
    @Default(false) bool isAnonymous,

    /// メールアドレスが確認済みかどうか
    @Default(false) bool isEmailVerified,

    /// 電話番号
    String? phoneNumber,

    /// 認証プロバイダーの種類
    @Default([]) List<AuthType> authTypes,

    /// アカウント作成日時
    DateTime? createdAt,

    /// 最終ログイン日時
    DateTime? lastSignInAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
