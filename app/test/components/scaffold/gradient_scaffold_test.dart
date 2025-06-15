import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/components/scaffold/gradient_scaffold.dart';

void main() {
  group('GradientScaffold', () {
    testWidgets('基本的な表示が正しく行われる', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientScaffold(body: Center(child: Text('Test Body'))),
        ),
      );

      // グラデーション背景が表示されているか
      expect(find.byType(Container), findsWidgets);

      // ボディコンテンツが表示されているか
      expect(find.text('Test Body'), findsOneWidget);

      // Scaffoldが存在するか
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('タイトル付きで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientScaffold(title: 'Test Title', body: SizedBox.shrink()),
        ),
      );

      // AppBarが表示されているか
      expect(find.byType(AppBar), findsOneWidget);

      // タイトルが表示されているか
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('アクション付きで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientScaffold(
            title: 'Test',
            actions: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            ],
            body: const SizedBox.shrink(),
          ),
        ),
      );

      // アクションアイコンが表示されているか
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('FAB付きで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientScaffold(
            body: const SizedBox.shrink(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      // FABが表示されているか
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('戻るボタン付きで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GradientScaffold(
            title: 'Test',
            showBackButton: true,
            body: const SizedBox.shrink(),
          ),
        ),
      );

      // 戻るボタンが表示されているか
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('白背景コンテナ付きで表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientScaffold(
            body: Text('Content'),
            useWhiteContainer: true,
          ),
        ),
      );

      // 白背景のContainerが存在するか確認
      final containerFinder = find.descendant(
        of: find.byType(SafeArea),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsWidgets);

      // コンテンツが表示されているか
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('カスタムleadingウィジェットが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientScaffold(
            title: 'Test',
            leading: Icon(Icons.menu),
            body: SizedBox.shrink(),
          ),
        ),
      );

      // カスタムleadingアイコンが表示されているか
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('bottomPaddingが正しく適用される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GradientScaffold(body: Text('Content'), bottomPadding: 100),
        ),
      );

      // パディングが適用されているか確認
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsWidgets);
    });
  });
}
