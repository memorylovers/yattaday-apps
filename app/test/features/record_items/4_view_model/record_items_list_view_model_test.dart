import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/4_view_model/record_items_list_view_model.dart';

// Mock RecordItem for testing
final mockRecordItems = [
  RecordItem(
    id: '1',
    userId: 'test-user-id',
    title: 'Test Item 1',
    description: null,
    icon: '😊',
    unit: 'times',
    sortOrder: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  RecordItem(
    id: '2',
    userId: 'test-user-id',
    title: 'Test Item 2',
    description: null,
    icon: '🎯',
    unit: 'minutes',
    sortOrder: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

void main() {
  group('RecordItemsListViewModel', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          watchRecordItemsProvider.overrideWith((ref) {
            return Stream.value(mockRecordItems);
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態の確認', () {
      final state = container.read(recordItemsListViewModelProvider);
      expect(state.selectedDate.year, DateTime.now().year);
      expect(state.selectedDate.month, DateTime.now().month);
      expect(state.selectedDate.day, DateTime.now().day);
      expect(state.completedItemIds, isEmpty);
    });

    test('日付を前日に変更できる', () {
      final viewModel = container.read(
        recordItemsListViewModelProvider.notifier,
      );
      final initialDate =
          container.read(recordItemsListViewModelProvider).selectedDate;

      viewModel.goToPreviousDay();

      final state = container.read(recordItemsListViewModelProvider);
      expect(state.selectedDate.difference(initialDate).inDays, -1);
    });

    test('日付を翌日に変更できるが、未来の日付には変更できない', () {
      final viewModel = container.read(
        recordItemsListViewModelProvider.notifier,
      );

      // 過去の日付に設定
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      viewModel.setSelectedDate(yesterday);

      // 翌日（今日）に変更
      viewModel.goToNextDay();

      final state = container.read(recordItemsListViewModelProvider);
      expect(state.selectedDate.day, DateTime.now().day);

      // さらに翌日（未来）には変更できない
      viewModel.goToNextDay();
      final state2 = container.read(recordItemsListViewModelProvider);
      expect(state2.selectedDate.day, DateTime.now().day);
    });

    test('アイテムの完了状態をトグルできる', () {
      final viewModel = container.read(
        recordItemsListViewModelProvider.notifier,
      );

      // アイテムを完了にする
      viewModel.toggleItemComplete('1');

      var state = container.read(recordItemsListViewModelProvider);
      expect(state.completedItemIds, contains('1'));

      // アイテムを未完了に戻す
      viewModel.toggleItemComplete('1');

      state = container.read(recordItemsListViewModelProvider);
      expect(state.completedItemIds, isNot(contains('1')));
    });

    test('記録項目リストが状態に含まれている', () {
      final state = container.read(recordItemsListViewModelProvider);
      expect(state.recordItemsAsync, isNotNull);
    });

    test('プロバイダーをリフレッシュできる', () {
      final viewModel = container.read(
        recordItemsListViewModelProvider.notifier,
      );

      // エラーなく実行されることを確認
      expect(() => viewModel.refresh(), returnsNormally);
    });
  });
}
