import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/providers/service_providers.dart';
import '../../../common/types/types.dart';
import '../1_models/auth_repository.dart';
import '../2_repository/firebase_auth_repository.dart';

part 'auth_store.freezed.dart';
part 'auth_store.g.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({required String uid}) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

// repositories
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return FirebaseAuthRepository(authService);
});

/// 認証状態
@Riverpod(keepAlive: true)
class AuthStore extends _$AuthStore {
  @override
  Future<AuthState?> build() async {
    // FirebaseAuthが認証済みなら、認証済みとする
    final user = await ref.watch(firebaseUserProvider.future);
    return user != null ? AuthState(uid: user.uid) : null;
  }

  /// ログイン
  Future<void> signIn(AuthType type) async {
    await ref.read(authRepositoryProvider).signIn(type);
  }

  /// ログアウト
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  /// 退会
  Future<void> delete() async {
    await ref.read(authRepositoryProvider).delete();
  }

  /// アカウントの連携
  Future<void> linkAccount(AuthType type) async {
    await ref.read(authRepositoryProvider).linkAccount(type);
  }
}

// アプリが初回起動かチェックして、初回起動の場合はサインアウトする
@riverpod
Future<void> authSignOutWhenFirstRun(Ref ref) async {
  final service = ref.watch(sharedPreferencesServiceProvider);
  
  if (service.isFirstRun) {
    await FirebaseAuth.instance.signOut();
    await service.setIsFirstRun(false);
  }
}
