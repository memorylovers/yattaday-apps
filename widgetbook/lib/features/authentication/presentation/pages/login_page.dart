import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:myapp/features/_authentication/presentation/login_page.dart';

/// LoginPageのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: LoginPage)
Widget loginPageUseCase(BuildContext context) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    ),
  );
}
