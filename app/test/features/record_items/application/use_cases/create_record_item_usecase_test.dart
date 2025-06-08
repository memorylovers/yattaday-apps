import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/application/use_cases/create_record_item_usecase.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';

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
  group('CreateRecordItemUseCase', () {
    late CreateRecordItemUseCase useCase;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      useCase = CreateRecordItemUseCase(fakeRepository);
    });

    group('execute', () {
      test('新しい記録項目を正常に作成できる', () async {
        // Arrange
        const userId = 'user123';
        const title = '読書';
        const description = '本を読む';
        const unit = 'ページ';

        fakeRepository.setNextSortOrder(0);

        // Act
        final result = await useCase.execute(
          userId: userId,
          title: title,
          description: description,
          unit: unit,
        );

        // Assert
        expect(result.userId, equals(userId));
        expect(result.title, equals(title));
        expect(result.description, equals(description));
        expect(result.unit, equals(unit));
        expect(result.sortOrder, equals(0));
        expect(result.id, isNotEmpty);
        expect(result.createdAt, isNotNull);
        expect(result.updatedAt, isNotNull);

        // リポジトリに保存されていることを確認
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
        expect(savedItems.first.id, equals(result.id));
      });

      test('descriptionとunitがnullでも作成できる', () async {
        // Arrange
        const userId = 'user123';
        const title = '運動';

        fakeRepository.setNextSortOrder(1);

        // Act
        final result = await useCase.execute(userId: userId, title: title);

        // Assert
        expect(result.userId, equals(userId));
        expect(result.title, equals(title));
        expect(result.description, isNull);
        expect(result.unit, isNull);
        expect(result.sortOrder, equals(1));
        expect(result.id, isNotEmpty);

        // リポジトリに保存されていることを確認
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
      });

      test('自動でsortOrderが設定される', () async {
        // Arrange
        const userId = 'user123';
        const title = 'テスト項目';

        fakeRepository.setNextSortOrder(5);

        // Act
        final result = await useCase.execute(userId: userId, title: title);

        // Assert
        expect(result.sortOrder, equals(5));
      });

      test('IDが自動生成される', () async {
        // Arrange
        const userId = 'user123';
        const title1 = 'テスト項目1';
        const title2 = 'テスト項目2';

        fakeRepository.setNextSortOrder(0);

        // Act
        final result1 = await useCase.execute(userId: userId, title: title1);

        // 異なるタイムスタンプになるよう少し待機
        await Future.delayed(const Duration(milliseconds: 2));

        final result2 = await useCase.execute(userId: userId, title: title2);

        // Assert
        expect(result1.id, isNotEmpty);
        expect(result2.id, isNotEmpty);
        expect(result1.id, isNot(equals(result2.id))); // 異なるIDが生成される
      });

      test('作成日時と更新日時が設定される', () async {
        // Arrange
        const userId = 'user123';
        const title = 'テスト項目';
        final beforeCreation = DateTime.now();

        // Act
        final result = await useCase.execute(userId: userId, title: title);
        final afterCreation = DateTime.now();

        // Assert
        expect(
          result.createdAt.isAfter(
            beforeCreation.subtract(const Duration(seconds: 1)),
          ),
          isTrue,
        );
        expect(
          result.createdAt.isBefore(
            afterCreation.add(const Duration(seconds: 1)),
          ),
          isTrue,
        );
        expect(result.updatedAt, equals(result.createdAt));
      });

      test('titleが空文字の場合は例外がスローされる', () async {
        // Arrange
        const userId = 'user123';
        const title = '';

        // Act & Assert
        expect(
          () => useCase.execute(userId: userId, title: title),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('userIdが空文字の場合は例外がスローされる', () async {
        // Arrange
        const userId = '';
        const title = 'テスト項目';

        // Act & Assert
        expect(
          () => useCase.execute(userId: userId, title: title),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('リポジトリでエラーが発生した場合は例外を再スローする', () async {
        // Arrange
        const userId = 'user123';
        const title = 'テスト項目';

        fakeRepository.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => useCase.execute(userId: userId, title: title),
          throwsA(isA<Exception>()),
        );
      });

      test('getNextSortOrderでエラーが発生した場合は例外を再スローする', () async {
        // Arrange
        const userId = 'user123';
        const title = 'テスト項目';

        // getNextSortOrderでエラーが発生するように設定
        fakeRepository.setException(Exception('Sort order error'));

        // Act & Assert
        expect(
          () => useCase.execute(userId: userId, title: title),
          throwsA(isA<Exception>()),
        );
      });

      test('複数の項目を連続で作成できる', () async {
        // Arrange
        const userId = 'user123';

        fakeRepository.setNextSortOrder(0);

        // Act
        await useCase.execute(userId: userId, title: '項目1');

        fakeRepository.setNextSortOrder(1);
        await useCase.execute(userId: userId, title: '項目2');

        // Assert
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(2));
        expect(savedItems[0].title, equals('項目1'));
        expect(savedItems[0].sortOrder, equals(0));
        expect(savedItems[1].title, equals('項目2'));
        expect(savedItems[1].sortOrder, equals(1));
      });
    });
  });
}
