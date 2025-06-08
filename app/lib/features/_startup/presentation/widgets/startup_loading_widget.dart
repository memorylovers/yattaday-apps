import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';

/// startup中のローディングWidget
class StartupLoadingWidget extends StatelessWidget {
  const StartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
