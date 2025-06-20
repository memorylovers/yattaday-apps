import '../../2_repository/record_item_history_repository.dart';

/// 記録項目の履歴を削除するユースケース
class DeleteRecordItemHistoryUseCase {
  final IRecordItemHistoryRepository _repository;

  const DeleteRecordItemHistoryUseCase(this._repository);

  /// 指定された記録を削除
  Future<void> execute({
    required String userId,
    required String recordItemId,
    required String historyId,
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }
    if (historyId.trim().isEmpty) {
      throw ArgumentError('historyIdは必須です');
    }

    // 記録が存在するか確認
    final existing = await _repository.getById(
      userId: userId,
      recordItemId: recordItemId,
      historyId: historyId,
    );

    if (existing == null) {
      throw Exception('削除対象の記録が見つかりません');
    }

    // リポジトリから削除
    await _repository.delete(
      userId: userId,
      recordItemId: recordItemId,
      historyId: historyId,
    );
  }

  /// 指定日付の記録を削除
  Future<void> executeByDate({
    required String userId,
    required String recordItemId,
    required DateTime date,
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }

    // 日付をyyyy-MM-dd形式に変換
    final dateStr = _formatDate(date);

    // 該当日付の記録を取得
    final existing = await _repository.getByDate(
      userId: userId,
      recordItemId: recordItemId,
      date: dateStr,
    );

    if (existing == null) {
      throw Exception('削除対象の記録が見つかりません');
    }

    // リポジトリから削除
    await _repository.delete(
      userId: userId,
      recordItemId: recordItemId,
      historyId: existing.id,
    );
  }

  /// DateTimeをyyyy-MM-dd形式の文字列に変換
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
