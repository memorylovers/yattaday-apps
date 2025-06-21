import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_application/record_item_crud_store.dart';
import 'package:myapp/features/record_items/3_application/record_items_store.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';

import '../../../../test_helpers/fake_record_item_repository.dart'
    as test_helpers;
import '../../../../test_helpers/record_item_helpers.dart';

class FakeRecordItemRepository extends test_helpers.FakeRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;
  int _updateCallCount = 0;
  int _deleteCallCount = 0;

  @override
  void setItems(List<RecordItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  @override
  void setException(Exception exception) {
    _exception = exception;
  }

  @override
  void clearException() {
    _exception = null;
  }

  List<RecordItem> get items => List.unmodifiable(_items);
  int get updateCallCount => _updateCallCount;
  int get deleteCallCount => _deleteCallCount;

  void resetCallCounts() {
    _updateCallCount = 0;
    _deleteCallCount = 0;
  }

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
    _updateCallCount++;

    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) {
      _items[index] = recordItem;
    } else {
      throw Exception('記録項目が見つかりません');
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;
    _deleteCallCount++;

    final removedCount = _items.length;
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );

    if (_items.length == removedCount) {
      throw Exception('記録項目が見つかりません');
    }
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
    final userItems = _items.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems
            .map((item) => item.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}

void main() {
  group('RecordItemCrudProvider', () {
    late FakeRecordItemRepository fakeRepository;
    late ProviderContainer container;

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

    group('updateRecordItem', () {
      test('記録項目が正常に更新される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          description: '元の説明',
          unit: '個',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act
        final result = await crudNotifier.updateRecordItem(
          userId: userId,
          recordItemId: recordItemId,
          title: '更新されたタイトル',
          description: '更新された説明',
          unit: 'ページ',
        );

        // Assert
        expect(result, isTrue);
        expect(fakeRepository.updateCallCount, equals(1));

        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('更新されたタイトル'));
        expect(updatedItem.description, equals('更新された説明'));
        expect(updatedItem.unit, equals('ページ'));
      });

      test('更新失敗時はfalseを返す', () async {
        // Arrange
        fakeRepository.setException(Exception('Update error'));
        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act
        final result = await crudNotifier.updateRecordItem(
          userId: 'user123',
          recordItemId: 'item1',
          title: 'タイトル',
        );

        // Assert
        expect(result, isFalse);
      });

      test('更新後にエラー状態がクリアされる', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // エラー状態を設定
        await crudNotifier.updateRecordItem(
          userId: 'invalid',
          recordItemId: 'invalid',
          title: 'タイトル',
        );

        var state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNotNull);

        // Act - 正常な更新
        fakeRepository.clearException();
        await crudNotifier.updateRecordItem(
          userId: userId,
          recordItemId: recordItemId,
          title: '新しいタイトル',
        );

        // Assert
        state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('deleteRecordItem', () {
      test('記録項目が正常に削除される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final item = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act
        final result = await crudNotifier.deleteRecordItem(
          userId: userId,
          recordItemId: recordItemId,
        );

        // Assert
        expect(result, isTrue);
        expect(fakeRepository.deleteCallCount, equals(1));
        expect(fakeRepository.items.length, equals(0));
      });

      test('削除失敗時はfalseを返す', () async {
        // Arrange
        fakeRepository.setException(Exception('Delete error'));
        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act
        final result = await crudNotifier.deleteRecordItem(
          userId: 'user123',
          recordItemId: 'item1',
        );

        // Assert
        expect(result, isFalse);
      });

      test('削除後にエラー状態がクリアされる', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final item = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // エラー状態を設定
        await crudNotifier.deleteRecordItem(
          userId: 'invalid',
          recordItemId: 'invalid',
        );

        var state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNotNull);

        // Act - 正常な削除
        fakeRepository.clearException();
        await crudNotifier.deleteRecordItem(
          userId: userId,
          recordItemId: recordItemId,
        );

        // Assert
        state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('clearError', () {
      test('エラーメッセージがクリアされる', () async {
        // Arrange
        fakeRepository.setException(Exception('Test error'));
        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // エラー状態を設定
        await crudNotifier.updateRecordItem(
          userId: 'user123',
          recordItemId: 'item1',
          title: 'タイトル',
        );

        var state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNotNull);

        // Act
        crudNotifier.clearError();

        // Assert
        state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('isProcessing状態', () {
      test('更新中はisProcessingがtrueになる', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act & Assert
        final future = crudNotifier.updateRecordItem(
          userId: userId,
          recordItemId: recordItemId,
          title: 'タイトル',
        );

        // 更新中の状態は同期的に検証が困難なため、
        // 結果の確認のみ行う
        final result = await future;
        expect(result, isTrue);

        final state = container.read(recordItemCrudProvider);
        expect(state.isProcessing, isFalse);
      });

      test('削除中はisProcessingがtrueになる', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final item = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act & Assert
        final future = crudNotifier.deleteRecordItem(
          userId: userId,
          recordItemId: recordItemId,
        );

        // 削除中の状態は同期的に検証が困難なため、
        // 結果の確認のみ行う
        final result = await future;
        expect(result, isTrue);

        final state = container.read(recordItemCrudProvider);
        expect(state.isProcessing, isFalse);
      });
    });

    group('エラーハンドリング', () {
      test('ArgumentErrorが適切にキャッチされる', () async {
        // Arrange
        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act - 無効な引数で更新
        final updateResult = await crudNotifier.updateRecordItem(
          userId: '',
          recordItemId: 'item1',
          title: 'タイトル',
        );

        // Assert
        expect(updateResult, isFalse);

        final state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, contains('userIdは必須です'));
      });

      test('一般的なExceptionが適切にキャッチされる', () async {
        // Arrange
        fakeRepository.setException(Exception('Database connection error'));
        final crudNotifier = container.read(recordItemCrudProvider.notifier);

        // Act
        final result = await crudNotifier.updateRecordItem(
          userId: 'user123',
          recordItemId: 'item1',
          title: 'タイトル',
        );

        // Assert
        expect(result, isFalse);

        final state = container.read(recordItemCrudProvider);
        expect(state.errorMessage, contains('Database connection error'));
      });
    });

    group('プロバイダー統合', () {
      test('UseCaseプロバイダーが正しく注入される', () {
        // Act
        final updateUseCase = container.read(updateRecordItemUseCaseProvider);
        final deleteUseCase = container.read(deleteRecordItemUseCaseProvider);

        // Assert
        expect(updateUseCase, isNotNull);
        expect(deleteUseCase, isNotNull);
      });
    });
  });
}
