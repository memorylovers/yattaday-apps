import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../2_repository/record_item_repository.dart';

part 'record_item_crud_store.freezed.dart';
part 'record_item_crud_store.g.dart';

/// 記録項目のCRUD操作の状態
@freezed
class RecordItemCrudState with _$RecordItemCrudState {
  const factory RecordItemCrudState({
    @Default(false) bool isProcessing,
    String? errorMessage,
  }) = _RecordItemCrudState;
}

/// 記録項目のCRUD操作を管理するプロバイダ
@Riverpod(keepAlive: true)
class RecordItemCrudStore extends _$RecordItemCrudStore {
  late final RecordItemRepository _repository;

  @override
  RecordItemCrudState build() {
    _repository = ref.watch(recordItemRepositoryProvider);
    return const RecordItemCrudState();
  }

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
      // 既存の記録項目を取得
      final existingItem = await _repository.getById(userId, recordItemId);
      if (existingItem == null) {
        throw Exception('記録項目が見つかりません');
      }

      // 記録項目を更新
      final updatedItem = existingItem.copyWith(
        title: title,
        description: description,
        unit: unit,
        updatedAt: DateTime.now(),
      );

      await _repository.update(updatedItem);

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
      await _repository.delete(userId, recordItemId);

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
