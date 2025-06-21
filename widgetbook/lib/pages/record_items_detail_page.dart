import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/6_page/record_items_detail_page.dart';
import 'package:myapp/features/record_items/3_application/record_items_store.dart';
import 'package:myapp/features/daily_records/3_application/record_item_statistics_store.dart';
import 'package:myapp/features/daily_records/3_application/record_item_histories_store.dart';
import 'package:myapp/common/providers/service_providers.dart';
import 'package:myapp/features/daily_records/3_application/use_cases/get_record_item_statistics_usecase.dart';

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

  final testStatistics = const RecordItemStatistics(
    totalCount: 25,
    currentStreak: 7,
    longestStreak: 14,
    thisWeekCount: 6,
    thisMonthCount: 20,
  );

  return ProviderScope(
    overrides: [
      recordItemByIdProvider('test-id').overrideWith((ref) async {
        return testRecordItem;
      }),
      recordItemStatisticsProvider(recordItemId: 'test-id').overrideWith((
        ref,
      ) async {
        return testStatistics;
      }),
      watchTodayRecordExistsProvider(recordItemId: 'test-id').overrideWith((
        ref,
      ) {
        return Stream.value(false);
      }),
      firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
      firebaseUserUidProvider.overrideWith((ref) async {
        return 'test-user-id';
      }),
      recordedDatesProvider(recordItemId: 'test-id').overrideWith((ref) async {
        // 過去30日間のうちランダムに記録がある日付を生成
        final now = DateTime.now();
        final dates = <String>[];
        for (int i = 0; i < 30; i++) {
          final date = now.subtract(Duration(days: i));
          // 70%の確率で記録あり
          if (i % 10 < 7) {
            dates.add(DateFormat('yyyy-MM-dd').format(date));
          }
        }
        return dates;
      }),
    ],
    child: const MaterialApp(
      home: RecordItemsDetailPage(recordItemId: 'test-id'),
    ),
  );
}
