import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_detail_page.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/daily_records/application/providers/record_item_statistics_provider.dart';
import 'package:myapp/features/daily_records/application/providers/record_item_histories_provider.dart';
import 'package:myapp/common/firebase/firebase_providers.dart';
import 'package:myapp/features/daily_records/application/use_cases/get_record_item_statistics_usecase.dart';

void main() {
  group('RecordItemsDetailPage', () {
    late RecordItem testRecordItem;
    late RecordItemStatistics testStatistics;

    setUp(() {
      testRecordItem = RecordItem(
        id: 'test-id',
        userId: 'test-user-id',
        title: 'テスト項目',
        description: 'テスト説明',
        icon: '🎯',
        unit: '回',
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      testStatistics = const RecordItemStatistics(
        totalCount: 10,
        currentStreak: 3,
        longestStreak: 5,
        thisWeekCount: 2,
        thisMonthCount: 8,
      );
    });

    Widget createTestWidget({
      AsyncValue<RecordItem?>? recordItemValue,
      AsyncValue<RecordItemStatistics>? statisticsValue,
      AsyncValue<bool>? todayRecordExistsValue,
      String? userId,
    }) {
      return ProviderScope(
        overrides: [
          recordItemByIdProvider('test-id').overrideWith((ref) async {
            if (recordItemValue is AsyncLoading) {
              // Completerを使って永遠に待機
              await Completer<RecordItem?>().future;
              return null;
            } else if (recordItemValue is AsyncError) {
              throw (recordItemValue as AsyncError).error;
            }
            // AsyncData(null)の場合はnullを返す
            if (recordItemValue is AsyncData<RecordItem?> &&
                recordItemValue.value == null) {
              return null;
            }
            return recordItemValue?.value ?? testRecordItem;
          }),
          recordItemStatisticsProvider(recordItemId: 'test-id').overrideWith((
            ref,
          ) async {
            if (statisticsValue is AsyncLoading) {
              // Completerを使って永遠に待機
              await Completer<RecordItemStatistics>().future;
              return testStatistics;
            } else if (statisticsValue is AsyncError) {
              throw (statisticsValue as AsyncError).error;
            }
            return statisticsValue?.value ?? testStatistics;
          }),
          watchTodayRecordExistsProvider(recordItemId: 'test-id').overrideWith((
            ref,
          ) {
            if (todayRecordExistsValue is AsyncLoading) {
              // ローディング状態をStreamで表現
              return Stream<bool>.periodic(
                const Duration(seconds: 60),
                (_) => false,
              );
            } else if (todayRecordExistsValue is AsyncError) {
              return Stream.error((todayRecordExistsValue as AsyncError).error);
            }
            return Stream.value(todayRecordExistsValue?.value ?? false);
          }),
          firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
          firebaseUserUidProvider.overrideWith((ref) async {
            return userId ?? 'test-user-id';
          }),
          // recordItemCrudProviderはテストでは特にオーバーライド不要
          recordedDatesProvider(recordItemId: 'test-id').overrideWith((ref) {
            return <String>[];
          }),
        ],
        child: const MaterialApp(
          home: RecordItemsDetailPage(recordItemId: 'test-id'),
        ),
      );
    }

    testWidgets('記録項目の詳細が表示される', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // ヘッダー情報の確認
      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsOneWidget);
      expect(find.text('🎯'), findsOneWidget);

      // 統計情報の確認
      expect(find.text('10回'), findsOneWidget); // 合計記録回数
      expect(find.text('3日'), findsOneWidget); // 現在の連続記録
    });

    testWidgets('編集ボタンが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('削除ボタンが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('削除ボタンタップで確認ダイアログが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 削除ボタンをタップ
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump(); // ダイアログ表示のためpumpのみ

      // デバッグ用：ウィジェットツリーを確認
      // print('AlertDialog found: ${find.byType(AlertDialog).evaluate()}');
      // final textFinder = find.byType(Text);
      // for (final element in textFinder.evaluate()) {
      //   final widget = element.widget as Text;
      //   if (widget.data != null) {
      //     print('Text found: "${widget.data}"');
      //   }
      // }

      // 確認ダイアログの確認（英語表示）
      expect(find.text('Delete Record Item'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this record item?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('今日の記録追加ボタンが表示される（記録なし）', (tester) async {
      await tester.pumpWidget(
        createTestWidget(todayRecordExistsValue: const AsyncData(false)),
      );
      await tester.pumpAndSettle();

      expect(find.text('今日の記録を追加'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
    });

    testWidgets('今日の記録削除ボタンが表示される（記録あり）', (tester) async {
      await tester.pumpWidget(
        createTestWidget(todayRecordExistsValue: const AsyncData(true)),
      );
      await tester.pumpAndSettle();

      expect(find.text('今日の記録を削除'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('ローディング状態が正しく表示される', (tester) async {
      await tester.pumpWidget(
        createTestWidget(recordItemValue: const AsyncLoading()),
      );
      // ローディング状態のためpumpのみ
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('エラー状態が正しく表示される', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          recordItemValue: AsyncError(
            Exception('Test error'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget); // 英語表示
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('記録項目が見つからない場合のメッセージが表示される', (tester) async {
      await tester.pumpWidget(
        createTestWidget(recordItemValue: const AsyncData(null)),
      );
      await tester.pumpAndSettle();

      // デバッグ用：何が表示されているかを確認
      // final textFinder = find.byType(Text);
      // for (final element in textFinder.evaluate()) {
      //   final widget = element.widget as Text;
      //   if (widget.data != null) {
      //     print('Text found: "${widget.data}"');
      //   }
      // }

      // i18nのデフォルトが英語のため、実際のメッセージを確認
      expect(find.text('Record item not found'), findsOneWidget);
    });
  });
}
