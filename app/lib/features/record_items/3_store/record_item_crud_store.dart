import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../2_repository/interfaces/record_item_query_repository.dart';
import '../2_repository/interfaces/record_item_command_repository.dart';
import '../2_repository/firebase/firebase_record_item_command_repository.dart';
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


/// 記録項目のCRUD操作を管理するプロバイダ
/// RecordItemCommandRepositoryのプロバイダ
final recordItemCommandRepositoryProvider = Provider<IRecordItemCommandRepository>((ref) {
  return FirebaseRecordItemCommandRepository();
});

final recordItemCrudProvider =
    StateNotifierProvider<RecordItemCrudNotifier, RecordItemCrudState>((ref) {
      final queryRepository = ref.watch(recordItemQueryRepositoryProvider);
      final commandRepository = ref.watch(recordItemCommandRepositoryProvider);
      return RecordItemCrudNotifier(queryRepository, commandRepository);
    });

/// 記録項目のCRUD操作を管理するクラス
class RecordItemCrudNotifier extends StateNotifier<RecordItemCrudState> {
  final IRecordItemQueryRepository _queryRepository;
  final IRecordItemCommandRepository _commandRepository;

  RecordItemCrudNotifier(this._queryRepository, this._commandRepository)
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
      // 既存の記録項目を取得
      final existingItem = await _queryRepository.getById(userId, recordItemId);
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
      
      await _commandRepository.update(updatedItem);

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
      await _commandRepository.delete(userId, recordItemId);

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
