import 'package:flutter/material.dart';

/// ローディングオーバーレイウィジェット
class LoadingOverlay extends StatelessWidget {
  /// コンストラクタ
  const LoadingOverlay({super.key, this.color, this.backgroundColor});

  /// インジケーターの色
  final Color? color;

  /// 背景色
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.2),
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: color ?? Colors.white),
        ),
      ),
    );
  }
}
