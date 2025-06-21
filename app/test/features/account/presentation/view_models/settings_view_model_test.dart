import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/3_application/auth_store.dart';
import 'package:myapp/features/account/4_view_model/settings_view_model.dart';

class MockAuthStore extends AuthStore {
  int signOutCallCount = 0;
  Exception? signOutException;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    if (signOutException != null) {
      throw signOutException!;
    }
  }

  @override
  Future<AuthState?> build() async {
    return null;
  }
}

void main() {
  group('SettingsViewModel', () {
    late ProviderContainer container;
    late MockAuthStore mockAuthStore;

    setUp(() {
      mockAuthStore = MockAuthStore();
      container = ProviderContainer(
        overrides: [authStoreProvider.overrideWith(() => mockAuthStore)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態はisLoadingがfalse', () {
      final state = container.read(settingsViewModelProvider);
      expect(state.isLoading, false);
    });

    test('signOutが成功した場合、isLoadingがfalseに戻る', () async {
      final viewModel = container.read(settingsViewModelProvider.notifier);
      await viewModel.signOut();

      final state = container.read(settingsViewModelProvider);
      expect(state.isLoading, false);
      expect(mockAuthStore.signOutCallCount, 1);
    });

    test('signOut中はisLoadingがtrueになる', () async {
      final viewModel = container.read(settingsViewModelProvider.notifier);
      final future = viewModel.signOut();

      // signOut開始直後の状態を確認
      expect(container.read(settingsViewModelProvider).isLoading, true);

      await future;

      // signOut完了後の状態を確認
      expect(container.read(settingsViewModelProvider).isLoading, false);
    });

    test('signOutでエラーが発生してもisLoadingがfalseに戻る', () async {
      mockAuthStore.signOutException = Exception('サインアウトに失敗しました');

      final viewModel = container.read(settingsViewModelProvider.notifier);
      await viewModel.signOut();

      final state = container.read(settingsViewModelProvider);
      expect(state.isLoading, false);
      expect(mockAuthStore.signOutCallCount, 1);
    });
  });
}
