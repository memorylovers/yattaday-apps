import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/5_view_model/record_items_list_view_model.dart';

import '../../../../test_helpers/fixtures/record_item_helpers.dart';

void main() {
  group('RecordItemsListViewModel', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('初期状態が正しく設定される', () {
        final now = DateTime.now();
        final state = container.read(recordItemsListViewModelProvider);

        expect(state.selectedDate.year, equals(now.year));
        expect(state.selectedDate.month, equals(now.month));
        expect(state.selectedDate.day, equals(now.day));
        expect(state.completedItemIds, isEmpty);
        expect(state.recordItemsAsync, isA<AsyncLoading<List<RecordItem>>>());
      });
    });

    group('setSelectedDate', () {
      test('選択日付を変更できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final newDate = DateTime(2024, 1, 15);

        viewModel.setSelectedDate(newDate);

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.selectedDate, equals(newDate));
      });
    });

    group('goToPreviousDay', () {
      test('前日に移動できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final initialDate = DateTime(2024, 1, 15);
        viewModel.setSelectedDate(initialDate);

        viewModel.goToPreviousDay();

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.selectedDate, equals(DateTime(2024, 1, 14)));
      });

      test('月をまたいで前日に移動できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final initialDate = DateTime(2024, 2, 1);
        viewModel.setSelectedDate(initialDate);

        viewModel.goToPreviousDay();

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.selectedDate, equals(DateTime(2024, 1, 31)));
      });
    });

    group('goToNextDay', () {
      test('翌日に移動できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final initialDate = DateTime(2020, 1, 15); // 過去の日付
        viewModel.setSelectedDate(initialDate);

        viewModel.goToNextDay();

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.selectedDate, equals(DateTime(2020, 1, 16)));
      });

      test('未来の日付には移動できない', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final today = DateTime.now();
        viewModel.setSelectedDate(today);

        viewModel.goToNextDay();

        final state = container.read(recordItemsListViewModelProvider);
        // 今日のままで変わらない
        expect(state.selectedDate.year, equals(today.year));
        expect(state.selectedDate.month, equals(today.month));
        expect(state.selectedDate.day, equals(today.day));
      });

      test('昨日から今日には移動できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        viewModel.setSelectedDate(yesterday);

        viewModel.goToNextDay();

        final state = container.read(recordItemsListViewModelProvider);
        final today = DateTime.now();
        expect(state.selectedDate.year, equals(today.year));
        expect(state.selectedDate.month, equals(today.month));
        expect(state.selectedDate.day, equals(today.day));
      });
    });

    group('toggleItemComplete', () {
      test('アイテムを完了状態にできる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);

        viewModel.toggleItemComplete('item1');

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.completedItemIds, contains('item1'));
      });

      test('完了状態のアイテムを未完了に戻せる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);
        
        // 完了状態にする
        viewModel.toggleItemComplete('item1');
        expect(container.read(recordItemsListViewModelProvider).completedItemIds, contains('item1'));

        // 未完了に戻す
        viewModel.toggleItemComplete('item1');
        expect(container.read(recordItemsListViewModelProvider).completedItemIds, isNot(contains('item1')));
      });

      test('複数のアイテムを独立して管理できる', () {
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);

        viewModel.toggleItemComplete('item1');
        viewModel.toggleItemComplete('item2');
        viewModel.toggleItemComplete('item3');
        viewModel.toggleItemComplete('item2'); // item2を未完了に戻す

        final state = container.read(recordItemsListViewModelProvider);
        expect(state.completedItemIds, containsAll(['item1', 'item3']));
        expect(state.completedItemIds, isNot(contains('item2')));
        expect(state.completedItemIds.length, equals(2));
      });
    });

    group('refresh', () {
      test('refreshメソッドが呼び出される', () {
        // このテストは実際のデータ取得をモックする必要があるため、
        // 統合テストで詳しく検証する
        final viewModel = container.read(recordItemsListViewModelProvider.notifier);

        // エラーが発生しないことを確認
        expect(() => viewModel.refresh(), returnsNormally);
      });
    });

    group('RecordItemsListPageState', () {
      test('copyWithが正しく動作する', () {
        final items = [
          createTestRecordItem(id: '1'),
          createTestRecordItem(id: '2'),
        ];
        final initialState = RecordItemsListPageState(
          selectedDate: DateTime(2024, 1, 1),
          completedItemIds: const {'item1'},
          recordItemsAsync: AsyncValue.data(items),
        );

        final newState = initialState.copyWith(
          selectedDate: DateTime(2024, 1, 2),
          completedItemIds: {'item1', 'item2'},
        );

        expect(newState.selectedDate, equals(DateTime(2024, 1, 2)));
        expect(newState.completedItemIds, containsAll(['item1', 'item2']));
        expect(newState.recordItemsAsync, equals(initialState.recordItemsAsync));
      });
    });
  });
}