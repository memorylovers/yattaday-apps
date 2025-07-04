import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/scaffold/gradient_scaffold.dart';
import '../5_view_model/record_item_create_view_model.dart';
import '../6_component/record_item_form.dart';

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
        onSubmit: () async {
          bool success = false;
          await viewModel.submit(
            onSuccess: () {
              success = true;
              Navigator.of(context).pop();
            },
            onError: (error) {
              // エラーはformStateにerrorMessageとして表示される
            },
          );
          return success;
        },
        onSuccess: null,
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
