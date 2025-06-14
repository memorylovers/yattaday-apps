import '../../data/repository/firebase_record_item_history_repository.dart';
import '../../data/repository/record_item_history_repository.dart';
import '../../domain/record_item_history.dart';

/// 記録項目の履歴を作成するユースケース
class CreateRecordItemHistoryUseCase {
  final IRecordItemHistoryRepository _repository;

  const CreateRecordItemHistoryUseCase(this._repository);

  /// 新しい記録を作成
  Future<RecordItemHistory> execute({
    required String userId,
    required String recordItemId,
    required DateTime date,
    String? note,
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

    // 既存の記録があるかチェック
    final existing = await _repository.getByDate(
      userId: userId,
      recordItemId: recordItemId,
      date: dateStr,
    );

    if (existing != null) {
      throw Exception('この日付には既に記録が存在します');
    }

    // IDを生成
    String id;
    if (_repository is FirebaseRecordItemHistoryRepository) {
      id = (_repository).generateId();
    } else {
      // テスト用のフォールバック
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // 現在時刻
    final now = DateTime.now();

    // RecordItemHistoryを作成
    final history = RecordItemHistory(
      id: id,
      userId: userId,
      date: dateStr,
      recordItemId: recordItemId,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      createdAt: now,
      updatedAt: now,
    );

    // リポジトリに保存
    await _repository.create(history);

    return history;
  }

  /// DateTimeをyyyy-MM-dd形式の文字列に変換
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
