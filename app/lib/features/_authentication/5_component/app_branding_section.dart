import 'package:common_widget/common_widget.dart';
import 'package:flutter/material.dart';

/// アプリのブランディングセクション（ロゴ、アプリ名、サブタイトル）
class AppBrandingSection extends StatelessWidget {
  /// コンストラクタ
  const AppBrandingSection({
    super.key,
    this.logoSize = 200,
    this.logoColor = Colors.white,
    this.titleFontSize = 40,
    this.titleColor = Colors.white,
    this.subtitleFontSize = 16,
    this.subtitleColor,
    this.title = 'YattaDay',
    this.subtitle = '毎日の記録を簡単に',
  });

  /// ロゴのサイズ
  final double logoSize;

  /// ロゴの色
  final Color logoColor;

  /// タイトルのフォントサイズ
  final double titleFontSize;

  /// タイトルの色
  final Color titleColor;

  /// サブタイトルのフォントサイズ
  final double subtitleFontSize;

  /// サブタイトルの色
  final Color? subtitleColor;

  /// アプリ名
  final String title;

  /// サブタイトル
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final defaultSubtitleColor =
        subtitleColor ?? Colors.white.withValues(alpha: 0.8);

    return Column(
      children: [
        // ロゴ
        AppLogo(size: logoSize, color: logoColor),
        // アプリ名
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        // サブタイトル
        Text(
          subtitle,
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: defaultSubtitleColor,
          ),
        ),
      ],
    );
  }
}
