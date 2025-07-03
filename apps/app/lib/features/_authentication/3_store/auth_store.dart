import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/providers/service_providers.dart';
import '../1_models/auth_type.dart';
import '../1_models/auth_user.dart';
import '../2_repository/firebase/firebase_auth_repository.dart';

part 'auth_store.freezed.dart';
part 'auth_store.g.dart';

/// 認証状態
///
/// ユーザーの認証情報を保持する状態クラス。
/// Firebaseに依存しないAuthUserモデルを使用。
@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    /// 認証ユーザー情報
    required AuthUser user,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  /// UIDの取得（互換性のため）
  String get uid => user.uid;
}

/// 認証状態管理Store
///
/// ユーザーの認証状態を管理し、ログイン/ログアウトの
/// 操作を提供する。Firebaseに依存しない実装。
@Riverpod(keepAlive: true)
class AuthStore extends _$AuthStore {
  @override
  Stream<AuthState?> build() {
    // Repository経由で認証状態を監視
    return ref.watch(authRepositoryProvider).watchAuthState().map((authUser) {
      return authUser != null ? AuthState(user: authUser) : null;
    });
  }

  /// ログイン
  ///
  /// 指定された認証プロバイダーでログインを実行する。
  ///
  /// [type] 使用する認証プロバイダー
  Future<void> signIn(AuthType type) async {
    await ref.read(authRepositoryProvider).signIn(type);
  }

  /// ログアウト
  ///
  /// 現在のユーザーをログアウトさせる。
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  /// 退会
  ///
  /// ユーザーアカウントを完全に削除する。
  /// この操作は取り消しできない。
  Future<void> delete() async {
    await ref.read(authRepositoryProvider).delete();
  }

  /// アカウントの連携
  ///
  /// 現在のアカウントに別の認証プロバイダーを連携する。
  ///
  /// [type] 連携する認証プロバイダー
  Future<void> linkAccount(AuthType type) async {
    await ref.read(authRepositoryProvider).linkAccount(type);
  }
}

/// アプリ初回起動時のサインアウト処理
///
/// アプリが初回起動の場合、前回の認証情報をクリアするため
/// 自動的にサインアウトを実行する。
@riverpod
Future<void> authSignOutWhenFirstRun(Ref ref) async {
  final service = ref.watch(sharedPreferencesServiceProvider);

  if (service.isFirstRun) {
    // Repository経由でサインアウト
    await ref.read(authRepositoryProvider).signOut();
    await service.setIsFirstRun(false);
  }
}
