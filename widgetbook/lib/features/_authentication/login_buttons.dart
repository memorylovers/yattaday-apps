import 'package:flutter/material.dart';
import 'package:myapp/features/_authentication/presentation/widgets/login_buttons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// LoginButtonのWidgetbook設定
@widgetbook.UseCase(
  name: 'All Variants',
  type: LoginButton,
  path: 'features/_authentication/',
  designLink: '',
)
Widget loginButtonUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoogleLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () {},
        ),
        const SizedBox(height: 12),
        AppleLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () {},
        ),
        const SizedBox(height: 12),
        AnonymousLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () {},
        ),
      ],
    ),
  );
}
