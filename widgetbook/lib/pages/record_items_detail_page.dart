import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/1_models/record_item_statistics.dart';
import 'package:myapp/features/record_items/5_view_model/record_item_detail_view_model.dart';
import 'package:myapp/features/record_items/7_page/record_items_detail_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemsDetailPage用のモックViewModel
class MockRecordItemDetailViewModel extends RecordItemDetailViewModel {
  final RecordItemDetailPageState mockState;

  MockRecordItemDetailViewModel({required this.mockState});

  @override
  RecordItemDetailPageState build(String recordItemId) {
    return mockState;
  }

  @override
  void setSelectedMonth(DateTime month) {
    // モックなので何もしない
  }

  @override
  Future<void> deleteRecordItem() async {
    // モックなので何もしない
  }

  @override
  Future<void> toggleTodayRecord(bool exists) async {
    // モックなので何もしない
  }
}

@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemsDetailPage,
  path: '[pages]',
)
Widget recordItemsDetailPageDefault(BuildContext context) {
  final testRecordItem = RecordItem(
    id: 'test-id',
    userId: 'test-user-id',
    title: '筋トレ',
    description: '毎日の筋トレ記録',
    icon: '💪',
    unit: '回',
    sortOrder: 0,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  const testStatistics = RecordItemStatistics(
    totalCount: 25,
    currentStreak: 7,
    longestStreak: 14,
    thisWeekCount: 6,
    thisMonthCount: 20,
  );

  // 過去30日間のうちランダムに記録がある日付を生成
  final now = DateTime.now();
  final recordedDates = <String>[];
  for (int i = 0; i < 30; i++) {
    final date = now.subtract(Duration(days: i));
    // 70%の確率で記録あり
    if (i % 10 < 7) {
      recordedDates.add(
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      );
    }
  }

  final mockState = RecordItemDetailPageState(
    selectedMonth: DateTime.now(),
    recordItem: AsyncValue.data(testRecordItem),
    statistics: AsyncValue.data(testStatistics),
    todayRecordExists: AsyncValue.data(false),
    recordedDates: AsyncValue.data(recordedDates),
  );

  return ProviderScope(
    overrides: [
      recordItemDetailViewModelProvider(
        'test-id',
      ).overrideWith(() => MockRecordItemDetailViewModel(mockState: mockState)),
    ],
    child: const MaterialApp(
      home: RecordItemsDetailPage(recordItemId: 'test-id'),
    ),
  );
}
