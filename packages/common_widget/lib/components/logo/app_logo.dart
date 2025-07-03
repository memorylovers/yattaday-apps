import 'package:flutter/material.dart';

import '../../_gen/assets/assets.gen.dart';

/// アプリケーションのロゴウィジェット
///
/// アプリ全体で統一されたロゴ表示を提供する共通コンポーネント
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size, this.width, this.height, this.color});

  /// ロゴのサイズ（正方形の場合に使用）
  /// widthとheightが指定されていない場合に適用される
  final double? size;

  /// ロゴの幅
  /// sizeよりも優先される
  final double? width;

  /// ロゴの高さ
  /// sizeよりも優先される
  final double? height;

  /// ロゴの色
  /// nullの場合は元の色が使用される
  final Color? color;

  /// デフォルトのロゴサイズ
  static const double defaultSize = 120;

  @override
  Widget build(BuildContext context) {
    // width/heightが指定されていれば優先、なければsizeを使用
    final logoWidth = width ?? size ?? defaultSize;
    final logoHeight = height ?? size ?? defaultSize;

    return Assets.icons.icon.svg(
      width: logoWidth,
      height: logoHeight,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
