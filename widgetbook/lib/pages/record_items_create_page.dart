import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_store/record_items_store.dart';
import 'package:myapp/features/record_items/3_store/record_item_crud_store.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_query_repository.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_command_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/7_page/record_items_create_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsCreatePage用のモッククエリリポジトリ
class MockRecordItemQueryRepository implements IRecordItemQueryRepository {
  final List<RecordItem> _items = [];

  MockRecordItemQueryRepository();

  @override
  Future<int> getNextSortOrder(String userId) async {
    return _items.where((item) => item.userId == userId).length;
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async => [];

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) => Stream.value([]);

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async =>
      null;
}

/// RecordItemsCreatePage用のモックコマンドリポジトリ
class MockRecordItemCommandRepository implements IRecordItemCommandRepository {
  final List<RecordItem> _items = [];

  MockRecordItemCommandRepository();

  @override
  Future<void> create(RecordItem recordItem) async {
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String userId, String recordItemId) async =>
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
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(),
      ),
    ],
    child: RecordItemsCreatePage(userId: 'widgetbook-user'),
  );
}