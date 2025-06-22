
/// 記録項目の統計情報
class RecordItemStatistics {
  /// 合計記録回数
  final int totalCount;

  /// 現在の連続記録日数
  final int currentStreak;

  /// 最長連続記録日数
  final int longestStreak;

  /// 最初の記録日
  final DateTime? firstRecordDate;

  /// 最後の記録日
  final DateTime? lastRecordDate;

  /// 今月の記録回数
  final int thisMonthCount;

  /// 今週の記録回数
  final int thisWeekCount;

  const RecordItemStatistics({
    required this.totalCount,
    required this.currentStreak,
    required this.longestStreak,
    this.firstRecordDate,
    this.lastRecordDate,
    required this.thisMonthCount,
    required this.thisWeekCount,
  });
}