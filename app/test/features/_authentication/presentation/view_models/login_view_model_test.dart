import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/common/types/types.dart';
import 'package:myapp/features/_authentication/application/auth_providers.dart';
import 'package:myapp/features/_authentication/presentation/view_models/login_view_model.dart';

class MockAuthStore extends AuthStore {
  final List<AuthType> signInCalls = [];
  Exception? signInException;

  @override
  Future<void> signIn(AuthType type) async {
    signInCalls.add(type);
    if (signInException != null) {
      throw signInException!;
    }
  }

  @override
  Future<AuthState?> build() async {
    return null;
  }
}

void main() {
  group('LoginViewModel', () {
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

    test('初期状態はisLoadingがfalseでerrorMessageがnull', () {
      final state = container.read(loginViewModelProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('signInメソッドが成功した場合、isLoadingがfalseに戻る', () async {
      final viewModel = container.read(loginViewModelProvider.notifier);
      await viewModel.signIn(AuthType.google);

      final state = container.read(loginViewModelProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(mockAuthStore.signInCalls, [AuthType.google]);
    });

    test('signInメソッドでエラーが発生した場合、errorMessageが設定される', () async {
      const errorMessage = 'ログインに失敗しました';
      mockAuthStore.signInException = Exception(errorMessage);

      final viewModel = container.read(loginViewModelProvider.notifier);
      await viewModel.signIn(AuthType.google);

      final state = container.read(loginViewModelProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, contains(errorMessage));
    });

    test('signIn中はisLoadingがtrueになる', () async {
      final viewModel = container.read(loginViewModelProvider.notifier);
      final future = viewModel.signIn(AuthType.apple);

      // signIn開始直後の状態を確認
      expect(container.read(loginViewModelProvider).isLoading, true);

      await future;

      // signIn完了後の状態を確認
      expect(container.read(loginViewModelProvider).isLoading, false);
    });

    test('各認証タイプでsignInが呼ばれることを確認', () async {
      final viewModel = container.read(loginViewModelProvider.notifier);

      // Google認証
      await viewModel.signIn(AuthType.google);
      expect(mockAuthStore.signInCalls, [AuthType.google]);

      // Apple認証
      await viewModel.signIn(AuthType.apple);
      expect(mockAuthStore.signInCalls, [AuthType.google, AuthType.apple]);

      // 匿名認証
      await viewModel.signIn(AuthType.anonymous);
      expect(mockAuthStore.signInCalls, [
        AuthType.google,
        AuthType.apple,
        AuthType.anonymous,
      ]);
    });
  });
}
