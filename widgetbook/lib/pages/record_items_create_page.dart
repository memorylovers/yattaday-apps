import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_store/record_item_form_store.dart';
import 'package:myapp/features/record_items/5_view_model/record_items_create_view_model.dart';
import 'package:myapp/features/record_items/7_page/record_items_create_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsCreatePage用のモックViewModel
class MockRecordItemsCreateViewModel extends RecordItemsCreateViewModel {
  final RecordItemFormState mockFormState;
  final String? mockUserId;

  MockRecordItemsCreateViewModel({
    required this.mockFormState,
    this.mockUserId = 'test-user-id',
  });

  @override
  RecordItemsCreatePageState build() {
    return RecordItemsCreatePageState(
      formState: mockFormState,
      userId: mockUserId,
    );
  }

  @override
  void reset() {
    // モックなのでリセット処理は不要
  }
}


@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemsCreatePage,
  path: '[pages]',
)
Widget recordItemsCreatePageDefault(BuildContext context) {
  const formState = RecordItemFormState();

  return ProviderScope(
    overrides: [
      recordItemsCreateViewModelProvider.overrideWith(
        () => MockRecordItemsCreateViewModel(
          mockFormState: formState,
          mockUserId: 'widgetbook-user',
        ),
      ),
    ],
    child: RecordItemsCreatePage(userId: 'widgetbook-user'),
  );
}