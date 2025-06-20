import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/3_application/use_cases/update_record_item_usecase.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';

import '../../../../test_helpers/record_item_helpers.dart';

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
    if (index != -1) {
      _items[index] = recordItem;
    } else {
      throw Exception('記録項目が見つかりません');
    }
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
  group('UpdateRecordItemUseCase', () {
    late UpdateRecordItemUseCase useCase;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      useCase = UpdateRecordItemUseCase(fakeRepository);
    });

    group('正常系', () {
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

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: '更新されたタイトル',
          description: '更新された説明',
          unit: 'ページ',
        );

        // Assert
        expect(result.id, equals(recordItemId));
        expect(result.userId, equals(userId));
        expect(result.title, equals('更新されたタイトル'));
        expect(result.description, equals('更新された説明'));
        expect(result.unit, equals('ページ'));
        expect(result.sortOrder, equals(0)); // ソート順序は変更されない
        expect(result.createdAt, equals(DateTime(2024, 1, 1))); // 作成日時は変更されない
        expect(
          result.updatedAt.isAfter(DateTime(2024, 1, 1)),
          isTrue,
        ); // 更新日時は更新される

        // リポジトリにも反映されている
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
        expect(savedItems.first.title, equals('更新されたタイトル'));
      });

      test('一部フィールドのみ更新される', () async {
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

        // Act - タイトルのみ更新
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: '新しいタイトル',
        );

        // Assert
        expect(result.title, equals('新しいタイトル'));
        expect(result.description, equals('元の説明')); // 元の値が保持される
        expect(result.unit, equals('個')); // 元の値が保持される
      });

      test('説明とユニットを空にできる', () async {
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

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: '新しいタイトル',
          description: '',
          unit: '',
        );

        // Assert
        expect(result.title, equals('新しいタイトル'));
        expect(result.description, isNull);
        expect(result.unit, isNull);
      });

      test('空白文字のトリムが行われる', () async {
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

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: '  新しいタイトル  ',
          description: '  新しい説明  ',
          unit: '  ページ  ',
        );

        // Assert
        expect(result.title, equals('新しいタイトル'));
        expect(result.description, equals('新しい説明'));
        expect(result.unit, equals('ページ'));
      });
    });

    group('異常系', () {
      test('userIdが空の場合はエラー', () async {
        // Act & Assert
        expect(
          () =>
              useCase.execute(userId: '', recordItemId: 'item1', title: 'タイトル'),
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
          () => useCase.execute(
            userId: 'user123',
            recordItemId: '',
            title: 'タイトル',
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'recordItemIdは必須です',
            ),
          ),
        );
      });

      test('titleが空の場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(
            userId: 'user123',
            recordItemId: 'item1',
            title: '',
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'titleは必須です',
            ),
          ),
        );
      });

      test('titleが空白のみの場合はエラー', () async {
        // Act & Assert
        expect(
          () => useCase.execute(
            userId: 'user123',
            recordItemId: 'item1',
            title: '   ',
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'titleは必須です',
            ),
          ),
        );
      });

      test('存在しない記録項目の場合はエラー', () async {
        // Arrange
        fakeRepository.setItems([]); // 空のリポジトリ

        // Act & Assert
        expect(
          () => useCase.execute(
            userId: 'user123',
            recordItemId: 'nonexistent',
            title: 'タイトル',
          ),
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
        final otherUserItem = createTestRecordItem(
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
          () => useCase.execute(
            userId: 'user123',
            recordItemId: 'item1',
            title: 'タイトル',
          ),
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
        final originalItem = createTestRecordItem(
          id: 'item1',
          userId: 'user123',
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);
        fakeRepository.setException(Exception('Database error'));

        // Act & Assert
        expect(
          () => useCase.execute(
            userId: 'user123',
            recordItemId: 'item1',
            title: 'タイトル',
          ),
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
      test('非常に長いタイトルでも正常に更新される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final longTitle = 'あ' * 1000; // 1000文字のタイトル
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: longTitle,
        );

        // Assert
        expect(result.title, equals(longTitle));
      });

      test('非常に長い説明でも正常に更新される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        final longDescription = 'あ' * 2000; // 2000文字の説明
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: 'タイトル',
          description: longDescription,
        );

        // Assert
        expect(result.description, equals(longDescription));
      });

      test('特殊文字を含むデータでも正常に更新される', () async {
        // Arrange
        const userId = 'user123';
        const recordItemId = 'item1';
        const specialTitle = '🚀 プロジェクト @ 2024/01/01 #1';
        const specialDescription =
            'Line1\nLine2\tTab "Quote" \'Single\' & <tag>';
        const specialUnit = '個/日';
        final originalItem = createTestRecordItem(
          id: recordItemId,
          userId: userId,
          title: '元のタイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([originalItem]);

        // Act
        final result = await useCase.execute(
          userId: userId,
          recordItemId: recordItemId,
          title: specialTitle,
          description: specialDescription,
          unit: specialUnit,
        );

        // Assert
        expect(result.title, equals(specialTitle));
        expect(result.description, equals(specialDescription));
        expect(result.unit, equals(specialUnit));
      });
    });
  });
}
