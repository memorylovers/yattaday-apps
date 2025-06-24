import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/5_view_model/record_items_list_view_model.dart';
import 'package:myapp/features/record_items/7_page/record_items_list_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsListPage用のモックViewModel
class MockRecordItemsListViewModel extends RecordItemsListViewModel {
  final List<RecordItem> mockItems;
  final Set<String> completedItemIds;

  MockRecordItemsListViewModel({
    required this.mockItems,
    this.completedItemIds = const {},
  });

  @override
  RecordItemsListPageState build() {
    return RecordItemsListPageState(
      selectedDate: DateTime.now(),
      completedItemIds: completedItemIds,
      recordItemsAsync: AsyncValue.data(mockItems),
    );
  }

  @override
  void refresh() {
    // モックなので何もしない
  }
}

// サンプルデータ生成
List<RecordItem> _createSampleItems() {
  final now = DateTime.now();
  return [
    RecordItem(
      id: '1',
      userId: 'test-user-id',
      title: '読書',
      description: '毎日読んだ本のページ数を記録',
      icon: '📚',
      unit: 'ページ',
      sortOrder: 0,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    RecordItem(
      id: '2',
      userId: 'test-user-id',
      title: '運動',
      description: '運動時間を記録',
      icon: '💪',
      unit: '分',
      sortOrder: 1,
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
    RecordItem(
      id: '3',
      userId: 'test-user-id',
      title: '水分補給',
      description: '1日の水分摂取量を記録',
      icon: '💧',
      unit: 'ml',
      sortOrder: 2,
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(minutes: 30)),
    ),
    RecordItem(
      id: '4',
      userId: 'test-user-id',
      title: '瞑想',
      description: '瞑想時間を記録',
      icon: '🧘',
      unit: '分',
      sortOrder: 3,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    ),
  ];
}

@widgetbook.UseCase(name: 'Default', type: RecordItemsListPage, path: '[pages]')
Widget buildRecordItemsListPageDefaultUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemsListViewModelProvider.overrideWith(
        () => MockRecordItemsListViewModel(mockItems: _createSampleItems()),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(
  name: 'Empty State',
  type: RecordItemsListPage,
  path: '[pages]',
)
Widget buildRecordItemsListPageEmptyUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemsListViewModelProvider.overrideWith(
        () => MockRecordItemsListViewModel(
          mockItems: [], // 空のリスト
        ),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(
  name: 'Many Items',
  type: RecordItemsListPage,
  path: '[pages]',
)
Widget buildRecordItemsListPageManyItemsUseCase(BuildContext context) {
  // 多数のアイテムを生成
  final manyItems = List.generate(20, (index) {
    return RecordItem(
      id: 'item-$index',
      userId: 'test-user-id',
      title: '記録項目 ${index + 1}',
      description: '説明文 ${index + 1}',
      icon: ['📚', '💪', '💧', '🧘', '🎯', '📝'][index % 6],
      unit: ['ページ', '回', 'ml', '分', '個', '時間'][index % 6],
      sortOrder: index,
      createdAt: DateTime.now().subtract(Duration(days: 30 - index)),
      updatedAt: DateTime.now().subtract(Duration(hours: index)),
    );
  });

  return ProviderScope(
    overrides: [
      recordItemsListViewModelProvider.overrideWith(
        () => MockRecordItemsListViewModel(mockItems: manyItems),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}
