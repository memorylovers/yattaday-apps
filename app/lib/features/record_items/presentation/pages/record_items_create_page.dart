import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/scaffold/gradient_scaffold.dart';
import '../view_models/record_items_create_view_model.dart';
import '../widgets/record_item_form.dart';

/// 記録項目作成ページ
class RecordItemsCreatePage extends ConsumerWidget {
  const RecordItemsCreatePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(recordItemsCreateViewModelProvider.notifier);
    final viewModelState = ref.watch(recordItemsCreateViewModelProvider);

    return GradientScaffold(
      title: '記録項目作成',
      showBackButton: true,
      useWhiteContainer: true,
      body: RecordItemForm(
        userId: userId,
        formState: viewModelState.formState,
        onTitleChanged: viewModel.updateTitle,
        onDescriptionChanged: viewModel.updateDescription,
        onIconChanged: viewModel.updateIcon,
        onUnitChanged: viewModel.updateUnit,
        onErrorCleared: viewModel.clearError,
        onSubmit: viewModel.submit,
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
