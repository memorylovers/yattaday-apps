import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_edit_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// 記録項目編集ページ用のモックリポジトリ
class MockRecordItemEditRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  final bool _shouldSucceed;
  final String? _errorMessage;

  MockRecordItemEditRepository({
    bool shouldSucceed = true,
    String? errorMessage,
    List<RecordItem>? initialItems,
  }) : _shouldSucceed = shouldSucceed,
       _errorMessage = errorMessage {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    if (!_shouldSucceed) throw Exception(_errorMessage ?? 'データ取得エラー');
    return _items.where((item) => item.userId == userId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    if (!_shouldSucceed) {
      return Stream.error(Exception(_errorMessage ?? 'データ取得エラー'));
    }
    return Stream.value(
      _items.where((item) => item.userId == userId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }

  @override
  Future<void> create(RecordItem recordItem) async {
    if (!_shouldSucceed) throw Exception(_errorMessage ?? '作成エラー');
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    if (!_shouldSucceed) throw Exception(_errorMessage ?? '更新エラー');

    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) {
      _items[index] = recordItem;
    } else {
      throw Exception('記録項目が見つかりません');
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (!_shouldSucceed) throw Exception(_errorMessage ?? '削除エラー');
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );
  }

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    if (!_shouldSucceed) throw Exception(_errorMessage ?? 'データ取得エラー');
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
    if (!_shouldSucceed) throw Exception(_errorMessage ?? 'ソート順取得エラー');
    final userItems = _items.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems
            .map((item) => item.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}

@widgetbook.UseCase(name: 'Default', type: RecordItemsEditPage)
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

  final mockRepository = MockRecordItemEditRepository(
    shouldSucceed: true,
    initialItems: [recordItem],
  );

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}

@widgetbook.UseCase(name: 'With Minimal Data', type: RecordItemsEditPage)
Widget buildRecordItemsEditPageMinimal(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item2',
    userId: 'user1',
    title: '運動習慣',
    icon: '🏃',
    sortOrder: 1,
    createdAt: DateTime(2024, 1, 2, 9, 0),
    updatedAt: DateTime(2024, 1, 2, 9, 0),
  );

  final mockRepository = MockRecordItemEditRepository(
    shouldSucceed: true,
    initialItems: [recordItem],
  );

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}

@widgetbook.UseCase(name: 'With Long Text', type: RecordItemsEditPage)
Widget buildRecordItemsEditPageLongText(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item3',
    userId: 'user1',
    title: 'とても長いタイトルの記録項目でテキストの表示を確認するためのサンプル',
    description:
        'とても長い説明文のサンプルです。この説明文は複数行にわたって表示されることを想定しており、ユーザーインターフェースが適切に対応できるかどうかをテストするために使用されます。長いテキストでも適切に表示され、編集できることが重要です。',
    icon: '📝',
    unit: '非常に長い単位名の例',
    sortOrder: 2,
    createdAt: DateTime(2024, 1, 3, 8, 30),
    updatedAt: DateTime(2024, 1, 20, 16, 45),
  );

  final mockRepository = MockRecordItemEditRepository(
    shouldSucceed: true,
    initialItems: [recordItem],
  );

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}

@widgetbook.UseCase(name: 'Update Error', type: RecordItemsEditPage)
Widget buildRecordItemsEditPageError(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item4',
    userId: 'user1',
    title: '更新エラーテスト',
    description: 'このアイテムは更新時にエラーが発生します',
    icon: '⚠️',
    unit: '回',
    sortOrder: 3,
    createdAt: DateTime(2024, 1, 4, 12, 0),
    updatedAt: DateTime(2024, 1, 4, 12, 0),
  );

  final mockRepository = MockRecordItemEditRepository(
    shouldSucceed: false,
    errorMessage: 'ネットワークエラーのため更新に失敗しました',
    initialItems: [recordItem],
  );

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}

@widgetbook.UseCase(name: 'Loading State Test', type: RecordItemsEditPage)
Widget buildRecordItemsEditPageLoading(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item5',
    userId: 'user1',
    title: 'ローディングテスト',
    description: '更新処理の確認用',
    icon: '⏱️',
    unit: '秒',
    sortOrder: 4,
    createdAt: DateTime(2024, 1, 5, 15, 30),
    updatedAt: DateTime(2024, 1, 5, 15, 30),
  );

  final mockRepository = MockRecordItemEditRepository(
    shouldSucceed: true,
    initialItems: [recordItem],
  );

  return ProviderScope(
    overrides: [recordItemRepositoryProvider.overrideWithValue(mockRepository)],
    child: RecordItemsEditPage(userId: 'user1', recordItem: recordItem),
  );
}
