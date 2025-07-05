import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../_authentication/3_store/auth_store.dart';
import '../1_models/record_item.dart';
import '../2_repository/record_item_repository.dart';

part 'record_items_store.g.dart';

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
@Riverpod(keepAlive: true)
class RecordItemsStore extends _$RecordItemsStore {
  @override
  Future<List<RecordItem>> build(String userId) async {
    final repository = ref.watch(recordItemRepositoryProvider);
    return await repository.getByUserId(userId);
  }

  /// データを再取得
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// 指定したIDの記録項目を取得するプロバイダ
@Riverpod(keepAlive: true)
class RecordItemByIdStore extends _$RecordItemByIdStore {
  @override
  Future<RecordItem?> build(String recordItemId) async {
    final authState = await ref.watch(authStoreProvider.future);
    if (authState == null) {
      return null;
    }
    final repository = ref.watch(recordItemRepositoryProvider);
    return await repository.getById(authState.uid, recordItemId);
  }

  /// データを再取得
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
