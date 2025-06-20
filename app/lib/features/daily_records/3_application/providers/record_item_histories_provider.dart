import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/firebase/firebase_providers.dart';
import '../../2_repository/firebase_record_item_history_repository.dart';
import '../../2_repository/record_item_history_repository.dart';
import '../../1_models/record_item_history.dart';
import '../use_cases/create_record_item_history_usecase.dart';
import '../use_cases/delete_record_item_history_usecase.dart';
import '../use_cases/fetch_record_item_histories_usecase.dart';

part 'record_item_histories_provider.g.dart';

/// 記録項目履歴リポジトリのプロバイダー
@riverpod
IRecordItemHistoryRepository recordItemHistoryRepository(Ref ref) {
  return FirebaseRecordItemHistoryRepository(FirebaseFirestore.instance);
}

/// 記録作成UseCaseのプロバイダー
@riverpod
CreateRecordItemHistoryUseCase createRecordItemHistoryUseCase(Ref ref) {
  return CreateRecordItemHistoryUseCase(
    ref.watch(recordItemHistoryRepositoryProvider),
  );
}

/// 記録取得UseCaseのプロバイダー
@riverpod
FetchRecordItemHistoriesUseCase fetchRecordItemHistoriesUseCase(Ref ref) {
  return FetchRecordItemHistoriesUseCase(
    ref.watch(recordItemHistoryRepositoryProvider),
  );
}

/// 記録削除UseCaseのプロバイダー
@riverpod
DeleteRecordItemHistoryUseCase deleteRecordItemHistoryUseCase(Ref ref) {
  return DeleteRecordItemHistoryUseCase(
    ref.watch(recordItemHistoryRepositoryProvider),
  );
}

/// 特定の記録項目の履歴を監視するプロバイダー
@riverpod
Stream<List<RecordItemHistory>> watchRecordItemHistories(
  Ref ref, {
  required String recordItemId,
  required DateTime startDate,
  required DateTime endDate,
}) async* {
  final userId = await ref.watch(firebaseUserUidProvider.future);
  if (userId == null) {
    yield [];
    return;
  }

  final useCase = ref.watch(fetchRecordItemHistoriesUseCaseProvider);
  yield* useCase.watch(
    userId: userId,
    recordItemId: recordItemId,
    startDate: startDate,
    endDate: endDate,
  );
}

/// 今日の記録があるかどうかを監視するプロバイダー
@riverpod
Stream<bool> watchTodayRecordExists(Ref ref, {required String recordItemId}) {
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay
      .add(const Duration(days: 1))
      .subtract(const Duration(microseconds: 1));

  return ref
      .watch(
        watchRecordItemHistoriesProvider(
          recordItemId: recordItemId,
          startDate: startOfDay,
          endDate: endOfDay,
        ).future,
      )
      .asStream()
      .map((histories) => histories.isNotEmpty);
}

/// 記録がある日付のリストを取得するプロバイダー
@riverpod
Future<List<String>> recordedDates(
  Ref ref, {
  required String recordItemId,
}) async {
  final userId = await ref.watch(firebaseUserUidProvider.future);
  if (userId == null) {
    return [];
  }

  final useCase = ref.watch(fetchRecordItemHistoriesUseCaseProvider);
  return await useCase.getRecordedDates(
    userId: userId,
    recordItemId: recordItemId,
  );
}
