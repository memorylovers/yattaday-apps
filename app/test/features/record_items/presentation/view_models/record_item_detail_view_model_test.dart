import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/application/auth_providers.dart';
import 'package:myapp/features/daily_records/application/providers/record_item_histories_provider.dart';
import 'package:myapp/features/daily_records/application/providers/record_item_statistics_provider.dart';
import 'package:myapp/features/daily_records/application/use_cases/get_record_item_statistics_usecase.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/view_models/record_item_detail_view_model.dart';

// Mock data
final mockRecordItem = RecordItem(
  id: 'test-id',
  userId: 'test-user-id',
  title: 'Test Item',
  description: 'Test Description',
  icon: '🎯',
  unit: 'times',
  sortOrder: 0,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final mockStatistics = RecordItemStatistics(
  totalCount: 10,
  currentStreak: 3,
  longestStreak: 5,
  firstRecordDate: DateTime.now().subtract(const Duration(days: 30)),
  lastRecordDate: DateTime.now(),
  thisMonthCount: 5,
  thisWeekCount: 3,
);

void main() {
  group('RecordItemDetailViewModel', () {
    late ProviderContainer container;
    const recordItemId = 'test-id';

    setUp(() {
      container = ProviderContainer(
        overrides: [
          recordItemByIdProvider(recordItemId).overrideWith((ref) async {
            return mockRecordItem;
          }),
          recordItemStatisticsProvider(recordItemId: recordItemId).overrideWith(
            (ref) async {
              return mockStatistics;
            },
          ),
          watchTodayRecordExistsProvider(
            recordItemId: recordItemId,
          ).overrideWith((ref) {
            return Stream.value(false);
          }),
          authUidProvider.overrideWith((ref) async {
            return 'test-user-id';
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態の確認', () async {
      // ビルドを待つ
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(
        recordItemDetailViewModelProvider(recordItemId),
      );

      expect(state.selectedMonth.year, DateTime.now().year);
      expect(state.selectedMonth.month, DateTime.now().month);
      expect(state.recordItem, isNotNull);
      expect(state.statistics, isNotNull);
      expect(state.todayRecordExists, isNotNull);
      expect(state.isDeleting, false);
      expect(state.deleteError, isNull);
    });

    test('選択月を変更できる', () {
      final viewModel = container.read(
        recordItemDetailViewModelProvider(recordItemId).notifier,
      );

      final newMonth = DateTime(2023, 12);
      viewModel.setSelectedMonth(newMonth);

      final state = container.read(
        recordItemDetailViewModelProvider(recordItemId),
      );
      expect(state.selectedMonth, newMonth);
    });
  });
}
