import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/components/logo/app_logo.dart';

void main() {
  group('AppLogo', () {
    testWidgets('デフォルトサイズでロゴが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLogo())),
      );

      // SVGが表示されているか
      expect(find.byType(SvgPicture), findsOneWidget);

      // デフォルトサイズを確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.width, 120);
      expect(svgPicture.height, 120);
    });

    testWidgets('カスタムサイズでロゴが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLogo(size: 200))),
      );

      // カスタムサイズを確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.width, 200);
      expect(svgPicture.height, 200);
    });

    testWidgets('カスタムカラーでロゴが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLogo(color: Colors.red))),
      );

      // カラーフィルターが適用されているか確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.colorFilter, isNotNull);
      expect(
        svgPicture.colorFilter,
        const ColorFilter.mode(Colors.red, BlendMode.srcIn),
      );
    });

    testWidgets('カラー指定なしでロゴが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLogo(color: null))),
      );

      // カラーフィルターが適用されていないか確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.colorFilter, isNull);
    });

    testWidgets('幅と高さを個別に指定できる', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLogo(width: 150, height: 100)),
        ),
      );

      // 個別の幅と高さを確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.width, 150);
      expect(svgPicture.height, 100);
    });

    testWidgets('sizeとwidth/heightの両方が指定された場合、width/heightが優先される', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLogo(size: 200, width: 150, height: 100)),
        ),
      );

      // width/heightが優先されることを確認
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svgPicture.width, 150);
      expect(svgPicture.height, 100);
    });
  });
}
