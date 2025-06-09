import 'package:flutter/material.dart';
import '../../../../_gen/i18n/strings.g.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.isLoading,
    required this.icon,
    required this.label,
    this.onPressed,
    this.semanticsId,
  });

  final bool isLoading;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? semanticsId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: semanticsId,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          iconSize: 28,
          textStyle: TextStyle(fontSize: 18),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key, required this.isLoading, this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      isLoading: isLoading,
      icon: Icons.g_mobiledata,
      label: i18n.login.googleSignIn,
      onPressed: onPressed,
      semanticsId: 'google_login_button',
    );
  }
}

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key, required this.isLoading, this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      isLoading: isLoading,
      icon: Icons.apple,
      label: i18n.login.appleSignIn,
      onPressed: onPressed,
      semanticsId: 'apple_login_button',
    );
  }
}

class AnonymousLoginButton extends StatelessWidget {
  const AnonymousLoginButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      isLoading: isLoading,
      icon: Icons.person_outline,
      label: i18n.login.anonymousSignIn,
      onPressed: onPressed,
      semanticsId: 'anonymous_login_button',
    );
  }
}
