import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/firebase/firebase_providers.dart';
import '../../daily_records/3_application/providers/record_item_histories_provider.dart';
import '../../daily_records/3_application/providers/record_item_statistics_provider.dart';
import '../../daily_records/3_application/use_cases/get_record_item_statistics_usecase.dart';
import '../3_application/providers/record_item_crud_provider.dart';
import '../3_application/providers/record_items_provider.dart';
import '../1_models/record_item.dart';

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
    final recordItem = ref.watch(recordItemByIdProvider(recordItemId));
    final statistics = ref.watch(
      recordItemStatisticsProvider(recordItemId: recordItemId),
    );
    final todayRecordExists = ref.watch(
      watchTodayRecordExistsProvider(recordItemId: recordItemId),
    );
    final recordedDates = ref.watch(
      recordedDatesProvider(recordItemId: recordItemId),
    );

    return RecordItemDetailPageState(
      selectedMonth: DateTime.now(),
      recordItem: recordItem,
      statistics: statistics,
      todayRecordExists: todayRecordExists,
      recordedDates: recordedDates,
    );
  }

  void setSelectedMonth(DateTime month) {
    state = state.copyWith(selectedMonth: month);
  }

  Future<void> deleteRecordItem() async {
    state = state.copyWith(isDeleting: true, deleteError: null);

    try {
      final userId = await ref.read(firebaseUserUidProvider.future);
      final success = await ref
          .read(recordItemCrudProvider.notifier)
          .deleteRecordItem(userId: userId!, recordItemId: recordItemId);

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
    try {
      final userId = await ref.read(firebaseUserUidProvider.future);

      if (exists) {
        // 削除
        await ref
            .read(deleteRecordItemHistoryUseCaseProvider)
            .executeByDate(
              userId: userId!,
              recordItemId: recordItemId,
              date: DateTime.now(),
            );
      } else {
        // 作成
        await ref
            .read(createRecordItemHistoryUseCaseProvider)
            .execute(
              userId: userId!,
              recordItemId: recordItemId,
              date: DateTime.now(),
            );
      }

      // プロバイダーをリフレッシュ
      ref.invalidate(recordItemStatisticsProvider(recordItemId: recordItemId));
      ref.invalidate(recordedDatesProvider(recordItemId: recordItemId));
    } catch (e) {
      // エラーハンドリングは必要に応じて実装
      rethrow;
    }
  }
}
