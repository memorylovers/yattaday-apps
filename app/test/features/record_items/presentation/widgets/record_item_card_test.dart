import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_card.dart';

void main() {
  group('RecordItemCard', () {
    late RecordItem testRecordItem;

    setUp(() {
      testRecordItem = RecordItem(
        id: 'test-id',
        userId: 'test-user-id',
        title: 'テスト項目',
        description: 'テスト説明',
        unit: '回',
        sortOrder: 1,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    testWidgets('記録項目の情報を表示する', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: RecordItemCard(recordItem: testRecordItem)),
        ),
      );

      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsOneWidget);
      expect(find.text('回'), findsOneWidget);
    });

    testWidgets('説明がない場合は説明を表示しない', (WidgetTester tester) async {
      final recordItemWithoutDescription = testRecordItem.copyWith(
        description: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(recordItem: recordItemWithoutDescription),
          ),
        ),
      );

      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsNothing);
      expect(find.text('回'), findsOneWidget);
    });

    testWidgets('単位がない場合は単位を表示しない', (WidgetTester tester) async {
      final recordItemWithoutUnit = testRecordItem.copyWith(unit: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(recordItem: recordItemWithoutUnit),
          ),
        ),
      );

      expect(find.text('テスト項目'), findsOneWidget);
      expect(find.text('テスト説明'), findsOneWidget);
      expect(find.text('回'), findsNothing);
    });

    testWidgets('タップ時にonTapコールバックが呼ばれる', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RecordItemCard));
      expect(wasTapped, isTrue);
    });

    testWidgets('編集ボタンタップ時にonEditコールバックが呼ばれる', (WidgetTester tester) async {
      bool wasEditTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              onEdit: () => wasEditTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      expect(wasEditTapped, isTrue);
    });

    testWidgets('削除ボタンタップ時にonDeleteコールバックが呼ばれる', (WidgetTester tester) async {
      bool wasDeleteTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordItemCard(
              recordItem: testRecordItem,
              onDelete: () => wasDeleteTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      expect(wasDeleteTapped, isTrue);
    });
  });
}
