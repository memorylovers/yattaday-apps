import '../../data/repository/record_item_repository.dart';

/// 記録項目を削除するユースケース
class DeleteRecordItemUseCase {
  final IRecordItemRepository _repository;

  const DeleteRecordItemUseCase(this._repository);

  /// 指定された記録項目を削除
  Future<void> execute({
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

    // リポジトリから削除
    // delete メソッド内で存在チェックとユーザー権限チェックが行われる
    await _repository.delete(userId, recordItemId);
  }
}
