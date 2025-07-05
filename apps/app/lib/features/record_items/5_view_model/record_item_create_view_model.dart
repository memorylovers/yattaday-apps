import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../_authentication/3_store/auth_store.dart';
import '../3_store/record_item_form_store.dart';

part 'record_item_create_view_model.freezed.dart';
part 'record_item_create_view_model.g.dart';

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
    final formState = ref.watch(recordItemFormStoreProvider);
    final authState = ref.watch(authStoreProvider).valueOrNull;
    final userId = authState?.uid;

    return RecordItemsCreatePageState(formState: formState, userId: userId);
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

  Future<void> submit({
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
          .submit(userId);
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
