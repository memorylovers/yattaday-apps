import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../3_application/record_items_store.dart';
import '../1_models/record_item.dart';

part 'record_items_list_view_model.freezed.dart';
part 'record_items_list_view_model.g.dart';

@freezed
class RecordItemsListPageState with _$RecordItemsListPageState {
  const factory RecordItemsListPageState({
    required DateTime selectedDate,
    @Default({}) Set<String> completedItemIds,
    required AsyncValue<List<RecordItem>> recordItemsAsync,
  }) = _RecordItemsListPageState;
}

@riverpod
class RecordItemsListViewModel extends _$RecordItemsListViewModel {
  @override
  RecordItemsListPageState build() {
    final recordItemsAsync = ref.watch(watchRecordItemsProvider);

    return RecordItemsListPageState(
      selectedDate: DateTime.now(),
      completedItemIds: {},
      recordItemsAsync: recordItemsAsync,
    );
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void goToPreviousDay() {
    state = state.copyWith(
      selectedDate: state.selectedDate.subtract(const Duration(days: 1)),
    );
  }

  void goToNextDay() {
    // 未来の日付には移動できないようにする
    final tomorrow = state.selectedDate.add(const Duration(days: 1));
    if (!tomorrow.isAfter(DateTime.now())) {
      state = state.copyWith(selectedDate: tomorrow);
    }
  }

  void toggleItemComplete(String itemId) {
    final newSet = Set<String>.from(state.completedItemIds);
    if (newSet.contains(itemId)) {
      newSet.remove(itemId);
    } else {
      newSet.add(itemId);
    }
    state = state.copyWith(completedItemIds: newSet);
  }

  void refresh() {
    // ignore: unused_result
    ref.refresh(watchRecordItemsProvider);
  }
}
