import 'package:flutter/material.dart';

/// 左矢印のアイコンボタン
///
/// 前のページへの遷移や、日付の戻るボタンなどに使用
class IconButtonArrowLeft extends StatelessWidget {
  const IconButtonArrowLeft({
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
      icon: const Icon(Icons.chevron_left),
      onPressed: onPressed,
    );
  }
}
