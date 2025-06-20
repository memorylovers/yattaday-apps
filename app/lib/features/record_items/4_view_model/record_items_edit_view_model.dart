import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/firebase/firebase_providers.dart';
import '../3_application/providers/record_item_form_provider.dart';
import '../1_models/record_item.dart';

part 'record_items_edit_view_model.freezed.dart';
part 'record_items_edit_view_model.g.dart';

@freezed
class RecordItemsEditPageState with _$RecordItemsEditPageState {
  const factory RecordItemsEditPageState({
    required RecordItemFormState formState,
    required String? userId,
    required RecordItem recordItem,
  }) = _RecordItemsEditPageState;
}

@riverpod
class RecordItemsEditViewModel extends _$RecordItemsEditViewModel {
  @override
  RecordItemsEditPageState build(RecordItem recordItem) {
    final formState = ref.watch(recordItemFormProvider);
    final userId = ref.watch(firebaseUserUidProvider).valueOrNull;

    return RecordItemsEditPageState(
      formState: formState,
      userId: userId,
      recordItem: recordItem,
    );
  }

  void initializeForm() {
    final recordItem = state.recordItem;
    ref.read(recordItemFormProvider.notifier).updateTitle(recordItem.title);
    ref.read(recordItemFormProvider.notifier).updateIcon(recordItem.icon);
    if (recordItem.description != null) {
      ref
          .read(recordItemFormProvider.notifier)
          .updateDescription(recordItem.description!);
    }
    if (recordItem.unit != null) {
      ref.read(recordItemFormProvider.notifier).updateUnit(recordItem.unit!);
    }
  }

  void updateTitle(String title) {
    ref.read(recordItemFormProvider.notifier).updateTitle(title);
  }

  void updateDescription(String description) {
    ref.read(recordItemFormProvider.notifier).updateDescription(description);
  }

  void updateIcon(String icon) {
    ref.read(recordItemFormProvider.notifier).updateIcon(icon);
  }

  void updateUnit(String unit) {
    ref.read(recordItemFormProvider.notifier).updateUnit(unit);
  }

  void clearError() {
    ref.read(recordItemFormProvider.notifier).clearError();
  }

  void reset() {
    ref.read(recordItemFormProvider.notifier).reset();
  }

  Future<bool> update() async {
    final userId = state.userId;
    if (userId == null) {
      return false;
    }

    return await ref
        .read(recordItemFormProvider.notifier)
        .update(userId: userId, recordItemId: recordItem.id);
  }
}
