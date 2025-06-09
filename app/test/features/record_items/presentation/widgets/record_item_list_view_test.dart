import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_card.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_list_view.dart';

void main() {
  group('RecordItemListView', () {
    RecordItem createTestRecordItem({
      String id = 'test-id',
      String userId = 'test-user-id',
      String title = 'テスト項目',
      String? description,
      String? unit,
      int sortOrder = 0,
    }) {
      final now = DateTime.now();
      return RecordItem(
        id: id,
        userId: userId,
        title: title,
        description: description,
        unit: unit,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      );
    }

    Widget createTestWidget({
      required List<RecordItem> items,
      void Function(RecordItem)? onItemTap,
      void Function(RecordItem)? onItemEdit,
      void Function(RecordItem)? onItemDelete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: RecordItemListView(
            items: items,
            onItemTap: onItemTap,
            onItemEdit: onItemEdit,
            onItemDelete: onItemDelete,
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
      expect(find.text('ページ'), findsOneWidget);
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

    testWidgets('編集ボタンをタップするとonItemEditコールバックが呼ばれる', (tester) async {
      final item = createTestRecordItem(title: 'テスト項目');
      RecordItem? editedItem;

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemEdit: (recordItem) => editedItem = recordItem,
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(editedItem, equals(item));
    });

    testWidgets('削除ボタンをタップするとonItemDeleteコールバックが呼ばれる', (tester) async {
      final item = createTestRecordItem(title: 'テスト項目');
      RecordItem? deletedItem;

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemDelete: (recordItem) => deletedItem = recordItem,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(deletedItem, equals(item));
    });

    testWidgets('onItemEditがnullの場合、編集ボタンが表示されない', (tester) async {
      final item = createTestRecordItem(title: 'テスト項目');

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemEdit: null, // 編集コールバックなし
          onItemDelete: (recordItem) {},
        ),
      );

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('onItemDeleteがnullの場合、削除ボタンが表示されない', (tester) async {
      final item = createTestRecordItem(title: 'テスト項目');

      await tester.pumpWidget(
        createTestWidget(
          items: [item],
          onItemEdit: (recordItem) {},
          onItemDelete: null, // 削除コールバックなし
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsNothing);
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
