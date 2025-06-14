import '../../data/repository/record_item_history_repository.dart';
import '../../domain/record_item_history.dart';

/// 記録項目の履歴を取得するユースケース
class FetchRecordItemHistoriesUseCase {
  final IRecordItemHistoryRepository _repository;

  const FetchRecordItemHistoriesUseCase(this._repository);

  /// 指定期間の記録履歴を取得
  Future<List<RecordItemHistory>> execute({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('開始日は終了日より前である必要があります');
    }

    return await _repository.getByDateRange(
      userId: userId,
      recordItemId: recordItemId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 指定期間の記録履歴をリアルタイム監視
  Stream<List<RecordItemHistory>> watch({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('開始日は終了日より前である必要があります');
    }

    return _repository.watchByDateRange(
      userId: userId,
      recordItemId: recordItemId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 全ての記録履歴を取得
  Future<List<RecordItemHistory>> getAll({
    required String userId,
    required String recordItemId,
  }) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }

    return await _repository.getAll(userId: userId, recordItemId: recordItemId);
  }

  /// 記録が存在する日付のリストを取得
  Future<List<String>> getRecordedDates({
    required String userId,
    required String recordItemId,
  }) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }

    return await _repository.getRecordedDates(
      userId: userId,
      recordItemId: recordItemId,
    );
  }
}
