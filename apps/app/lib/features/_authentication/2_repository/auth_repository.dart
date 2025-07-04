import 'package:firebase_auth/firebase_auth.dart';

import '../../../common/exception/handling_error.dart';
import '../../../services/firebase/auth_service.dart';
import '../1_models/auth_type.dart';
import '../1_models/auth_user.dart';

/// 認証関連のリポジトリ
///
/// Firebase Authに依存しない認証機能の抽象化。
/// 具体的な認証プロバイダーの実装詳細を隠蔽する。
abstract class AuthRepository {
  /// 認証状態の監視
  ///
  /// 認証状態の変化をリアルタイムで監視するStreamを返す。
  /// ログイン/ログアウト時に自動的に更新される。
  ///
  /// 戻り値:
  /// - ログイン中: [AuthUser]インスタンス
  /// - 未ログイン: null
  Stream<AuthUser?> watchAuthState();

  /// 現在の認証ユーザーを取得
  ///
  /// 現在ログインしているユーザー情報を取得する。
  ///
  /// 戻り値:
  /// - ログイン中: [AuthUser]インスタンス
  /// - 未ログイン: null
  Future<AuthUser?> getCurrentUser();

  /// サインイン
  ///
  /// 指定された認証プロバイダーでサインインする。
  ///
  /// [type] 認証プロバイダーの種類
  ///
  /// 例外:
  /// - 認証失敗: [AppException]
  /// - ネットワークエラー: [AppException]
  Future<void> signIn(AuthType type);

  /// サインアウト
  ///
  /// 現在のユーザーをサインアウトさせる。
  ///
  /// 例外:
  /// - サインアウト失敗: [AppException]
  Future<void> signOut();

  /// アカウントのリンク
  ///
  /// 現在のアカウントに別の認証プロバイダーをリンクする。
  ///
  /// [type] リンクする認証プロバイダーの種類
  ///
  /// 例外:
  /// - 既にリンク済み: [AppException]
  /// - リンク失敗: [AppException]
  Future<void> linkAccount(AuthType type);

  /// アカウントの削除
  ///
  /// 現在のユーザーアカウントを完全に削除する。
  ///
  /// 例外:
  /// - 削除失敗: [AppException]
  Future<void> delete();
}

/// Firebase Auth実装
class FirebaseAuthRepository implements AuthRepository {
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