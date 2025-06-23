import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_store/record_items_store.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_query_repository.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_command_repository.dart';
import 'package:myapp/features/record_items/3_store/record_item_crud_store.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/7_page/record_items_edit_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// 記録項目編集ページ用のモッククエリリポジトリ
class MockRecordItemQueryRepository implements IRecordItemQueryRepository {
  final List<RecordItem> _items = [];

  MockRecordItemQueryRepository({List<RecordItem>? initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    return _items.where((item) => item.userId == userId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return Stream.value(
      _items.where((item) => item.userId == userId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }


  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
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
    final userItems = _items.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems
            .map((item) => item.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}

/// 記録項目編集ページ用のモックコマンドリポジトリ
class MockRecordItemCommandRepository implements IRecordItemCommandRepository {
  final List<RecordItem> _items;

  MockRecordItemCommandRepository(this._items);

  @override
  Future<void> create(RecordItem recordItem) async {
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) {
      _items[index] = recordItem;
    } else {
      throw Exception('記録項目が見つかりません');
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );
  }
}

@widgetbook.UseCase(name: 'Default', type: RecordItemsEditPage, path: '[pages]')
Widget buildRecordItemsEditPageDefault(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item1',
    userId: 'user1',
    title: '読書記録',
    description: '毎日30分以上読書する',
    icon: '📖',
    unit: 'ページ',
    sortOrder: 0,
    createdAt: DateTime(2024, 1, 1, 10, 0),
    updatedAt: DateTime(2024, 1, 15, 14, 30),
  );

  final mockItems = [recordItem];
  final mockQueryRepository = MockRecordItemQueryRepository(
    initialItems: mockItems,
  );
  final mockCommandRepository = MockRecordItemCommandRepository(mockItems);

  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(mockQueryRepository),
      recordItemCommandRepositoryProvider.overrideWithValue(mockCommandRepository),
    ],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}
