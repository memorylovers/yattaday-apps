import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_card.dart';

import '../../../../test_helpers/record_item_helpers.dart';

void main() {
  group('RecordItemCard', () {
    late RecordItem testRecordItem;

    setUp(() {
      testRecordItem = createTestRecordItem(
        id: 'test-id',
        userId: 'test-user-id',
        title: 'テスト項目',
        description: 'テスト説明',
        icon: '✅',
        unit: '回',
        sortOrder: 1,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    testWidgets('記録項目の情報を表示する', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsOneWidget);
      expect(find.text('✅'), findsOneWidget); // アイコン
    });

    testWidgets('説明がない場合は説明を表示しない', (WidgetTester tester) async {
      final recordItemWithoutDescription = testRecordItem.copyWith(
        description: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: recordItemWithoutDescription,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsNothing);
      expect(find.text('✅'), findsOneWidget); // アイコン
    });

    testWidgets('完了状態が正しく表示される', (WidgetTester tester) async {
      // 未完了状態
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);

      // 完了状態
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(recordItem: testRecordItem, isCompleted: true),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('タップ時にonTapコールバックが呼ばれる', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              isCompleted: false,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RecordItemCard));
      expect(wasTapped, isTrue);
    });

    testWidgets('完了トグルボタンタップ時にonToggleCompleteコールバックが呼ばれる', (
      WidgetTester tester,
    ) async {
      bool wasToggleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              isCompleted: false,
              onToggleComplete: () => wasToggleTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.check_circle_outline));
      expect(wasToggleTapped, isTrue);
    });
  });
}
