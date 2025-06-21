import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../common/logger/logger.dart';

import '../3_application/startup_store.dart';
import '../5_component/startup_error_widget.dart';
import '../5_component/startup_loading_widget.dart';

/// 初期起動画面
class StartupPage extends HookConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(startupProvider);
    return startupState.maybeWhen(
      orElse: () => const StartupLoadingWidget(),
      error: (e, st) {
        logger.handle(e, st);
        return StartupErrorWidget(
          error: e,
          onRetry: () => ref.invalidate(startupProvider),
        );
      },
    );
  }
}
