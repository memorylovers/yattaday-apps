import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/3_store/auth_store.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';
import 'package:myapp/features/record_items/3_store/record_item_form_store.dart';
import 'package:myapp/features/record_items/5_view_model/record_items_create_view_model.dart';

import '../../../../test_helpers/fixtures/test_data_builders.dart';

/// AuthStore用のフェイク実装
class FakeAuthStoreNotifier extends AuthStore {
  AuthState? _state;

  void setState(AuthState? state) {
    _state = state;
  }

  @override
  Stream<AuthState?> build() {
    return Stream.value(_state);
  }
}

/// RecordItemFormNotifier用のフェイク実装
class FakeRecordItemFormNotifier extends RecordItemFormNotifier {
  final List<String> _methodCalls = [];
  bool _submitReturnValue = true;

  FakeRecordItemFormNotifier() : super(FakeRecordItemRepository());

  List<String> get methodCalls => List.unmodifiable(_methodCalls);

  void setSubmitReturnValue(bool value) {
    _submitReturnValue = value;
  }

  @override
  void updateTitle(String title) {
    _methodCalls.add('updateTitle:$title');
    super.updateTitle(title);
  }

  @override
  void updateDescription(String description) {
    _methodCalls.add('updateDescription:$description');
    super.updateDescription(description);
  }

  @override
  void updateIcon(String icon) {
    _methodCalls.add('updateIcon:$icon');
    super.updateIcon(icon);
  }

  @override
  void updateUnit(String unit) {
    _methodCalls.add('updateUnit:$unit');
    super.updateUnit(unit);
  }

  @override
  void clearError() {
    _methodCalls.add('clearError');
    super.clearError();
  }

  @override
  void reset() {
    _methodCalls.add('reset');
    super.reset();
  }

  @override
  Future<bool> submit(String userId) async {
    _methodCalls.add('submit:$userId');
    return _submitReturnValue;
  }
}

/// RecordItemRepository用のフェイク実装
class FakeRecordItemRepository implements RecordItemRepository {
  @override
  Future<void> create(recordItem) async {}

  @override
  Future<void> update(recordItem) async {}

  @override
  Future<void> delete(String userId, String recordItemId) async {}

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async => null;

  @override
  Future<List<RecordItem>> getByUserId(String userId) async => [];

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) => Stream.value([]);

  @override
  Future<int> getNextSortOrder(String userId) async => 0;
}

void main() {
  group('RecordItemsCreateViewModel', () {
    late ProviderContainer container;
    late FakeAuthStoreNotifier fakeAuthStore;
    late FakeRecordItemFormNotifier fakeFormNotifier;

    setUp(() {
      fakeAuthStore = FakeAuthStoreNotifier();
      fakeFormNotifier = FakeRecordItemFormNotifier();

      container = ProviderContainer(
        overrides: [
          authStoreProvider.overrideWith(() => fakeAuthStore),
          recordItemFormProvider.overrideWith((ref) => fakeFormNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('認証されていない場合、userIdがnullになる', () {
        fakeAuthStore.setState(null);
        fakeFormNotifier.state = const RecordItemFormState(title: 'Test');

        final state = container.read(recordItemsCreateViewModelProvider);

        expect(state.userId, isNull);
        expect(state.formState.title, equals('Test'));
      });

      test('認証されている場合、userIdが設定される', () {
        final authUser = createTestAuthUser(uid: 'user123');
        fakeAuthStore.setState(AuthState(user: authUser));
        fakeFormNotifier.state = const RecordItemFormState();

        final state = container.read(recordItemsCreateViewModelProvider);

        expect(state.userId, equals('user123'));
        expect(state.formState, equals(const RecordItemFormState()));
      });
    });

    group('フォーム操作メソッド', () {
      test('updateTitleが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.updateTitle('新しいタイトル');

        expect(fakeFormNotifier.methodCalls, contains('updateTitle:新しいタイトル'));
        expect(fakeFormNotifier.state.title, equals('新しいタイトル'));
      });

      test('updateDescriptionが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.updateDescription('説明文');

        expect(fakeFormNotifier.methodCalls, contains('updateDescription:説明文'));
        expect(fakeFormNotifier.state.description, equals('説明文'));
      });

      test('updateIconが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.updateIcon('🎯');

        expect(fakeFormNotifier.methodCalls, contains('updateIcon:🎯'));
        expect(fakeFormNotifier.state.icon, equals('🎯'));
      });

      test('updateUnitが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.updateUnit('回');

        expect(fakeFormNotifier.methodCalls, contains('updateUnit:回'));
        expect(fakeFormNotifier.state.unit, equals('回'));
      });

      test('clearErrorが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.clearError();

        expect(fakeFormNotifier.methodCalls, contains('clearError'));
      });

      test('resetが正しく呼び出される', () {
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        viewModel.reset();

        expect(fakeFormNotifier.methodCalls, contains('reset'));
      });
    });

    group('submit', () {
      test('ユーザーが認証されていない場合、falseを返す', () async {
        fakeAuthStore.setState(null);
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        final result = await viewModel.submit();

        expect(result, isFalse);
        expect(fakeFormNotifier.methodCalls, isEmpty);
      });

      test('ユーザーが認証されている場合、submitが呼び出される', () async {
        final authUser = createTestAuthUser(uid: 'user123');
        fakeAuthStore.setState(AuthState(user: authUser));
        fakeFormNotifier.setSubmitReturnValue(true);
        
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        final result = await viewModel.submit();

        expect(result, isTrue);
        expect(fakeFormNotifier.methodCalls, contains('submit:user123'));
      });

      test('submitが失敗した場合、falseを返す', () async {
        final authUser = createTestAuthUser(uid: 'user123');
        fakeAuthStore.setState(AuthState(user: authUser));
        fakeFormNotifier.setSubmitReturnValue(false);
        
        final viewModel = container.read(recordItemsCreateViewModelProvider.notifier);

        final result = await viewModel.submit();

        expect(result, isFalse);
        expect(fakeFormNotifier.methodCalls, contains('submit:user123'));
      });
    });

    group('RecordItemsCreatePageState', () {
      test('copyWithが正しく動作する', () {
        const formState1 = RecordItemFormState(title: 'Title1');
        const formState2 = RecordItemFormState(title: 'Title2');
        
        const initialState = RecordItemsCreatePageState(
          formState: formState1,
          userId: 'user1',
        );

        final newState = initialState.copyWith(
          formState: formState2,
          userId: 'user2',
        );

        expect(newState.formState, equals(formState2));
        expect(newState.userId, equals('user2'));
      });
    });
  });
}