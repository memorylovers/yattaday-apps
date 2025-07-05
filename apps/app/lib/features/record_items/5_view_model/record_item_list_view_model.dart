import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/_authentication/3_store/auth_store.dart';
import '../1_models/record_item.dart';
import '../2_repository/record_item_repository.dart';

part 'record_item_list_view_model.freezed.dart';
part 'record_item_list_view_model.g.dart';

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
  StreamSubscription<List<RecordItem>>? _subscription;

  @override
  RecordItemsListPageState build() {
    // ディスポーズ時にStreamをクリーンアップ
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // 認証状態を監視
    final authAsync = ref.watch(authStoreProvider);

    // 初期状態
    var recordItemsAsync = const AsyncValue<List<RecordItem>>.loading();

    // 認証状態に応じて記録項目を監視
    authAsync.whenData((authState) {
      if (authState != null) {
        // 既存のsubscriptionをキャンセル
        _subscription?.cancel();

        // 新しいStreamを監視
        final repository = ref.watch(recordItemRepositoryProvider);
        final stream = repository.watchByUserId(authState.uid);

        _subscription = stream.listen(
          (items) {
            state = state.copyWith(recordItemsAsync: AsyncValue.data(items));
          },
          onError: (error, stack) {
            state = state.copyWith(
              recordItemsAsync: AsyncValue.error(error, stack),
            );
          },
        );
      } else {
        recordItemsAsync = const AsyncValue.data([]);
      }
    });

    // エラー状態の処理
    if (authAsync.hasError) {
      recordItemsAsync = AsyncValue.error(
        authAsync.error!,
        authAsync.stackTrace!,
      );
    }

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
    // ViewModelの状態を再構築することでStreamが再読み込みされる
    ref.invalidateSelf();
  }
}
