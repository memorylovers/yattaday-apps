import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/providers/firebase_providers.dart';
import '../../features/_authentication/1_models/auth_type.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth: firebaseAuth);
});

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  User? get currentUser => _firebaseAuth.currentUser;

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
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  /// Googleでサインイン
  Future<User?> signInWithGoogle() async {
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
      throw Exception('Not supported platform');
    }
  }

  /// Appleでサインイン
  Future<User?> signInWithApple() async {
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
  }

  /// アカウントをリンク
  Future<void> linkAccount(AuthType authType) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    switch (authType) {
      case AuthType.google:
        await _linkGoogleAccount(currentUser);
        break;
      case AuthType.apple:
        await _linkAppleAccount(currentUser);
        break;
      case AuthType.anonymous:
        throw Exception('Cannot link anonymous account');
    }
  }

  /// 再認証
  Future<void> reauthenticate(AuthType authType) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    switch (authType) {
      case AuthType.google:
        await _reauthenticateWithGoogle(currentUser);
        break;
      case AuthType.apple:
        await _reauthenticateWithApple(currentUser);
        break;
      case AuthType.anonymous:
        throw Exception('Cannot reauthenticate anonymous account');
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// アカウントを削除
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

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
          rethrow;
        }
      } else {
        rethrow;
      }
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
