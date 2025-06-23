import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/common/providers/service_providers.dart';
import 'package:myapp/features/_authentication/3_store/auth_store.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_query_repository.dart';
import 'package:myapp/features/record_items/3_store/record_items_store.dart';
import 'package:myapp/features/record_items/7_page/record_items_list_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// モック用のAuthStore
class MockAuthStore extends AuthStore {
  final String mockUid;

  MockAuthStore(this.mockUid);

  @override
  Future<AuthState?> build() async {
    return AuthState(uid: mockUid);
  }
}

/// RecordItemsListPage用のモッククエリリポジトリ
class MockRecordItemQueryRepository implements IRecordItemQueryRepository {
  final List<RecordItem> _mockItems;

  MockRecordItemQueryRepository(this._mockItems);

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
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    try {
      return _mockItems.firstWhere(
        (item) => item.id == recordItemId && item.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    final userItems = _mockItems.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems.map((item) => item.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
  }
}

// サンプルデータ生成
List<RecordItem> _createSampleItems(String userId) {
  final now = DateTime.now();
  return [
    RecordItem(
      id: '1',
      userId: userId,
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
      userId: userId,
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
      userId: userId,
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
      userId: userId,
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

@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemsListPage,
  path: 'pages',
)
Widget buildRecordItemsListPageDefaultUseCase(BuildContext context) {
  const userId = 'test-user-id';

  return ProviderScope(
    overrides: [
      firebaseUserUidProvider.overrideWith((ref) async => userId),
      authStoreProvider.overrideWith(() => MockAuthStore(userId)),
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(_createSampleItems(userId)),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(
  name: 'Empty State',
  type: RecordItemsListPage,
  path: 'pages',
)
Widget buildRecordItemsListPageEmptyUseCase(BuildContext context) {
  const userId = 'test-user-id';

  return ProviderScope(
    overrides: [
      firebaseUserUidProvider.overrideWith((ref) async => userId),
      authStoreProvider.overrideWith(() => MockAuthStore(userId)),
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository([]), // 空のリスト
      ),
    ],
    child: const RecordItemsListPage(),
  );
}

@widgetbook.UseCase(
  name: 'Many Items',
  type: RecordItemsListPage,
  path: 'pages',
)
Widget buildRecordItemsListPageManyItemsUseCase(BuildContext context) {
  const userId = 'test-user-id';

  // 多数のアイテムを生成
  final manyItems = List.generate(20, (index) {
    return RecordItem(
      id: 'item-$index',
      userId: userId,
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
      firebaseUserUidProvider.overrideWith((ref) async => userId),
      authStoreProvider.overrideWith(() => MockAuthStore(userId)),
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(manyItems),
      ),
    ],
    child: const RecordItemsListPage(),
  );
}