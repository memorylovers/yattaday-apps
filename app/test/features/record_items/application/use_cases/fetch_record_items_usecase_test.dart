import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/application/use_cases/fetch_record_items_usecase.dart';
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
  group('FetchRecordItemsUseCase', () {
    late FetchRecordItemsUseCase useCase;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      useCase = FetchRecordItemsUseCase(fakeRepository);
    });

    group('execute', () {
      test('リポジトリから記録項目一覧を正常に取得できる', () async {
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
            description: '30分以上',
            unit: '分',
            sortOrder: 1,
            createdAt: DateTime(2024, 1, 2),
            updatedAt: DateTime(2024, 1, 2),
          ),
        ];

        fakeRepository.setItems(expectedItems);

        // Act
        final result = await useCase.execute(userId);

        // Assert
        expect(result, equals(expectedItems));
      });

      test('空のリストを返すことができる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Act
        final result = await useCase.execute(userId);

        // Assert
        expect(result, isEmpty);
      });

      test('リポジトリでエラーが発生した場合は例外を再スローする', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Act & Assert
        expect(() => useCase.execute(userId), throwsA(isA<Exception>()));
      });
    });

    group('watch', () {
      test('リポジトリからリアルタイム監視のStreamを正常に取得できる', () async {
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
        ];

        fakeRepository.setItems(expectedItems);

        // Act
        final stream = useCase.watch(userId);

        // Assert
        await expectLater(stream, emits(expectedItems));
      });

      test('空のリストのStreamを返すことができる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Act
        final stream = useCase.watch(userId);

        // Assert
        await expectLater(stream, emits(isEmpty));
      });

      test('リポジトリでエラーが発生した場合はエラーStreamを返す', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Act
        final stream = useCase.watch(userId);

        // Assert
        await expectLater(stream, emitsError(isA<Exception>()));
      });
    });
  });
}
