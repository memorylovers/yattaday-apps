import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../_authentication/3_application/auth_store.dart';

part 'settings_view_model.freezed.dart';
part 'settings_view_model.g.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  const factory SettingsPageState({@Default(false) bool isLoading}) =
      _SettingsPageState;
}

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  SettingsPageState build() {
    return const SettingsPageState();
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      await ref.read(authStoreProvider.notifier).signOut();
    } catch (e) {
      // エラーが発生してもローディング状態を解除する
      // TODO: エラー処理の実装
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
