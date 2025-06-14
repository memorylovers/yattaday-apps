import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../daily_records/application/providers/record_item_histories_provider.dart';

/// 記録項目のカレンダー表示
class RecordItemCalendar extends ConsumerWidget {
  const RecordItemCalendar({
    super.key,
    required this.recordItemId,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  final String recordItemId;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 記録がある日付を取得
    final recordedDatesAsync = ref.watch(
      recordedDatesProvider(recordItemId: recordItemId),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: recordedDatesAsync.when(
        data: (recordedDates) {
          // 日付文字列をDateTimeのSetに変換
          final recordedDateSet =
              recordedDates.map((dateStr) {
                final date = DateTime.parse(dateStr);
                return DateTime(date.year, date.month, date.day);
              }).toSet();

          return Column(
            children: [
              // カレンダーヘッダー
              _CalendarHeader(
                selectedMonth: selectedMonth,
                onMonthChanged: onMonthChanged,
              ),
              const SizedBox(height: 16),
              // カレンダーグリッド
              _CalendarGrid(
                selectedMonth: selectedMonth,
                recordedDateSet: recordedDateSet,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('カレンダーの読み込みに失敗しました')),
      ),
    );
  }
}

/// カレンダーヘッダー
class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy年M月');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            onMonthChanged(
              DateTime(selectedMonth.year, selectedMonth.month - 1),
            );
          },
        ),
        Text(
          formatter.format(selectedMonth),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            onMonthChanged(
              DateTime(selectedMonth.year, selectedMonth.month + 1),
            );
          },
        ),
      ],
    );
  }
}

/// カレンダーグリッド
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.selectedMonth,
    required this.recordedDateSet,
  });

  final DateTime selectedMonth;
  final Set<DateTime> recordedDateSet;

  @override
  Widget build(BuildContext context) {
    // 月の最初の日と最後の日を取得
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    // 月の最初の日の曜日（月曜日が1）
    final firstWeekday = firstDay.weekday;

    // グリッドの開始位置
    final leadingEmptyDays = firstWeekday - 1;

    // 今日の日付
    final today = DateTime.now();
    final isCurrentMonth =
        today.year == selectedMonth.year && today.month == selectedMonth.month;

    return Column(
      children: [
        // 曜日ヘッダー
        Row(
          children:
              ['月', '火', '水', '木', '金', '土', '日']
                  .map(
                    (weekday) => Expanded(
                      child: Center(
                        child: Text(
                          weekday,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                weekday == '土' || weekday == '日'
                                    ? Colors.red
                                    : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 8),
        // 日付グリッド
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: leadingEmptyDays + lastDay.day,
          itemBuilder: (context, index) {
            if (index < leadingEmptyDays) {
              return const SizedBox.shrink();
            }

            final day = index - leadingEmptyDays + 1;
            final date = DateTime(selectedMonth.year, selectedMonth.month, day);
            final isToday = isCurrentMonth && day == today.day;
            final hasRecord = recordedDateSet.contains(date);
            final isWeekend = date.weekday == 6 || date.weekday == 7;

            return Container(
              decoration: BoxDecoration(
                color:
                    hasRecord
                        ? Colors.green.withValues(alpha: 0.3)
                        : isToday
                        ? Colors.blue.withValues(alpha: 0.1)
                        : null,
                shape: BoxShape.circle,
                border:
                    isToday ? Border.all(color: Colors.blue, width: 2) : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontWeight:
                          isToday || hasRecord
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          hasRecord
                              ? Colors.green[700]
                              : isWeekend
                              ? Colors.red
                              : Colors.black87,
                    ),
                  ),
                  if (hasRecord)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
