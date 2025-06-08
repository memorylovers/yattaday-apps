import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/application/use_cases/delete_record_item_usecase.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;
  int _deleteCallCount = 0;
  String? _lastDeletedUserId;
  String? _lastDeletedItemId;

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

  List<RecordItem> get items => List.unmodifiable(_items);
  int get deleteCallCount => _deleteCallCount;
  String? get lastDeletedUserId => _lastDeletedUserId;
  String? get lastDeletedItemId => _lastDeletedItemId;

  void resetDeleteTracking() {
    _deleteCallCount = 0;
    _lastDeletedUserId = null;
    _lastDeletedItemId = null;
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
    if (index != -1) {
      _items[index] = recordItem;
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;

    _deleteCallCount++;
    _lastDeletedUserId = userId;
    _lastDeletedItemId = recordItemId;

    final removedCount = _items.length;
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );

    // 削除対象が見つからなかった場合はエラー
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
  group('DeleteRecordItemUseCase', () {
    late DeleteRecordItemUseCase useCase;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      useCase = DeleteRecordItemUseCase(fakeRepository);
    });

    group('正常系', () {
      test('記録項目が正常に削除される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final item = RecordItem(
          id: recordItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        // Act
        await useCase.execute(userId: userId, recordItemId: recordItemId);

        // Assert
        expect(fakeRepository.items.length, equals(0));
        expect(fakeRepository.deleteCallCount, equals(1));
        expect(fakeRepository.lastDeletedUserId, equals(userId));
        expect(fakeRepository.lastDeletedItemId, equals(recordItemId));
      });

      test('複数の記録項目の中から指定した項目のみが削除される', () async {
        // Arrange
        const userId = 'user123';
        const targetItemId = 'item2';
        final items = [
          RecordItem(
            id: 'item1',
            userId: userId,
            title: 'タイトル1',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: targetItemId,
            userId: userId,
            title: 'タイトル2',
            sortOrder: 1,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: 'item3',
            userId: userId,
            title: 'タイトル3',
            sortOrder: 2,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        fakeRepository.setItems(items);

        // Act
        await useCase.execute(userId: userId, recordItemId: targetItemId);

        // Assert
        final remainingItems = fakeRepository.items;
        expect(remainingItems.length, equals(2));
        expect(remainingItems.any((item) => item.id == 'item1'), isTrue);
        expect(remainingItems.any((item) => item.id == targetItemId), isFalse);
        expect(remainingItems.any((item) => item.id == 'item3'), isTrue);
      });

      test('異なるユーザーの同じIDの記録項目は削除されない', () async {
        // Arrange
        const userId = 'user123';
        const otherUserId = 'other-user';
        const sameItemId = 'item1';

        final items = [
          RecordItem(
            id: sameItemId,
            userId: userId,
            title: 'ユーザー123の項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: sameItemId,
            userId: otherUserId,
            title: '他のユーザーの項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        fakeRepository.setItems(items);

        // Act
        await useCase.execute(userId: userId, recordItemId: sameItemId);

        // Assert
        final remainingItems = fakeRepository.items;
        expect(remainingItems.length, equals(1));
        expect(remainingItems.first.userId, equals(otherUserId));
        expect(remainingItems.first.title, equals('他のユーザーの項目'));
      });
    });

    group('異常系', () {
      test('userIdが空の場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(userId: '', recordItemId: 'item1'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'userIdは必須です',
            ),
          ),
        );
      });

      test('userIdが空白のみの場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(userId: '   ', recordItemId: 'item1'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'userIdは必須です',
            ),
          ),
        );
      });

      test('recordItemIdが空の場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(userId: 'user123', recordItemId: ''),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'recordItemIdは必須です',
            ),
          ),
        );
      });

      test('recordItemIdが空白のみの場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(userId: 'user123', recordItemId: '   '),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'recordItemIdは必須です',
            ),
          ),
        );
      });

      test('存在しない記録項目の場合はエラー', () async {
        // Arrange
        fakeRepository.setItems([]); // 空のリポジトリ

        // Act & Assert
        expect(
          () => useCase.execute(userId: 'user123', recordItemId: 'nonexistent'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('記録項目が見つかりません'),
            ),
          ),
        );
      });

      test('異なるユーザーの記録項目にアクセスした場合はエラー', () async {
        // Arrange
        final otherUserItem = RecordItem(
          id: 'item1',
          userId: 'other-user',
          title: '他のユーザーの項目',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([otherUserItem]);

        // Act & Assert
        expect(
          () => useCase.execute(userId: 'user123', recordItemId: 'item1'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('記録項目が見つかりません'),
            ),
          ),
        );
      });

      test('リポジトリからエラーが発生した場合', () async {
        // Arrange
        final item = RecordItem(
          id: 'item1',
          userId: 'user123',
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);
        fakeRepository.setException(Exception('Database error'));

        // Act & Assert
        expect(
          () => useCase.execute(userId: 'user123', recordItemId: 'item1'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Database error'),
            ),
          ),
        );
      });
    });

    group('境界値テスト', () {
      test('非常に長いuserIdでも正常に削除される', () async {
        // Arrange
        final longUserId = 'u' * 1000; // 1000文字のユーザーID
        const recordItemId = 'item1';
        final item = RecordItem(
          id: recordItemId,
          userId: longUserId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        // Act
        await useCase.execute(userId: longUserId, recordItemId: recordItemId);

        // Assert
        expect(fakeRepository.items.length, equals(0));
      });

      test('非常に長いrecordItemIdでも正常に削除される', () async {
        // Arrange
        const userId = 'user123';
        final longItemId = 'i' * 1000; // 1000文字のアイテムID
        final item = RecordItem(
          id: longItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        // Act
        await useCase.execute(userId: userId, recordItemId: longItemId);

        // Assert
        expect(fakeRepository.items.length, equals(0));
      });

      test('特殊文字を含むIDでも正常に削除される', () async {
        // Arrange
        const specialUserId = r'user@#$%^&*()_+-=[]{}|;:,.<>?';
        const specialItemId = r'item🚀@2024/01/01#1';
        final item = RecordItem(
          id: specialItemId,
          userId: specialUserId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        // Act
        await useCase.execute(
          userId: specialUserId,
          recordItemId: specialItemId,
        );

        // Assert
        expect(fakeRepository.items.length, equals(0));
      });
    });

    group('ユースケーステスト', () {
      test('削除後に同じIDで再度削除しようとするとエラー', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final item = RecordItem(
          id: recordItemId,
          userId: userId,
          title: 'テストタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([item]);

        // Act - 1回目の削除（成功）
        await useCase.execute(userId: userId, recordItemId: recordItemId);

        // Assert - 1回目は成功
        expect(fakeRepository.items.length, equals(0));

        // Act & Assert - 2回目の削除（エラー）
        expect(
          () => useCase.execute(userId: userId, recordItemId: recordItemId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('記録項目が見つかりません'),
            ),
          ),
        );
      });

      test('複数回の削除操作が追跡される', () async {
        // Arrange
        const userId = 'user123';
        final items = [
          RecordItem(
            id: 'item1',
            userId: userId,
            title: 'タイトル1',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          RecordItem(
            id: 'item2',
            userId: userId,
            title: 'タイトル2',
            sortOrder: 1,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        fakeRepository.setItems(items);
        fakeRepository.resetDeleteTracking();

        // Act
        await useCase.execute(userId: userId, recordItemId: 'item1');
        await useCase.execute(userId: userId, recordItemId: 'item2');

        // Assert
        expect(fakeRepository.deleteCallCount, equals(2));
        expect(fakeRepository.items.length, equals(0));
      });
    });
  });
}
