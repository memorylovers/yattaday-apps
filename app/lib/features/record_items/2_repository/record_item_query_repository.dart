import '../1_models/record_item.dart';

/// 記録項目の参照用リポジトリのインターフェース
abstract class IRecordItemQueryRepository {
  /// 特定の記録項目を取得
  Future<RecordItem?> getById(String userId, String recordItemId);

  /// ユーザーの記録項目一覧を取得（sortOrder順）
  Future<List<RecordItem>> getByUserId(String userId);

  /// ユーザーの記録項目一覧をリアルタイム監視
  Stream<List<RecordItem>> watchByUserId(String userId);

  /// 次の表示順序を取得
  Future<int> getNextSortOrder(String userId);
}
