import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../1_models/auth_type.dart';
import '../3_store/auth_store.dart';

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

  Future<void> signIn(
    AuthType authType, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await ref.read(authStoreProvider.notifier).signIn(authType);
      state = state.copyWith(isLoading: false);

      // 成功時の副作用を実行
      onSuccess?.call();
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);

      // エラー時の副作用を実行
      onError?.call(errorMessage);
    }
  }

  Future<void> signInGoogle({
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    await signIn(AuthType.google, onSuccess: onSuccess, onError: onError);
  }

  Future<void> signInApple({
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    await signIn(AuthType.apple, onSuccess: onSuccess, onError: onError);
  }

  Future<void> signInAnonymous({
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    await signIn(AuthType.anonymous, onSuccess: onSuccess, onError: onError);
  }
}
