import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/exception/handling_error.dart';
import '../../../common/providers/service_providers.dart';
import '../../../common/types/types.dart';
import '../../../services/firebase/auth_service.dart';
import 'auth_repository.dart';

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
  Future<void> me() {
    // TODO: implement me
    throw UnimplementedError();
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
}
