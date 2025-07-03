import '../../1_models/record_item_history.dart';

/// 記録項目履歴のリポジトリインターフェース
abstract class IRecordItemHistoryRepository {
  /// 記録を作成
  Future<void> create(RecordItemHistory history);

  /// 記録を更新
  Future<void> update(RecordItemHistory history);

  /// 記録を削除
  Future<void> delete({
    required String userId,
    required String recordItemId,
    required String historyId,
  });

  /// 特定の記録を取得
  Future<RecordItemHistory?> getById({
    required String userId,
    required String recordItemId,
    required String historyId,
  });

  /// 特定の日付の記録を取得
  Future<RecordItemHistory?> getByDate({
    required String userId,
    required String recordItemId,
    required String date,
  });

  /// 指定期間の記録履歴を取得
  Future<List<RecordItemHistory>> getByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 記録履歴をリアルタイム監視
  Stream<List<RecordItemHistory>> watchByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 全ての記録履歴を取得（統計用）
  Future<List<RecordItemHistory>> getAll({
    required String userId,
    required String recordItemId,
  });

  /// 記録が存在する日付のリストを取得
  Future<List<String>> getRecordedDates({
    required String userId,
    required String recordItemId,
  });
}
