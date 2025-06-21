import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'use_cases/delete_record_item_usecase.dart';
import 'use_cases/update_record_item_usecase.dart';
import 'record_items_store.dart';

part 'record_item_crud_store.freezed.dart';

/// 記録項目のCRUD操作の状態
@freezed
class RecordItemCrudState with _$RecordItemCrudState {
  const factory RecordItemCrudState({
    @Default(false) bool isProcessing,
    String? errorMessage,
  }) = _RecordItemCrudState;
}

/// UpdateRecordItemUseCaseのプロバイダ
final updateRecordItemUseCaseProvider = Provider<UpdateRecordItemUseCase>((
  ref,
) {
  final repository = ref.watch(recordItemRepositoryProvider);
  return UpdateRecordItemUseCase(repository);
});

/// DeleteRecordItemUseCaseのプロバイダ
final deleteRecordItemUseCaseProvider = Provider<DeleteRecordItemUseCase>((
  ref,
) {
  final repository = ref.watch(recordItemRepositoryProvider);
  return DeleteRecordItemUseCase(repository);
});

/// 記録項目のCRUD操作を管理するプロバイダ
final recordItemCrudProvider =
    StateNotifierProvider<RecordItemCrudNotifier, RecordItemCrudState>((ref) {
      final updateUseCase = ref.watch(updateRecordItemUseCaseProvider);
      final deleteUseCase = ref.watch(deleteRecordItemUseCaseProvider);
      return RecordItemCrudNotifier(updateUseCase, deleteUseCase);
    });

/// 記録項目のCRUD操作を管理するクラス
class RecordItemCrudNotifier extends StateNotifier<RecordItemCrudState> {
  final UpdateRecordItemUseCase _updateUseCase;
  final DeleteRecordItemUseCase _deleteUseCase;

  RecordItemCrudNotifier(this._updateUseCase, this._deleteUseCase)
    : super(const RecordItemCrudState());

  /// 記録項目を更新
  Future<bool> updateRecordItem({
    required String userId,
    required String recordItemId,
    required String title,
    String? description,
    String? unit,
  }) async {
    // 処理開始
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      await _updateUseCase.execute(
        userId: userId,
        recordItemId: recordItemId,
        title: title,
        description: description,
        unit: unit,
      );

      // 成功時
      state = state.copyWith(isProcessing: false, errorMessage: null);
      return true;
    } catch (error) {
      // エラー時
      state = state.copyWith(
        isProcessing: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  /// 記録項目を削除
  Future<bool> deleteRecordItem({
    required String userId,
    required String recordItemId,
  }) async {
    // 処理開始
    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      await _deleteUseCase.execute(userId: userId, recordItemId: recordItemId);

      // 成功時
      state = state.copyWith(isProcessing: false, errorMessage: null);
      return true;
    } catch (error) {
      // エラー時
      state = state.copyWith(
        isProcessing: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  /// エラーメッセージをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
