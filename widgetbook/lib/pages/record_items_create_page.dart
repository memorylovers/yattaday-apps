import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_create_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsCreatePage用のモックリポジトリ
class MockRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  final bool _shouldThrowError;
  final bool _shouldDelay;

  MockRecordItemRepository({
    bool shouldThrowError = false,
    bool shouldDelay = false,
  }) : _shouldThrowError = shouldThrowError,
       _shouldDelay = shouldDelay;

  @override
  Future<void> create(RecordItem recordItem) async {
    if (_shouldDelay) {
      await Future.delayed(const Duration(seconds: 2));
    }
    if (_shouldThrowError) {
      throw Exception('ネットワークエラーが発生しました');
    }
    _items.add(recordItem);
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    if (_shouldThrowError) {
      throw Exception('ソート順序取得エラー');
    }
    return _items.where((item) => item.userId == userId).length;
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async => [];

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) => Stream.value([]);

  @override
  Future<void> update(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async =>
      throw UnimplementedError();
}

@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageDefault(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: RecordItemsCreatePage(userId: 'widgetbook-user'),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageWithError(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldThrowError: true),
      ),
    ],
    child: RecordItemsCreatePage(userId: 'widgetbook-user'),
  );
}

@widgetbook.UseCase(
  name: 'With Loading',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageWithLoading(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldDelay: true),
      ),
    ],
    child: RecordItemsCreatePage(userId: 'widgetbook-user'),
  );
}

@widgetbook.UseCase(
  name: 'Empty UserID',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageEmptyUserId(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: const RecordItemsCreatePage(userId: ''),
  );
}

@widgetbook.UseCase(
  name: 'Long UserID',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageLongUserId(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: const RecordItemsCreatePage(
      userId: 'very-long-user-id-for-testing-edge-cases-and-ui-behavior',
    ),
  );
}
