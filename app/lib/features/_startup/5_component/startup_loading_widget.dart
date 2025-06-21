import 'package:flutter/material.dart';

import '../../../../_gen/i18n/strings.g.dart';
import '../../../../common/theme/app_colors.dart';
import 'package:common_widget/common_widget.dart';

/// startup中のローディングWidget
class StartupLoadingWidget extends StatelessWidget {
  const StartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final version = "1.0.0";

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradientColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // アプリロゴ
            const AppLogo(size: 200, color: Colors.white),
            const SizedBox(height: 8),
            // アプリ名
            Text(
              i18n.app.name,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            // ローディング表示
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            const Spacer(),
            // バージョン情報
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Version $version',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
