import 'package:flutter/material.dart';

import '../../../../components/scaffold/gradient_scaffold.dart';
import '../widgets/record_item_form.dart';

/// 記録項目作成ページ
class RecordItemsCreatePage extends StatelessWidget {
  const RecordItemsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: '記録項目作成',
      showBackButton: true,
      useWhiteContainer: true,
      body: RecordItemForm(
        userId: userId,
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
