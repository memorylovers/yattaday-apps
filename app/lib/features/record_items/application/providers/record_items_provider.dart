import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository/firebase_record_item_repository.dart';
import '../../data/repository/record_item_repository.dart';
import '../../domain/record_item.dart';
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
final watchRecordItemsProvider =
    StreamProvider.family<List<RecordItem>, String>((ref, userId) {
      final useCase = ref.watch(fetchRecordItemsUseCaseProvider);
      return useCase.watch(userId);
    });
