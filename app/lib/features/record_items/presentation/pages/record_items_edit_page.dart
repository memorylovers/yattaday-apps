import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/scaffold/gradient_scaffold.dart';
import '../../domain/record_item.dart';
import '../widgets/record_item_form.dart';

/// 記録項目編集ページ
class RecordItemsEditPage extends ConsumerWidget {
  const RecordItemsEditPage({
    super.key,
    required this.userId,
    required this.recordItem,
  });

  final String userId;
  final RecordItem recordItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientScaffold(
      title: '記録項目編集',
      showBackButton: true,
      useWhiteContainer: true,
      body: RecordItemForm(
        userId: userId,
        initialItem: recordItem,
        onSuccess: () {
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
