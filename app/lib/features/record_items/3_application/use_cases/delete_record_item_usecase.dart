import '../../2_repository/record_item_repository.dart';

/// 記録項目を削除するユースケース
class DeleteRecordItemUseCase {
  const DeleteRecordItemUseCase(this._repository);

  final IRecordItemRepository _repository;

  /// 記録項目を削除する
  ///
  /// [userId] 対象ユーザーのID
  /// [recordItemId] 削除する記録項目のID
  Future<void> execute({
    required String userId,
    required String recordItemId,
  }) async {
    await _repository.delete(userId, recordItemId);
  }
}
