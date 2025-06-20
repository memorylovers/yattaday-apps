import '../../2_repository/record_item_repository.dart';
import '../../1_models/record_item.dart';

/// 記録項目を更新するユースケース
class UpdateRecordItemUseCase {
  final IRecordItemRepository _repository;

  const UpdateRecordItemUseCase(this._repository);

  /// 既存の記録項目を更新
  Future<RecordItem> execute({
    required String userId,
    required String recordItemId,
    required String title,
    String? description,
    String? icon,
    String? unit,
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (recordItemId.trim().isEmpty) {
      throw ArgumentError('recordItemIdは必須です');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('titleは必須です');
    }

    // 既存の記録項目を取得
    final existingItem = await _repository.getById(userId, recordItemId);
    if (existingItem == null) {
      throw Exception('記録項目が見つかりません');
    }

    // 現在時刻
    final now = DateTime.now();

    // 更新された記録項目を作成
    final updatedItem = existingItem.copyWith(
      title: title.trim(),
      description:
          description != null
              ? (description.trim().isEmpty ? null : description.trim())
              : existingItem.description,
      icon: icon ?? existingItem.icon,
      unit:
          unit != null
              ? (unit.trim().isEmpty ? null : unit.trim())
              : existingItem.unit,
      updatedAt: now,
    );

    // リポジトリに保存
    await _repository.update(updatedItem);

    return updatedItem;
  }
}
