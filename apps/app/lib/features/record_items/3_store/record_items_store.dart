import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../_authentication/3_store/auth_store.dart';
import '../1_models/record_item.dart';
import '../2_repository/record_item_repository.dart';

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
final recordItemsProvider = FutureProvider.family<List<RecordItem>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(recordItemRepositoryProvider);
  return await repository.getByUserId(userId);
});

/// 指定したIDの記録項目を取得するプロバイダ
final recordItemByIdProvider = FutureProvider.family<RecordItem?, String>((
  ref,
  recordItemId,
) async {
  final authState = await ref.watch(authStoreProvider.future);
  if (authState == null) {
    return null;
  }
  final repository = ref.watch(recordItemRepositoryProvider);
  return await repository.getById(authState.uid, recordItemId);
});
