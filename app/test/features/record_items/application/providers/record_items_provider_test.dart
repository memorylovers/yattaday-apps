import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;

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
    final userItems = _items.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems
            .map((item) => item.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}

void main() {
  group('RecordItemsProvider', () {
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

    group('recordItemsProvider', () {
      test('ユーザーの記録項目一覧を正常に取得できる', () async {
        // Arrange
        const userId = 'user123';
        final expectedItems = [
          RecordItem(
            id: 'item1',
            userId: userId,
            title: '読書',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: 'item2',
            userId: userId,
            title: '運動',
            sortOrder: 1,
            createdAt: DateTime(2024, 1, 2),
            updatedAt: DateTime(2024, 1, 2),
          ),
        ];

        fakeRepository.setItems(expectedItems);

        // Act
        final result = await container.read(recordItemsProvider(userId).future);

        // Assert
        expect(result, equals(expectedItems));
      });

      test('空のリストを正常に取得できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Act
        final result = await container.read(recordItemsProvider(userId).future);

        // Assert
        expect(result, isEmpty);
      });

      test('異なるユーザーIDでフィルタリングされる', () async {
        // Arrange
        const userId1 = 'user1';
        const userId2 = 'user2';
        final allItems = [
          RecordItem(
            id: 'item1',
            userId: userId1,
            title: 'ユーザー1の項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: 'item2',
            userId: userId2,
            title: 'ユーザー2の項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 2),
            updatedAt: DateTime(2024, 1, 2),
          ),
        ];

        fakeRepository.setItems(allItems);

        // Act
        final result1 = await container.read(
          recordItemsProvider(userId1).future,
        );
        final result2 = await container.read(
          recordItemsProvider(userId2).future,
        );

        // Assert
        expect(result1.length, equals(1));
        expect(result1[0].title, equals('ユーザー1の項目'));
        expect(result2.length, equals(1));
        expect(result2[0].title, equals('ユーザー2の項目'));
      });

      test('エラーが発生した場合例外がスローされる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () async => await container.read(recordItemsProvider(userId).future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('watchRecordItemsProvider', () {
      test('記録項目一覧の変更をリアルタイムで監視できる', () async {
        // Arrange
        const userId = 'user123';
        final initialItems = [
          RecordItem(
            id: 'item1',
            userId: userId,
            title: '初期項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        fakeRepository.setItems(initialItems);

        // Act
        final result = await container.read(
          watchRecordItemsProvider(userId).future,
        );

        // Assert
        expect(result, equals(initialItems));
      });

      test('空のリストのStreamを監視できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Act
        final result = await container.read(
          watchRecordItemsProvider(userId).future,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('エラーStreamを正しく処理できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () async =>
              await container.read(watchRecordItemsProvider(userId).future),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
