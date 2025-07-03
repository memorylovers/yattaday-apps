import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_item_statistics.freezed.dart';
part 'record_item_statistics.g.dart';

/// 記録項目の統計情報
@freezed
class RecordItemStatistics with _$RecordItemStatistics {
  const factory RecordItemStatistics({
    /// 合計記録回数
    required int totalCount,

    /// 現在の連続記録日数
    required int currentStreak,

    /// 最長連続記録日数
    required int longestStreak,

    /// 最初の記録日
    DateTime? firstRecordDate,

    /// 最後の記録日
    DateTime? lastRecordDate,

    /// 今月の記録回数
    required int thisMonthCount,

    /// 今週の記録回数
    required int thisWeekCount,
  }) = _RecordItemStatistics;

  factory RecordItemStatistics.fromJson(Map<String, dynamic> json) =>
      _$RecordItemStatisticsFromJson(json);
}
