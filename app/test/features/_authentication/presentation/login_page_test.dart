import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/presentation/login_page.dart';
import 'package:myapp/features/_authentication/presentation/widgets/login_buttons.dart';
import 'package:myapp/_gen/i18n/strings.g.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleRaw('ja');
  });
  group('LoginPage', () {
    testWidgets('新しいデザインの要素が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // グラデーション背景の確認（Containerのdecoration）
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Container).first,
        ),
      );
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());

      // ロゴアイコンの確認（SVG）
      expect(find.byType(SvgPicture), findsOneWidget);

      // アプリ名の確認
      expect(find.text('YattaDay'), findsOneWidget);

      // サブタイトルの確認
      expect(find.text('毎日の記録を簡単に'), findsOneWidget);

      // Googleログインボタンの確認
      expect(find.byType(GoogleLoginButton), findsOneWidget);

      // Appleログインボタンの確認
      expect(find.byType(AppleLoginButton), findsOneWidget);

      // 「または」の区切り線が表示されることを確認
      expect(find.text('または'), findsOneWidget);

      // 匿名ログインボタンが表示されることを確認
      expect(find.byType(AnonymousLoginButton), findsOneWidget);

      // 利用規約のテキストが表示されることを確認
      // RichTextの中のテキストを探す
      final richTextFinder = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final text = widget.text.toPlainText();
          return text.contains('利用規約') && text.contains('プライバシーポリシー');
        }
        return false;
      });
      expect(richTextFinder, findsOneWidget);
    });

    testWidgets('ログインボタンが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: LoginPage())),
      );

      // ボタンのテキストを確認
      expect(find.text('Google でログイン'), findsOneWidget);
      expect(find.text('Apple でログイン'), findsOneWidget);

      // Googleボタンのアイコンを確認
      final googleButton = tester.widget<GoogleLoginButton>(
        find.byType(GoogleLoginButton),
      );
      expect(googleButton.isLoading, false);

      // Appleボタンのアイコンを確認
      final appleButton = tester.widget<AppleLoginButton>(
        find.byType(AppleLoginButton),
      );
      expect(appleButton.isLoading, false);
    });
  });
}
