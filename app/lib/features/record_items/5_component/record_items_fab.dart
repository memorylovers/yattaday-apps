import 'package:flutter/material.dart';

/// 記録項目追加用のFloatingActionButton
///
/// 記録項目一覧画面で新規項目を追加するためのFAB
class RecordItemsFAB extends StatelessWidget {
  const RecordItemsFAB({
    super.key,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF5DD3DC),
    this.icon = const Icon(Icons.add, color: Colors.white),
  });

  /// ボタンが押されたときのコールバック
  final VoidCallback onPressed;

  /// 背景色
  final Color backgroundColor;

  /// アイコン
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: icon,
    );
  }
}
