import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO: 実装時に有効化
// import '../../../_gen/i18n/strings.g.dart';

class ForceUpdateDialog extends HookConsumerWidget {
  const ForceUpdateDialog({super.key});

  static show(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (ctx) => const ForceUpdateDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: not implement
    throw UnimplementedError();

    // 以下のコードは実装時に使用予定
    // final title = i18n.forceUpdate.title;
    // final message = i18n.forceUpdate.desc;
    // final btnLabel = i18n.forceUpdate.label;

    // return PopScope(
    //   canPop: false,
    //   child: ConfirmDialog(
    //     title: title,
    //     confirmLabel: btnLabel,
    //     canClose: false,
    //     autoClose: false,
    //     messages: [message],
    //     onConfirm: launchStoreUrl,
    //   ),
    // );
  }
}
