import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_application/providers/record_item_form_provider.dart';
import 'package:myapp/features/record_items/3_application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;
  int _nextSortOrder = 0;

  void setItems(List<RecordItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  void setException(Exception exception) {
    _exception = exception;
  }

  void clearException() {
    _exception = null;
  }

  void setNextSortOrder(int sortOrder) {
    _nextSortOrder = sortOrder;
  }

  List<RecordItem> get items => List.unmodifiable(_items);

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    if (_exception != null) throw _exception!;
    return _items.where((item) => item.userId == userId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    if (_exception != null) return Stream.error(_exception!);
    return Stream.value(
      _items.where((item) => item.userId == userId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }

  @override
  Future<void> create(RecordItem recordItem) async {
    if (_exception != null) throw _exception!;
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    if (_exception != null) throw _exception!;
    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) _items[index] = recordItem;
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );
  }

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;
    try {
      return _items.firstWhere(
        (item) => item.id == recordItemId && item.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    if (_exception != null) throw _exception!;
    return _nextSortOrder;
  }
}

void main() {
  group('RecordItemFormProvider', () {
    late ProviderContainer container;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      container = ProviderContainer(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('recordItemFormProvider', () {
      test('初期状態はRecordItemFormState.initial()', () {
        // Act
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.title, isEmpty);
        expect(state.description, isEmpty);
        expect(state.unit, isEmpty);
        expect(state.isValid, isFalse);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNull);
      });

      test('updateTitleでタイトルが更新される', () {
        // Arrange
        const newTitle = '読書';

        // Act
        container.read(recordItemFormProvider.notifier).updateTitle(newTitle);
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.title, equals(newTitle));
        expect(state.isValid, isTrue); // タイトルがあるので有効
      });

      test('updateDescriptionで説明が更新される', () {
        // Arrange
        const newDescription = '本を読んで知識を身につける';

        // Act
        container
            .read(recordItemFormProvider.notifier)
            .updateDescription(newDescription);
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.description, equals(newDescription));
      });

      test('updateUnitで単位が更新される', () {
        // Arrange
        const newUnit = 'ページ';

        // Act
        container.read(recordItemFormProvider.notifier).updateUnit(newUnit);
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.unit, equals(newUnit));
      });

      test('タイトルが空の場合はisValidがfalse', () {
        // Act
        container.read(recordItemFormProvider.notifier).updateTitle('');
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.isValid, isFalse);
      });

      test('タイトルが空白文字のみの場合もisValidがfalse', () {
        // Act
        container.read(recordItemFormProvider.notifier).updateTitle('   ');
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.isValid, isFalse);
      });

      test('タイトルが有効な場合はisValidがtrue', () {
        // Act
        container.read(recordItemFormProvider.notifier).updateTitle('有効なタイトル');
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.isValid, isTrue);
      });

      test('resetで初期状態にリセットされる', () {
        // Arrange
        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle('テストタイトル');
        notifier.updateDescription('テスト説明');
        notifier.updateUnit('テスト単位');

        // Act
        notifier.reset();
        final state = container.read(recordItemFormProvider);

        // Assert
        expect(state.title, isEmpty);
        expect(state.description, isEmpty);
        expect(state.unit, isEmpty);
        expect(state.isValid, isFalse);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNull);
      });
    });

    group('submitRecordItem', () {
      test('有効なデータで記録項目を正常に作成できる', () async {
        // Arrange
        const userId = 'user123';
        const title = '読書';
        const description = '本を読む';
        const unit = 'ページ';

        fakeRepository.setNextSortOrder(0);

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);
        notifier.updateDescription(description);
        notifier.updateUnit(unit);

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isTrue);

        final state = container.read(recordItemFormProvider);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNull);

        // リポジトリに保存されていることを確認
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
        expect(savedItems.first.title, equals(title));
        expect(savedItems.first.description, equals(description));
        expect(savedItems.first.unit, equals(unit));
      });

      test('descriptionとunitがnullでも作成できる', () async {
        // Arrange
        const userId = 'user123';
        const title = '運動';

        fakeRepository.setNextSortOrder(0);

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isTrue);

        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
        expect(savedItems.first.title, equals(title));
        expect(savedItems.first.description, isNull);
        expect(savedItems.first.unit, isNull);
      });

      test('無効なデータ（空のタイトル）では作成に失敗する', () async {
        // Arrange
        const userId = 'user123';

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(''); // 空のタイトル

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isFalse);

        final state = container.read(recordItemFormProvider);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNotNull);

        // リポジトリには保存されていない
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(0));
      });

      test('submission中はisSubmittingがtrueになる', () async {
        // Arrange
        const userId = 'user123';
        const title = '読書';

        fakeRepository.setNextSortOrder(0);

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);

        // Act & Assert
        final future = notifier.submit(userId);

        // submission開始直後
        final submittingState = container.read(recordItemFormProvider);
        expect(submittingState.isSubmitting, isTrue);

        // submission完了後
        await future;
        final completedState = container.read(recordItemFormProvider);
        expect(completedState.isSubmitting, isFalse);
      });

      test('リポジトリでエラーが発生した場合は失敗する', () async {
        // Arrange
        const userId = 'user123';
        const title = '読書';

        fakeRepository.setException(Exception('Network error'));

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isFalse);

        final state = container.read(recordItemFormProvider);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNotNull);
        expect(state.errorMessage, contains('Network error'));
      });

      test('作成成功後はフォームがリセットされる', () async {
        // Arrange
        const userId = 'user123';
        const title = '読書';
        const description = '本を読む';
        const unit = 'ページ';

        fakeRepository.setNextSortOrder(0);

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);
        notifier.updateDescription(description);
        notifier.updateUnit(unit);

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isTrue);

        final state = container.read(recordItemFormProvider);
        expect(state.title, isEmpty);
        expect(state.description, isEmpty);
        expect(state.unit, isEmpty);
        expect(state.isValid, isFalse);
        expect(state.errorMessage, isNull);
      });

      test('userIdが空の場合は失敗する', () async {
        // Arrange
        const userId = '';
        const title = '読書';

        final notifier = container.read(recordItemFormProvider.notifier);
        notifier.updateTitle(title);

        // Act
        final result = await notifier.submit(userId);

        // Assert
        expect(result, isFalse);

        final state = container.read(recordItemFormProvider);
        expect(state.errorMessage, isNotNull);
      });
    });

    group('clearError', () {
      test('エラーメッセージがクリアされる', () async {
        // Arrange
        const userId = 'user123';
        final notifier = container.read(recordItemFormProvider.notifier);

        // エラー状態を作る
        await notifier.submit(userId); // 無効なデータでsubmit

        expect(container.read(recordItemFormProvider).errorMessage, isNotNull);

        // Act
        notifier.clearError();

        // Assert
        final state = container.read(recordItemFormProvider);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
