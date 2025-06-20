import 'package:flutter/material.dart';

import '../../daily_records/3_application/use_cases/get_record_item_statistics_usecase.dart';

/// 記録項目の統計情報カード
class RecordItemStatisticsCard extends StatelessWidget {
  const RecordItemStatisticsCard({super.key, required this.statistics});

  final RecordItemStatistics statistics;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          // 上段：合計と連続記録
          Row(
            children: [
              Expanded(
                child: _StatisticItem(
                  label: '合計記録',
                  value: '${statistics.totalCount}回',
                  icon: Icons.check_circle_outline,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatisticItem(
                  label: '連続記録',
                  value: '${statistics.currentStreak}日',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 下段：今週と今月
          Row(
            children: [
              Expanded(
                child: _StatisticItem(
                  label: '今週',
                  value: '${statistics.thisWeekCount}回',
                  icon: Icons.calendar_view_week,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatisticItem(
                  label: '今月',
                  value: '${statistics.thisMonthCount}回',
                  icon: Icons.calendar_view_month,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          // 最長連続記録（ある場合）
          if (statistics.longestStreak > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '最長連続記録: ${statistics.longestStreak}日',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 統計項目の表示ウィジェット
class _StatisticItem extends StatelessWidget {
  const _StatisticItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
