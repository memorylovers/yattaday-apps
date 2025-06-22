import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/providers/service_providers.dart';
import '../../record_items/1_models/record_item_statistics.dart';
import 'record_item_histories_store.dart';
import 'use_cases/get_record_item_statistics_usecase.dart';

part 'record_item_statistics_store.g.dart';

/// 記録統計UseCaseのプロバイダー
@riverpod
GetRecordItemStatisticsUseCase getRecordItemStatisticsUseCase(Ref ref) {
  return GetRecordItemStatisticsUseCase(
    ref.watch(recordItemHistoryRepositoryProvider),
  );
}

/// 特定の記録項目の統計情報を取得するプロバイダー
@riverpod
Future<RecordItemStatistics> recordItemStatistics(
  Ref ref, {
  required String recordItemId,
}) async {
  final userId = await ref.watch(firebaseUserUidProvider.future);
  if (userId == null) {
    return const RecordItemStatistics(
      totalCount: 0,
      currentStreak: 0,
      longestStreak: 0,
      thisMonthCount: 0,
      thisWeekCount: 0,
    );
  }

  final useCase = ref.watch(getRecordItemStatisticsUseCaseProvider);
  return await useCase.execute(userId: userId, recordItemId: recordItemId);
}
