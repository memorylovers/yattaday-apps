import 'package:flutter/material.dart';

/// 「または」のテキストを含む区切り線ウィジェット
class OrDivider extends StatelessWidget {
  /// コンストラクタ
  const OrDivider({
    super.key,
    this.text = 'または',
    this.lineColor,
    this.textColor,
    this.horizontalPadding = 16.0,
  });

  /// 中央に表示するテキスト
  final String text;

  /// 線の色
  final Color? lineColor;

  /// テキストの色
  final Color? textColor;

  /// テキストの左右のパディング
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final defaultLineColor = lineColor ?? Colors.grey.shade400;
    final defaultTextColor = textColor ?? Colors.grey.shade600;

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: defaultLineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(text, style: TextStyle(color: defaultTextColor)),
        ),
        Expanded(child: Container(height: 1, color: defaultLineColor)),
      ],
    );
  }
}
