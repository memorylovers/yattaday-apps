import 'package:flutter/material.dart';

/// 右矢印のアイコンボタン
///
/// 次のページへの遷移や、日付の進むボタンなどに使用
class IconButtonArrowRight extends StatelessWidget {
  const IconButtonArrowRight({
    super.key,
    required this.onPressed,
    this.iconSize = 36,
  });

  /// ボタンが押されたときのコールバック
  final VoidCallback onPressed;

  /// アイコンのサイズ
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      icon: const Icon(Icons.chevron_right),
      onPressed: onPressed,
    );
  }
}
