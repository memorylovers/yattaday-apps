import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/providers/service_providers.dart';
import '../1_models/record_item.dart';
import '../1_models/record_item_statistics.dart';
import '../3_application/record_item_crud_store.dart';

part 'record_item_detail_view_model.freezed.dart';
part 'record_item_detail_view_model.g.dart';

@freezed
class RecordItemDetailPageState with _$RecordItemDetailPageState {
  const factory RecordItemDetailPageState({
    required DateTime selectedMonth,
    required AsyncValue<RecordItem?> recordItem,
    required AsyncValue<RecordItemStatistics> statistics,
    required AsyncValue<bool> todayRecordExists,
    required AsyncValue<List<String>> recordedDates,
    @Default(false) bool isDeleting,
    String? deleteError,
  }) = _RecordItemDetailPageState;
}

@riverpod
class RecordItemDetailViewModel extends _$RecordItemDetailViewModel {
  @override
  RecordItemDetailPageState build(String recordItemId) {
    // TODO: Repositoryからデータを取得する

    return RecordItemDetailPageState(
      selectedMonth: DateTime.now(),
      recordItem: AsyncValue.loading(),
      statistics: AsyncValue.loading(),
      todayRecordExists: AsyncValue.loading(),
      recordedDates: AsyncValue.loading(),
    );
  }

  void setSelectedMonth(DateTime month) {
    state = state.copyWith(selectedMonth: month);
  }

  Future<void> deleteRecordItem() async {
    state = state.copyWith(isDeleting: true, deleteError: null);

    try {
      final userIdNullable = await ref.read(firebaseUserUidProvider.future);
      if (userIdNullable == null) {
        state = state.copyWith(
          isDeleting: false,
          deleteError: 'ユーザーがログインしていません',
        );
        return;
      }
      final userId = userIdNullable;
      final success = await ref
          .read(recordItemCrudProvider.notifier)
          .deleteRecordItem(userId: userId, recordItemId: recordItemId);

      if (!success) {
        final errorMessage = ref.read(recordItemCrudProvider).errorMessage;
        state = state.copyWith(
          isDeleting: false,
          deleteError: errorMessage ?? '削除に失敗しました',
        );
      } else {
        state = state.copyWith(isDeleting: false);
      }
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        deleteError: '削除中にエラーが発生しました: $e',
      );
    }
  }

  Future<void> toggleTodayRecord(bool exists) async {
    // TODO: 実装する
  }
}
