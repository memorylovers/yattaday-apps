import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:myapp/features/_authentication/presentation/login_page.dart';

/// LoginPageのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: LoginPage, designLink: '')
Widget defaultLoginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    ),
  );
}

/// LoginPage - ローディング状態のシミュレーション
@widgetbook.UseCase(name: 'Loading State', type: LoginPage, designLink: '')
Widget loadingLoginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          // ローディング状態をシミュレートするため、
          // ボタンを押すとローディングが表示される
          return const LoginPage();
        },
      ),
    ),
  );
}

/// LoginPage - ダークモード
@widgetbook.UseCase(name: 'Dark Mode', type: LoginPage, designLink: '')
Widget darkModeLoginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
    ),
  );
}

/// LoginPage - タブレットサイズ
@widgetbook.UseCase(name: 'Tablet Size', type: LoginPage, designLink: '')
Widget tabletLoginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: const MediaQueryData(size: Size(768, 1024)),
        child: const LoginPage(),
      ),
    ),
  );
}

/// LoginPage - アクセシビリティ（大きいフォント）
@widgetbook.UseCase(name: 'Large Text', type: LoginPage, designLink: '')
Widget largeTextLoginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        );
      },
      home: const LoginPage(),
    ),
  );
}
