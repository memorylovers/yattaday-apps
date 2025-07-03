import 'package:flutter/material.dart';
import 'package:common_widget/_gen/assets/assets.gen.dart';
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
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final String? semanticsId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: semanticsId,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: SizedBox(width: 20, height: 20, child: icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      icon: Assets.logos.googleLogo.svg(),
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
      icon: Assets.logos.appleLogoBlack.svg(),
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
      icon: const Icon(Icons.person, size: 20),
      label: i18n.login.anonymousSignIn,
      onPressed: onPressed,
      semanticsId: 'anonymous_login_button',
    );
  }
}
