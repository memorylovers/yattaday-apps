import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../_authentication/3_store/auth_store.dart';
import '../3_store/record_item_form_store.dart';
import '../1_models/record_item.dart';

part 'record_item_edit_view_model.freezed.dart';
part 'record_item_edit_view_model.g.dart';

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
    final formState = ref.watch(recordItemFormStoreProvider);
    final authState = ref.watch(authStoreProvider).valueOrNull;
    final userId = authState?.uid;

    return RecordItemsEditPageState(
      formState: formState,
      userId: userId,
      recordItem: recordItem,
    );
  }

  void initializeForm() {
    final recordItem = state.recordItem;
    ref
        .read(recordItemFormStoreProvider.notifier)
        .updateTitle(recordItem.title);
    ref.read(recordItemFormStoreProvider.notifier).updateIcon(recordItem.icon);
    if (recordItem.description != null) {
      ref
          .read(recordItemFormStoreProvider.notifier)
          .updateDescription(recordItem.description!);
    }
    if (recordItem.unit != null) {
      ref
          .read(recordItemFormStoreProvider.notifier)
          .updateUnit(recordItem.unit!);
    }
  }

  void updateTitle(String title) {
    ref.read(recordItemFormStoreProvider.notifier).updateTitle(title);
  }

  void updateDescription(String description) {
    ref
        .read(recordItemFormStoreProvider.notifier)
        .updateDescription(description);
  }

  void updateIcon(String icon) {
    ref.read(recordItemFormStoreProvider.notifier).updateIcon(icon);
  }

  void updateUnit(String unit) {
    ref.read(recordItemFormStoreProvider.notifier).updateUnit(unit);
  }

  void clearError() {
    ref.read(recordItemFormStoreProvider.notifier).clearError();
  }

  void reset() {
    ref.read(recordItemFormStoreProvider.notifier).reset();
  }

  Future<void> update({
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    final userId = state.userId;
    if (userId == null) {
      onError?.call('ユーザーが認証されていません');
      return;
    }

    try {
      final success = await ref
          .read(recordItemFormStoreProvider.notifier)
          .update(userId: userId, recordItemId: recordItem.id);

      if (success) {
        onSuccess?.call();
      } else {
        // フォームのバリデーションエラーはformStateにerrorMessageとして保持されている
        final errorMessage = state.formState.errorMessage;
        if (errorMessage != null) {
          onError?.call(errorMessage);
        }
      }
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
