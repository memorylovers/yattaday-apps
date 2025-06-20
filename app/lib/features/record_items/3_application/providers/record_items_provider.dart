import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/firebase/firebase_providers.dart';
import '../../2_repository/firebase_record_item_repository.dart';
import '../../2_repository/record_item_repository.dart';
import '../../1_models/record_item.dart';
import '../use_cases/fetch_record_items_usecase.dart';

/// RecordItemRepositoryのプロバイダ
final recordItemRepositoryProvider = Provider<IRecordItemRepository>((ref) {
  return FirebaseRecordItemRepository();
});

/// FetchRecordItemsUseCaseのプロバイダ
final fetchRecordItemsUseCaseProvider = Provider<FetchRecordItemsUseCase>((
  ref,
) {
  final repository = ref.watch(recordItemRepositoryProvider);
  return FetchRecordItemsUseCase(repository);
});

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
final recordItemsProvider = FutureProvider.family<List<RecordItem>, String>((
  ref,
  userId,
) async {
  final useCase = ref.watch(fetchRecordItemsUseCaseProvider);
  return await useCase.execute(userId);
});

/// 指定したユーザーの記録項目一覧をリアルタイム監視するプロバイダ
final watchRecordItemsProvider = StreamProvider<List<RecordItem>>((ref) async* {
  final userId = await ref.watch(firebaseUserUidProvider.future);
  if (userId == null) {
    yield [];
    return;
  }
  final useCase = ref.watch(fetchRecordItemsUseCaseProvider);
  yield* useCase.watch(userId);
});

/// 指定したIDの記録項目を取得するプロバイダ
final recordItemByIdProvider = FutureProvider.family<RecordItem?, String>((
  ref,
  recordItemId,
) async {
  final userId = await ref.watch(firebaseUserUidProvider.future);
  if (userId == null) {
    return null;
  }
  final repository = ref.watch(recordItemRepositoryProvider);
  return await repository.getById(userId, recordItemId);
});
