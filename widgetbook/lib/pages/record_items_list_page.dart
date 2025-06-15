import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/_gen/i18n/strings.g.dart';
import 'package:myapp/features/_authentication/application/auth_providers.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_list_page.dart';
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

@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemsListPage,
  path: '[pages]',
)
Widget recordItemsListPageDefault(BuildContext context) {
  const userId = 'widgetbook-user';

  final mockItems = [
    RecordItem(
      id: '1',
      userId: userId,
      title: 'お薬',
      description: '毎日の薬の服用を記録します。朝・昼・夜の服薬を忘れずに',
      icon: '💊',
      unit: '',
      sortOrder: 0,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    RecordItem(
      id: '2',
      userId: userId,
      title: '運動',
      description: 'ウォーキング、ランニング、筋トレなどの運動を記録',
      icon: '🏃',
      unit: '',
      sortOrder: 1,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
    RecordItem(
      id: '3',
      userId: userId,
      title: '水分補給',
      description: '1日の水分摂取量を記録して健康管理',
      icon: '💧',
      unit: '',
      sortOrder: 2,
      createdAt: DateTime(2024, 1, 3),
      updatedAt: DateTime(2024, 1, 3),
    ),
    RecordItem(
      id: '4',
      userId: userId,
      title: '読書',
      description: '読んだ本のページ数や感想を記録',
      icon: '📚',
      unit: '',
      sortOrder: 3,
      createdAt: DateTime(2024, 1, 4),
      updatedAt: DateTime(2024, 1, 4),
    ),
    RecordItem(
      id: '5',
      userId: userId,
      title: '睡眠',
      description: '睡眠時間と質を記録して生活リズムを整える',
      icon: '😴',
      unit: '',
      sortOrder: 4,
      createdAt: DateTime(2024, 1, 5),
      updatedAt: DateTime(2024, 1, 5),
    ),
  ];

  return ProviderScope(
    overrides: [
      // リポジトリのモック
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(mockItems),
      ),
      // 認証状態のモック
      authStoreProvider.overrideWith(() => MockAuthStore(userId)),
      // authUidProviderのモック
      authUidProvider.overrideWith((ref) async => userId),
    ],
    child: TranslationProvider(
      child: const MaterialApp(home: RecordItemsListPage()),
    ),
  );
}
