import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/exception/handling_error.dart';
import '../../../../common/providers/service_providers.dart';
import '../../../../services/firebase/auth_service.dart';
import '../../1_models/auth_type.dart';
import '../../1_models/auth_user.dart';
import '../interfaces/auth_repository.dart';

// repositories
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return FirebaseAuthRepository(authService);
});

/// AuthRepositoryのFirebase Auth実装
class FirebaseAuthRepository implements IAuthRepository {
  final AuthService _authService;

  FirebaseAuthRepository(this._authService);

  @override
  Stream<AuthUser?> watchAuthState() {
    return _authService.userChanges.map((firebaseUser) {
      return _convertToAuthUser(firebaseUser);
    });
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final firebaseUser = _authService.currentUser;
    return _convertToAuthUser(firebaseUser);
  }

  @override
  Future<void> signIn(AuthType type) async {
    try {
      await _authService.signIn(type);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> linkAccount(AuthType type) async {
    try {
      await _authService.linkAccount(type);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> delete() async {
    try {
      await _authService.deleteAccount();
    } catch (error) {
      handleError(error);
    }
  }

  /// Firebase UserをAuthUserドメインモデルに変換
  ///
  /// Firebase依存のUserオブジェクトを
  /// アプリケーション独自のAuthUserモデルに変換する。
  AuthUser? _convertToAuthUser(User? firebaseUser) {
    if (firebaseUser == null) return null;

    // 認証プロバイダーの種類を取得
    final authTypes = <AuthType>[];

    // 匿名認証の場合
    if (firebaseUser.isAnonymous) {
      authTypes.add(AuthType.anonymous);
    }

    // その他のプロバイダー
    for (final info in firebaseUser.providerData) {
      final authType = authTypeFromProviderId(info.providerId);
      if (authType != null && !authTypes.contains(authType)) {
        authTypes.add(authType);
      }
    }

    return AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isAnonymous: firebaseUser.isAnonymous,
      isEmailVerified: firebaseUser.emailVerified,
      phoneNumber: firebaseUser.phoneNumber,
      authTypes: authTypes,
      createdAt: firebaseUser.metadata.creationTime,
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
    );
  }
}
