import '../../data/repository/record_item_repository.dart';
import '../../domain/record_item.dart';

/// 記録項目一覧を取得するユースケース
class FetchRecordItemsUseCase {
  final IRecordItemRepository _repository;

  const FetchRecordItemsUseCase(this._repository);

  /// 指定したユーザーの記録項目一覧を取得
  Future<List<RecordItem>> execute(String userId) async {
    return await _repository.getByUserId(userId);
  }

  /// 指定したユーザーの記録項目一覧をリアルタイム監視
  Stream<List<RecordItem>> watch(String userId) {
    return _repository.watchByUserId(userId);
  }
}
