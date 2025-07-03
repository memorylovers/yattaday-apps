import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../_authentication/3_store/auth_store.dart';
import '../2_repository/firebase/firebase_record_item_query_repository.dart';
import '../2_repository/interfaces/record_item_query_repository.dart';
import '../1_models/record_item.dart';

/// RecordItemQueryRepositoryのプロバイダ
final recordItemQueryRepositoryProvider = Provider<IRecordItemQueryRepository>((
  ref,
) {
  return FirebaseRecordItemQueryRepository();
});

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
final recordItemsProvider = FutureProvider.family<List<RecordItem>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(recordItemQueryRepositoryProvider);
  return await repository.getByUserId(userId);
});

/// 指定したユーザーの記録項目一覧をリアルタイム監視するプロバイダ
final watchRecordItemsProvider = StreamProvider<List<RecordItem>>((ref) async* {
  final authState = await ref.watch(authStoreProvider.future);
  if (authState == null) {
    yield [];
    return;
  }
  final repository = ref.watch(recordItemQueryRepositoryProvider);
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
  final repository = ref.watch(recordItemQueryRepositoryProvider);
  return await repository.getById(authState.uid, recordItemId);
});
