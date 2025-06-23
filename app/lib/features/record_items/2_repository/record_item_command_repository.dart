import '../1_models/record_item.dart';

/// 記録項目の更新用リポジトリのインターフェース
abstract class IRecordItemCommandRepository {
  /// 記録項目を作成
  Future<void> create(RecordItem recordItem);

  /// 記録項目を更新
  Future<void> update(RecordItem recordItem);

  /// 記録項目を削除
  Future<void> delete(String userId, String recordItemId);
}
