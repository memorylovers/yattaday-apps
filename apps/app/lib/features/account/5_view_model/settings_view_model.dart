import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../_authentication/3_store/auth_store.dart';

part 'settings_view_model.freezed.dart';
part 'settings_view_model.g.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  const factory SettingsPageState({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SettingsPageState;
}

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  SettingsPageState build() {
    return const SettingsPageState();
  }

  Future<void> signOut({
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      await ref.read(authStoreProvider.notifier).signOut();
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
}
