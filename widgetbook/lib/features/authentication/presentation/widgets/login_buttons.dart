import 'package:flutter/material.dart';
import 'package:myapp/features/_authentication/presentation/widgets/login_buttons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// GoogleLoginButtonのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: GoogleLoginButton, designLink: '')
Widget googleLoginButtonUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return Center(
    child: SizedBox(
      width: 300,
      child: GoogleLoginButton(
        isLoading: isLoading,
        onPressed: isLoading
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Google Login Button Pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
      ),
    ),
  );
}

/// AppleLoginButtonのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: AppleLoginButton, designLink: '')
Widget appleLoginButtonUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return Center(
    child: SizedBox(
      width: 300,
      child: AppleLoginButton(
        isLoading: isLoading,
        onPressed: isLoading
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Apple Login Button Pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
      ),
    ),
  );
}

/// AnonymousLoginButtonのWidgetbook設定
@widgetbook.UseCase(name: 'Default', type: AnonymousLoginButton, designLink: '')
Widget anonymousLoginButtonUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  return Center(
    child: SizedBox(
      width: 300,
      child: AnonymousLoginButton(
        isLoading: isLoading,
        onPressed: isLoading
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anonymous Login Button Pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
      ),
    ),
  );
}

/// すべてのLoginButtonを表示するショーケース
@widgetbook.UseCase(name: 'All Variants', type: GoogleLoginButton, designLink: '')
Widget allLoginButtonsUseCase(BuildContext context) {
  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoogleLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () => showSnackBar('Google Login'),
        ),
        const SizedBox(height: 12),
        AppleLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () => showSnackBar('Apple Login'),
        ),
        const SizedBox(height: 12),
        AnonymousLoginButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () => showSnackBar('Anonymous Login'),
        ),
      ],
    ),
  );
}