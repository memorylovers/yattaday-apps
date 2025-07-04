import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/features/_authentication/3_store/auth_store.dart';
import 'package:myapp/features/_authentication/5_view_model/login_view_model.dart';

/// AuthStore用のフェイク実装
class FakeAuthStoreNotifier extends AuthStore {
  Exception? _errorToThrow;
  AuthType? _lastSignInType;
  int _signInCallCount = 0;

  void setErrorToThrow(Exception? error) {
    _errorToThrow = error;
  }

  AuthType? get lastSignInType => _lastSignInType;
  int get signInCallCount => _signInCallCount;

  @override
  Stream<AuthState?> build() {
    return Stream.value(null);
  }

  @override
  Future<void> signIn(AuthType type) async {
    _lastSignInType = type;
    _signInCallCount++;
    
    if (_errorToThrow != null) {
      throw _errorToThrow!;
    }
    
    // 少し遅延を入れて非同期処理をシミュレート
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

void main() {
  group('LoginViewModel', () {
    late ProviderContainer container;
    late FakeAuthStoreNotifier fakeAuthStore;

    setUp(() {
      fakeAuthStore = FakeAuthStoreNotifier();
      container = ProviderContainer(
        overrides: [
          authStoreProvider.overrideWith(() => fakeAuthStore),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('初期状態が正しく設定される', () {
        final state = container.read(loginViewModelProvider);

        expect(state.isLoading, isFalse);
        expect(state.errorMessage, isNull);
      });
    });

    group('signIn', () {
      test('サインイン中はローディング状態になる', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);

        // サインインを開始（awaitしない）
        final future = viewModel.signIn(AuthType.google);

        // 直後の状態を確認
        expect(container.read(loginViewModelProvider).isLoading, isTrue);
        expect(container.read(loginViewModelProvider).errorMessage, isNull);

        // 完了を待つ
        await future;

        // 完了後の状態を確認
        expect(container.read(loginViewModelProvider).isLoading, isFalse);
      });

      test('サインインに成功した場合、エラーメッセージがクリアされる', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);

        await viewModel.signIn(AuthType.google);

        final state = container.read(loginViewModelProvider);
        expect(state.isLoading, isFalse);
        expect(state.errorMessage, isNull);
        expect(fakeAuthStore.lastSignInType, equals(AuthType.google));
      });

      test('サインインに失敗した場合、エラーメッセージが設定される', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);
        fakeAuthStore.setErrorToThrow(Exception('ネットワークエラー'));

        await viewModel.signIn(AuthType.google);

        final state = container.read(loginViewModelProvider);
        expect(state.isLoading, isFalse);
        expect(state.errorMessage, contains('ネットワークエラー'));
      });

      test('エラー後に再度サインインを試みるとエラーメッセージがクリアされる', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);
        
        // 最初のサインイン（失敗）
        fakeAuthStore.setErrorToThrow(Exception('エラー1'));
        await viewModel.signIn(AuthType.google);
        expect(container.read(loginViewModelProvider).errorMessage, contains('エラー1'));

        // エラーをクリア
        fakeAuthStore.setErrorToThrow(null);

        // 2回目のサインイン（成功）
        await viewModel.signIn(AuthType.google);
        expect(container.read(loginViewModelProvider).errorMessage, isNull);
      });
    });

    group('signInGoogle', () {
      test('Googleサインインが正しく呼び出される', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);

        await viewModel.signInGoogle();

        expect(fakeAuthStore.lastSignInType, equals(AuthType.google));
        expect(fakeAuthStore.signInCallCount, equals(1));
      });
    });

    group('signInApple', () {
      test('Appleサインインが正しく呼び出される', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);

        await viewModel.signInApple();

        expect(fakeAuthStore.lastSignInType, equals(AuthType.apple));
        expect(fakeAuthStore.signInCallCount, equals(1));
      });
    });

    group('signInAnonymous', () {
      test('匿名サインインが正しく呼び出される', () async {
        final viewModel = container.read(loginViewModelProvider.notifier);

        await viewModel.signInAnonymous();

        expect(fakeAuthStore.lastSignInType, equals(AuthType.anonymous));
        expect(fakeAuthStore.signInCallCount, equals(1));
      });
    });

    group('LoginPageState', () {
      test('copyWithが正しく動作する', () {
        const initialState = LoginPageState(
          isLoading: false,
          errorMessage: null,
        );

        final loadingState = initialState.copyWith(isLoading: true);
        expect(loadingState.isLoading, isTrue);
        expect(loadingState.errorMessage, isNull);

        final errorState = initialState.copyWith(errorMessage: 'エラー');
        expect(errorState.isLoading, isFalse);
        expect(errorState.errorMessage, equals('エラー'));

        final completeState = loadingState.copyWith(
          isLoading: false,
          errorMessage: 'エラーメッセージ',
        );
        expect(completeState.isLoading, isFalse);
        expect(completeState.errorMessage, equals('エラーメッセージ'));
      });
    });
  });
}