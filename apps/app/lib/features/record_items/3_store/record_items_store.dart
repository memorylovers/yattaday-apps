import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../_authentication/3_store/auth_store.dart';
import '../1_models/record_item.dart';
import '../2_repository/record_item_history_repository.dart';
import '../2_repository/record_item_repository.dart';

/// RecordItemRepositoryのプロバイダ
final recordItemRepositoryProvider = Provider<RecordItemRepository>((ref) {
  return FirebaseRecordItemRepository(FirebaseFirestore.instance);
});

/// RecordItemHistoryRepositoryのプロバイダ
final recordItemHistoryRepositoryProvider = Provider<RecordItemHistoryRepository>((ref) {
  return FirebaseRecordItemHistoryRepository(FirebaseFirestore.instance);
});

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
final recordItemsProvider = FutureProvider.family<List<RecordItem>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(recordItemRepositoryProvider);
  return await repository.getByUserId(userId);
});

/// 指定したユーザーの記録項目一覧をリアルタイム監視するプロバイダ
final watchRecordItemsProvider = StreamProvider<List<RecordItem>>((ref) async* {
  final authState = await ref.watch(authStoreProvider.future);
  if (authState == null) {
    yield [];
    return;
  }
  final repository = ref.watch(recordItemRepositoryProvider);
  yield* repository.watchByUserId(authState.uid);
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
