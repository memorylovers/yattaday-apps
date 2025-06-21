import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/6_page/login_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// LoginPageのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: LoginPage, path: '[pages]')
Widget loginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    ),
  );
}
