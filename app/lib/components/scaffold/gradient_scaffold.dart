import 'package:flutter/material.dart';

import '../../common/theme/app_colors.dart';

/// グラデーション背景を持つ共通Scaffold
///
/// record_items関連のページで使用される統一されたデザインを提供する
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    this.title,
    this.leading,
    this.showBackButton = false,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = true,
    this.useWhiteContainer = false,
    this.bottomPadding,
    this.bottomSafeArea = false,
  });

  /// AppBarのタイトル
  final String? title;

  /// AppBarの左側ウィジェット
  final Widget? leading;

  /// 戻るボタンを表示するかどうか
  final bool showBackButton;

  /// AppBarのアクションボタン
  final List<Widget>? actions;

  /// Scaffoldのボディ
  final Widget body;

  /// FloatingActionButton
  final Widget? floatingActionButton;

  /// AppBarの背後にボディを拡張するか
  final bool extendBodyBehindAppBar;

  /// ボディを白背景のContainerで包むか
  final bool useWhiteContainer;

  /// 下部のパディング（FABなどのための余白）
  final double? bottomPadding;

  /// SafeAreaの下部を適用するか
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = body;

    // 下部パディングを適用
    if (bottomPadding != null) {
      bodyContent = Padding(
        padding: EdgeInsets.only(bottom: bottomPadding!),
        child: bodyContent,
      );
    }

    // 白背景コンテナで包む
    if (useWhiteContainer) {
      bodyContent = Container(color: Colors.white, child: bodyContent);
    }

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar:
          title != null || actions != null || showBackButton || leading != null
              ? AppBar(
                title: title != null ? Text(title!) : null,
                centerTitle: true,
                titleTextStyle: TextStyle(fontSize: 16, height: 1.1),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                leading:
                    leading ?? (showBackButton ? const BackButton() : null),
                actions: actions,
              )
              : null,
      body: Container(
        decoration: BoxDecoration(gradient: gradientColor),
        child: SafeArea(bottom: bottomSafeArea, child: bodyContent),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
