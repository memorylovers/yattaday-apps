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

  MockRecordItemRepository();

  @override
  Future<void> create(RecordItem recordItem) async {
    _items.add(recordItem);
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
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
