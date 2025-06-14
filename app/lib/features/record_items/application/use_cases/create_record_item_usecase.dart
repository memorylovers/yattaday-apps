import '../../data/repository/firebase_record_item_repository.dart';
import '../../data/repository/record_item_repository.dart';
import '../../domain/record_item.dart';

/// 記録項目を作成するユースケース
class CreateRecordItemUseCase {
  final IRecordItemRepository _repository;

  const CreateRecordItemUseCase(this._repository);

  /// 新しい記録項目を作成
  Future<RecordItem> execute({
    required String userId,
    required String title,
    String? description,
    String? unit,
    String icon = '📝',
  }) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      throw ArgumentError('userIdは必須です');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('titleは必須です');
    }

    // 次のソート順序を取得
    final sortOrder = await _repository.getNextSortOrder(userId);

    // IDを生成（FirebaseリポジトリのgenerateIdメソッドを使用）
    String id;
    if (_repository is FirebaseRecordItemRepository) {
      id = (_repository).generateId();
    } else {
      // テスト用のフォールバック
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    // 現在時刻
    final now = DateTime.now();

    // RecordItemを作成
    final recordItem = RecordItem(
      id: id,
      userId: userId,
      title: title.trim(),
      description:
          description?.trim().isEmpty == true ? null : description?.trim(),
      icon: icon,
      unit: unit?.trim().isEmpty == true ? null : unit?.trim(),
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
    );

    // リポジトリに保存
    await _repository.create(recordItem);

    return recordItem;
  }
}
