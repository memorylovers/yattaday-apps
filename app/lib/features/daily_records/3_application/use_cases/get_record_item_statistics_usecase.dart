import '../../../record_items/1_models/record_item_statistics.dart';
import '../../2_repository/record_item_history_repository.dart';

/// 記録項目の統計情報を取得するユースケース
class GetRecordItemStatisticsUseCase {
  final IRecordItemHistoryRepository _repository;

  const GetRecordItemStatisticsUseCase(this._repository);

  /// 統計情報を計算
  Future<RecordItemStatistics> execute({
    required String userId,
    required String recordItemId,
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }

    // 全ての記録履歴を取得
    final histories = await _repository.getAll(
      userId: userId,
      recordItemId: recordItemId,
    );

    if (histories.isEmpty) {
      return const RecordItemStatistics(
        totalCount: 0,
        currentStreak: 0,
        longestStreak: 0,
        thisMonthCount: 0,
        thisWeekCount: 0,
      );
    }

    // 日付をDateTimeに変換してソート
    final dates =
        histories.map((h) => DateTime.parse(h.date)).toList()
          ..sort((a, b) => a.compareTo(b));

    // 基本統計
    final totalCount = histories.length;
    final firstRecordDate = dates.first;
    final lastRecordDate = dates.last;

    // 現在の連続記録日数を計算
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    int currentStreak = 0;

    // 今日または昨日に記録があるか確認
    if (_isSameDate(dates.last, today) || _isSameDate(dates.last, yesterday)) {
      currentStreak = _calculateStreakFrom(dates, dates.last);
    }

    // 最長連続記録日数を計算
    final longestStreak = _calculateLongestStreak(dates);

    // 今月の記録回数
    final thisMonthCount =
        histories.where((h) {
          final date = DateTime.parse(h.date);
          return date.year == today.year && date.month == today.month;
        }).length;

    // 今週の記録回数（月曜日始まり）
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final thisWeekCount =
        histories.where((h) {
          final date = DateTime.parse(h.date);
          return !date.isBefore(weekStart) && !date.isAfter(today);
        }).length;

    return RecordItemStatistics(
      totalCount: totalCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      firstRecordDate: firstRecordDate,
      lastRecordDate: lastRecordDate,
      thisMonthCount: thisMonthCount,
      thisWeekCount: thisWeekCount,
    );
  }

  /// 指定日付からの連続日数を計算
  int _calculateStreakFrom(List<DateTime> dates, DateTime startDate) {
    int streak = 1;
    DateTime currentDate = startDate;

    // 降順でチェック
    for (int i = dates.length - 2; i >= 0; i--) {
      final prevDate = currentDate.subtract(const Duration(days: 1));
      if (_isSameDate(dates[i], prevDate)) {
        streak++;
        currentDate = dates[i];
      } else {
        break;
      }
    }

    return streak;
  }

  /// 最長連続記録日数を計算
  int _calculateLongestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        longestStreak =
            currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  /// 同じ日付かどうかを判定
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
