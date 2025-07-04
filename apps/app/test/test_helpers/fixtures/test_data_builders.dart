import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/features/_authentication/1_models/auth_user.dart';
import 'package:myapp/features/account/1_models/account.dart';
import 'package:myapp/features/account/1_models/profile.dart';
import 'package:myapp/features/account/1_models/user_settings.dart';

/// テスト用のAuthUserを作成
AuthUser createTestAuthUser({
  String? uid,
  String? email,
  String? displayName,
  String? photoUrl,
  bool? isAnonymous,
  bool? isEmailVerified,
  String? phoneNumber,
  List<AuthType>? authTypes,
  DateTime? createdAt,
  DateTime? lastSignInAt,
}) {
  return AuthUser(
    uid: uid ?? 'test-user-id',
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    isAnonymous: isAnonymous ?? false,
    isEmailVerified: isEmailVerified ?? false,
    phoneNumber: phoneNumber,
    authTypes: authTypes ?? [],
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    lastSignInAt: lastSignInAt ?? DateTime(2024, 1, 1),
  );
}

/// テスト用のAccountを作成
Account createTestAccount({
  String? uid,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Account(
    uid: uid ?? 'test-user-id',
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    updatedAt: updatedAt ?? DateTime(2024, 1, 1),
  );
}

/// テスト用のAccountProfileを作成
AccountProfile createTestAccountProfile({
  String? uid,
  String? displayName,
  String? avatarUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return AccountProfile(
    uid: uid ?? 'test-user-id',
    displayName: displayName ?? '',
    avatarUrl: avatarUrl,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    updatedAt: updatedAt ?? DateTime(2024, 1, 1),
  );
}

/// テスト用のUserSettingsを作成
UserSettings createTestUserSettings({
  String? userId,
  String? locale,
  bool? notificationsEnabled,
  String? notificationTime,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return UserSettings(
    userId: userId ?? 'test-user-id',
    locale: locale ?? 'ja',
    notificationsEnabled: notificationsEnabled ?? true,
    notificationTime: notificationTime,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    updatedAt: updatedAt ?? DateTime(2024, 1, 1),
  );
}
