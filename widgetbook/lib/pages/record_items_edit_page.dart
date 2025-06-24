import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/3_store/record_item_form_store.dart';
import 'package:myapp/features/record_items/5_view_model/record_items_edit_view_model.dart';
import 'package:myapp/features/record_items/7_page/record_items_edit_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsEditPage用のモックViewModel
class MockRecordItemsEditViewModel extends RecordItemsEditViewModel {
  final RecordItem mockRecordItem;
  final RecordItemFormState mockFormState;

  MockRecordItemsEditViewModel({
    required this.mockRecordItem,
    required this.mockFormState,
  });

  @override
  RecordItemsEditPageState build(RecordItem recordItem) {
    return RecordItemsEditPageState(
      formState: mockFormState,
      userId: 'test-user-id',
      recordItem: mockRecordItem,
    );
  }

  @override
  void initializeForm() {
    // モックなので初期化処理は不要
  }
}

@widgetbook.UseCase(name: 'Default', type: RecordItemsEditPage, path: '[pages]')
Widget buildRecordItemsEditPageDefault(BuildContext context) {
  final recordItem = RecordItem(
    id: 'item1',
    userId: 'test-user-id',
    title: '読書記録',
    description: '毎日30分以上読書する',
    icon: '📖',
    unit: 'ページ',
    sortOrder: 0,
    createdAt: DateTime(2024, 1, 1, 10, 0),
    updatedAt: DateTime(2024, 1, 15, 14, 30),
  );

  final formState = RecordItemFormState(
    title: recordItem.title,
    description: recordItem.description ?? '',
    icon: recordItem.icon,
    unit: recordItem.unit ?? '',
  );

  return ProviderScope(
    overrides: [
      recordItemsEditViewModelProvider(recordItem).overrideWith(
        () => MockRecordItemsEditViewModel(
          mockRecordItem: recordItem,
          mockFormState: formState,
        ),
      ),
    ],
    child: RecordItemsEditPage(userId: 'test-user-id', recordItem: recordItem),
  );
}
