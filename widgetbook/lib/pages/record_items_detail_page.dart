import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart'; // 実装待ち
import 'package:myapp/common/providers/service_providers.dart';
// TODO: record_item_histories_store と record_item_statistics_store の実装が必要
import 'package:myapp/features/record_items/1_models/record_item.dart';
// import 'package:myapp/features/record_items/1_models/record_item_statistics.dart'; // 実装待ち
import 'package:myapp/features/record_items/3_store/record_items_store.dart';
import 'package:myapp/features/record_items/7_page/record_items_detail_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

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

  // TODO: recordItemStatisticsProviderの実装待ち
  // final testStatistics = const RecordItemStatistics(
  //   totalCount: 25,
  //   currentStreak: 7,
  //   longestStreak: 14,
  //   thisWeekCount: 6,
  //   thisMonthCount: 20,
  // );

  return ProviderScope(
    overrides: [
      recordItemByIdProvider('test-id').overrideWith((ref) async {
        return testRecordItem;
      }),
      // TODO: recordItemStatisticsProviderの実装待ち
      // recordItemStatisticsProvider(recordItemId: 'test-id').overrideWith((
      //   ref,
      // ) async {
      //   return testStatistics;
      // }),
      // TODO: watchTodayRecordExistsProviderの実装待ち
      // watchTodayRecordExistsProvider(recordItemId: 'test-id').overrideWith((
      //   ref,
      // ) {
      //   return Stream.value(false);
      // }),
      firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
      firebaseUserUidProvider.overrideWith((ref) async {
        return 'test-user-id';
      }),
      // TODO: recordedDatesProviderの実装待ち
      // recordedDatesProvider(recordItemId: 'test-id').overrideWith((ref) async {
      //   // 過去30日間のうちランダムに記録がある日付を生成
      //   final now = DateTime.now();
      //   final dates = <String>[];
      //   for (int i = 0; i < 30; i++) {
      //     final date = now.subtract(Duration(days: i));
      //     // 70%の確率で記録あり
      //     if (i % 10 < 7) {
      //       dates.add(DateFormat('yyyy-MM-dd').format(date));
      //     }
      //   }
      //   return dates;
      // }),
    ],
    child: const MaterialApp(
      home: RecordItemsDetailPage(recordItemId: 'test-id'),
    ),
  );
}
