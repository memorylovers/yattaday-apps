import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_list_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsListPage用のモックリポジトリ
class MockRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _mockItems;

  MockRecordItemRepository(this._mockItems);

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // ローディング体験
    return _mockItems.where((item) => item.userId == userId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return Stream.value(
      _mockItems.where((item) => item.userId == userId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }

  @override
  Future<void> create(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> update(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<int> getNextSortOrder(String userId) async =>
      throw UnimplementedError();
}

@widgetbook.UseCase(name: 'Default', type: RecordItemsListPage)
Widget recordItemsListPageDefault(BuildContext context) {
  const userId = 'widgetbook-user';

  final mockItems = [
    RecordItem(
      id: '1',
      userId: userId,
      title: '読書',
      description: '本を読んで知識を身につける',
      unit: 'ページ',
      sortOrder: 0,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    RecordItem(
      id: '2',
      userId: userId,
      title: '運動',
      description: '健康維持のための運動',
      unit: '分',
      sortOrder: 1,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
    RecordItem(
      id: '3',
      userId: userId,
      title: '勉強',
      unit: '時間',
      sortOrder: 2,
      createdAt: DateTime(2024, 1, 3),
      updatedAt: DateTime(2024, 1, 3),
    ),
  ];

  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(mockItems),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(name: 'Empty List', type: RecordItemsListPage)
Widget recordItemsListPageEmpty(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository([]), // 空のリスト
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(name: 'Loading State', type: RecordItemsListPage)
Widget recordItemsListPageLoading(BuildContext context) {
  // 長時間のローディングを模擬
  final mockRepository = MockRecordItemRepository([]);

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(name: 'Error State', type: RecordItemsListPage)
Widget recordItemsListPageError(BuildContext context) {
  /// エラー用のモックリポジトリ
  final errorRepository = _ErrorMockRepository();

  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(errorRepository),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(name: 'Many Items', type: RecordItemsListPage)
Widget recordItemsListPageManyItems(BuildContext context) {
  const userId = 'widgetbook-user';

  // 大量のデータを生成
  final mockItems = List.generate(20, (index) {
    return RecordItem(
      id: 'item-$index',
      userId: userId,
      title: '記録項目 ${index + 1}',
      description: index % 3 == 0 ? '詳細な説明文があります' : null,
      unit: index % 2 == 0 ? '回' : null,
      sortOrder: index,
      createdAt: DateTime(2024, 1, index + 1),
      updatedAt: DateTime(2024, 1, index + 1),
    );
  });

  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(mockItems),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

/// エラー状態を模擬するリポジトリ
class _ErrorMockRepository implements IRecordItemRepository {
  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    throw Exception('ネットワークエラーが発生しました');
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return Stream.error(Exception('接続エラーが発生しました'));
  }

  @override
  Future<void> create(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> update(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<int> getNextSortOrder(String userId) async =>
      throw UnimplementedError();
}
