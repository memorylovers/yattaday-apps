import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/_gen/i18n/strings.g.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/5_component/record_item_card.dart';
import 'package:myapp/features/record_items/5_component/record_item_list_view.dart';

import '../../../test_helpers/record_item_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.setLocaleRaw('ja');

  group('RecordItemListView', () {
    Widget createTestWidget({
      required List<RecordItem> items,
      Set<String>? completedItemIds,
      void Function(RecordItem)? onItemTap,
      void Function(RecordItem)? onItemToggleComplete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: RecordItemListView(
            items: items,
            completedItemIds: completedItemIds ?? {},
            onItemTap: onItemTap,
            onItemToggleComplete: onItemToggleComplete,
          ),
        ),
      );
    }

    testWidgets('空のリストの場合、空のメッセージが表示される', (tester) async {
      await tester.pumpWidget(createTestWidget(items: []));

      expect(find.text('記録項目がありません'), findsOneWidget);
      expect(find.byType(RecordItemCard), findsNothing);
    });

    testWidgets('記録項目のリストが正しく表示される', (tester) async {
      final items = [
        createTestRecordItem(
          id: 'item1',
          title: '読書',
          description: '本を読む',
          unit: 'ページ',
          sortOrder: 0,
        ),
        createTestRecordItem(id: 'item2', title: '運動', sortOrder: 1),
      ];

      await tester.pumpWidget(createTestWidget(items: items));

      expect(find.byType(RecordItemCard), findsNWidgets(2));
      expect(find.text('読書'), findsOneWidget);
      expect(find.text('運動'), findsOneWidget);
      expect(find.text('本を読む'), findsOneWidget);
    });

    testWidgets('記録項目をタップするとonItemTapコールバックが呼ばれる', (tester) async {
      final item = createTestRecordItem(title: 'テスト項目');
      RecordItem? tappedItem;

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemTap: (recordItem) => tappedItem = recordItem,
        ),
      );

      await tester.tap(find.byType(RecordItemCard));
      await tester.pumpAndSettle();

      expect(tappedItem, equals(item));
    });

    testWidgets('完了トグルボタンをタップするとonItemToggleCompleteコールバックが呼ばれる', (
      tester,
    ) async {
      final item = createTestRecordItem(title: 'テスト項目');
      RecordItem? toggledItem;

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemToggleComplete: (recordItem) => toggledItem = recordItem,
        ),
      );

      await tester.tap(find.byIcon(Icons.check_circle_outline));
      await tester.pumpAndSettle();

      expect(toggledItem, equals(item));
    });

    testWidgets('完了済みアイテムは完了状態で表示される', (tester) async {
      final item = createTestRecordItem(id: 'item1', title: 'テスト項目');

      await tester.pumpWidget(
        createTestWidget(items: [item], completedItemIds: {'item1'}),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('未完了アイテムは未完了状態で表示される', (tester) async {
      final item = createTestRecordItem(id: 'item1', title: 'テスト項目');

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          completedItemIds: {}, // 空のセット
        ),
      );

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('複数アイテムの完了状態が正しく表示される', (tester) async {
      final items = [
        createTestRecordItem(id: 'item1', title: '項目1'),
        createTestRecordItem(id: 'item2', title: '項目2'),
        createTestRecordItem(id: 'item3', title: '項目3'),
      ];

      await tester.pumpWidget(
        createTestWidget(
          items: items,
          completedItemIds: {'item1', 'item3'}, // item1とitem3が完了
        ),
      );

      // 完了アイコンが2つ、未完了アイコンが1つあることを確認
      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
      expect(find.byIcon(Icons.check_circle_outline), findsNWidgets(1));
    });

    testWidgets('多数の項目がある場合、スクロール可能である', (tester) async {
      final items = List.generate(
        20,
        (index) => createTestRecordItem(
          id: 'item$index',
          title: '項目$index',
          sortOrder: index,
        ),
      );

      await tester.pumpWidget(createTestWidget(items: items));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('項目0'), findsOneWidget);
      expect(find.text('項目19'), findsNothing); // 画面外なので見えない

      // スクロールして最後の項目が見えることを確認
      await tester.scrollUntilVisible(find.text('項目19'), 500.0);

      expect(find.text('項目19'), findsOneWidget);
    });

    testWidgets('sortOrder順でソートされて表示される', (tester) async {
      final items = [
        createTestRecordItem(id: 'item2', title: '項目2', sortOrder: 2),
        createTestRecordItem(id: 'item0', title: '項目0', sortOrder: 0),
        createTestRecordItem(id: 'item1', title: '項目1', sortOrder: 1),
      ];

      await tester.pumpWidget(createTestWidget(items: items));

      final cardFinder = find.byType(RecordItemCard);
      final cards = tester.widgetList<RecordItemCard>(cardFinder).toList();

      expect(cards[0].recordItem.title, equals('項目0'));
      expect(cards[1].recordItem.title, equals('項目1'));
      expect(cards[2].recordItem.title, equals('項目2'));
    });
  });
}
