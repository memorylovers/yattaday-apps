import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/firebase/firebase_providers.dart';
import '../3_application/providers/record_item_form_provider.dart';

part 'record_items_create_view_model.freezed.dart';
part 'record_items_create_view_model.g.dart';

@freezed
class RecordItemsCreatePageState with _$RecordItemsCreatePageState {
  const factory RecordItemsCreatePageState({
    required RecordItemFormState formState,
    required String? userId,
  }) = _RecordItemsCreatePageState;
}

@riverpod
class RecordItemsCreateViewModel extends _$RecordItemsCreateViewModel {
  @override
  RecordItemsCreatePageState build() {
    final formState = ref.watch(recordItemFormProvider);
    final userId = ref.watch(firebaseUserUidProvider).valueOrNull;

    return RecordItemsCreatePageState(formState: formState, userId: userId);
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

  Future<bool> submit() async {
    final userId = state.userId;
    if (userId == null) {
      return false;
    }

    return await ref.read(recordItemFormProvider.notifier).submit(userId);
  }
}
