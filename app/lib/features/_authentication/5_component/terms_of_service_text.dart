import 'package:flutter/material.dart';

class TermsOfServiceText extends StatelessWidget {
  const TermsOfServiceText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          height: 1.5,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
        ),
        children: [
          TextSpan(text: 'ログインすることで、'),
          TextSpan(
            text: '利用規約',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: 'と'),
          TextSpan(
            text: 'プライバシーポリシー',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: 'に同意したものとみなされます'),
        ],
      ),
    );
  }
}