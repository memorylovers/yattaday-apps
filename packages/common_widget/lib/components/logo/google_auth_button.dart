import 'package:flutter/material.dart';

import '../../_gen/assets/assets.gen.dart';

/// Button Widget to sign in with your Google account.
class GoogleAuthButton extends StatelessWidget {
  /// Creates a new instance of [GoogleAuthButton].
  ///
  /// The action [onPressed], which is the action when the button is pressed,
  /// is a required field.
  const GoogleAuthButton({
    super.key,
    this.labelText = 'Sign in with Google',
    required this.onPressed,
  });

  /// Label text to be displayed on the button.
  final String labelText;

  /// Callback executed when a button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.inverseSurface,
        shape: StadiumBorder(
          side: isLightTheme ? const BorderSide() : BorderSide.none,
        ),
      ),
      icon: SizedBox.square(
        dimension: 20,
        child: Assets.logos.googleLogo.svg(),
      ),
      label: Text(labelText),
    );
  }
}
