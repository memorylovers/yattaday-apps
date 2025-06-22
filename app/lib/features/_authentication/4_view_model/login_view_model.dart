import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/types/types.dart';
import '../3_application/auth_store.dart';

part 'login_view_model.freezed.dart';
part 'login_view_model.g.dart';

@freezed
class LoginPageState with _$LoginPageState {
  const factory LoginPageState({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _LoginPageState;
}

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginPageState build() {
    return const LoginPageState();
  }

  Future<void> signIn(AuthType authType) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await ref.read(authStoreProvider.notifier).signIn(authType);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signInGoogle() async {
    await signIn(AuthType.google);
  }

  Future<void> signInApple() async {
    await signIn(AuthType.apple);
  }

  Future<void> signInAnonymous() async {
    await signIn(AuthType.anonymous);
  }
}
