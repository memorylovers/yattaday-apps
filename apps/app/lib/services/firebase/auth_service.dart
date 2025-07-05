import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/exception/app_exception.dart';
import '../../common/exception/app_exception_helpers.dart';
import '../../common/exception/handling_error.dart';
import '../../features/_authentication/1_models/auth_type.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(firebaseAuth: FirebaseAuth.instance);
});

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  /// FirebaseAuthExceptionをAppExceptionに変換
  AppException _convertFirebaseAuthException(FirebaseAuthException e) {
    // handling_error.dartの_convertFirebaseExceptionを使用
    handleError(e);
    // ここには到達しないが、コンパイラのために必要
    throw AppExceptions.unknown(e.message, e);
  }

  /// 認証タイプに基づいてサインイン
  Future<User?> signIn(AuthType authType) async {
    switch (authType) {
      case AuthType.anonymous:
        return signInAnonymously();
      case AuthType.google:
        return signInWithGoogle();
      case AuthType.apple:
        return signInWithApple();
    }
  }

  /// 匿名でサインイン
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      throw AppExceptions.unknown('匿名サインインに失敗しました', e);
    }
  }

  /// Googleでサインイン
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        return userCredential.user;
      } else if (Platform.isAndroid || Platform.isIOS) {
        final credential = await _googleOAuth();
        if (credential == null) return null;

        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        return userCredential.user;
      } else {
        throw AppExceptions.unknown('サポートされていないプラットフォームです', null);
      }
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      throw AppExceptions.unknown('Googleサインインに失敗しました', e);
    }
  }

  /// Appleでサインイン
  Future<User?> signInWithApple() async {
    try {
      final provider =
          AppleAuthProvider()
            ..addScope('email')
            ..addScope('name');

      if (kIsWeb) {
        final userCredential = await _firebaseAuth.signInWithPopup(provider);
        return userCredential.user;
      } else {
        final userCredential = await _firebaseAuth.signInWithProvider(provider);
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      throw AppExceptions.unknown('Appleサインインに失敗しました', e);
    }
  }

  /// アカウントをリンク
  Future<void> linkAccount(AuthType authType) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw AppExceptions.noAuth('認証されていません');
      }

      switch (authType) {
        case AuthType.google:
          await _linkGoogleAccount(currentUser);
          break;
        case AuthType.apple:
          await _linkAppleAccount(currentUser);
          break;
        case AuthType.anonymous:
          throw AppExceptions.validationError('匿名アカウントはリンクできません');
      }
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppExceptions.unknown('アカウントリンクに失敗しました', e);
    }
  }

  /// 再認証
  Future<void> reauthenticate(AuthType authType) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw AppExceptions.noAuth('認証されていません');
      }

      switch (authType) {
        case AuthType.google:
          await _reauthenticateWithGoogle(currentUser);
          break;
        case AuthType.apple:
          await _reauthenticateWithApple(currentUser);
          break;
        case AuthType.anonymous:
          throw AppExceptions.validationError('匿名アカウントは再認証できません');
      }
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppExceptions.unknown('再認証に失敗しました', e);
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _convertFirebaseAuthException(e);
    } catch (e) {
      throw AppExceptions.unknown('サインアウトに失敗しました', e);
    }
  }

  /// アカウントを削除
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AppExceptions.noAuth('認証されていません');
      }

      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // 再認証が必要な場合は、ユーザーの認証タイプを判定して再認証
          final authType = _getCurrentAuthType();
          if (authType != null && authType != AuthType.anonymous) {
            await reauthenticate(authType);
            await user.delete();
          } else {
            throw _convertFirebaseAuthException(e);
          }
        } else {
          throw _convertFirebaseAuthException(e);
        }
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppExceptions.unknown('アカウント削除に失敗しました', e);
    }
  }

  /// 現在のユーザーの認証タイプを取得
  AuthType? _getCurrentAuthType() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    if (user.isAnonymous) {
      return AuthType.anonymous;
    }

    final providers = user.providerData.map((info) => info.providerId);
    if (providers.contains('google.com')) {
      return AuthType.google;
    } else if (providers.contains('apple.com')) {
      return AuthType.apple;
    }

    return null;
  }

  /// Google OAuth認証（Android/iOSのみ）
  Future<OAuthCredential?> _googleOAuth() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await googleSignIn.signOut();
      return credential;
    } catch (e) {
      throw AppExceptions.unknown('Google認証に失敗しました', e);
    }
  }

  /// Googleアカウントをリンク
  Future<void> _linkGoogleAccount(User currentUser) async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await currentUser.linkWithPopup(googleProvider);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final credential = await _googleOAuth();
      if (credential == null) return;
      await currentUser.linkWithCredential(credential);
    } else {
      throw Exception('Not supported platform');
    }
  }

  /// Appleアカウントをリンク
  Future<void> _linkAppleAccount(User currentUser) async {
    final provider =
        AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

    if (kIsWeb) {
      await currentUser.linkWithPopup(provider);
    } else {
      await currentUser.linkWithProvider(provider);
    }
  }

  /// Googleで再認証
  Future<void> _reauthenticateWithGoogle(User currentUser) async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await currentUser.reauthenticateWithPopup(googleProvider);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final credential = await _googleOAuth();
      if (credential == null) return;
      await currentUser.reauthenticateWithCredential(credential);
    } else {
      throw Exception('Not supported platform');
    }
  }

  /// Appleで再認証
  Future<void> _reauthenticateWithApple(User currentUser) async {
    final provider =
        AppleAuthProvider()
          ..addScope('email')
          ..addScope('name');

    if (kIsWeb) {
      await currentUser.reauthenticateWithPopup(provider);
    } else {
      await currentUser.reauthenticateWithProvider(provider);
    }
  }
}

/// FirebaseAuthUserのextensions
extension FirebaseAuthUserEx on User {
  UserInfo? get google {
    return providerData.firstWhereOrNull((v) => v.providerId == 'google.com');
  }

  UserInfo? get apple {
    return providerData.firstWhereOrNull((v) => v.providerId == 'apple.com');
  }
}
