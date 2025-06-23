import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/scaffold/gradient_scaffold.dart';
import '../1_models/record_item.dart';
import '../5_view_model/record_items_edit_view_model.dart';
import '../6_component/record_item_form.dart';

/// 記録項目編集ページ
class RecordItemsEditPage extends ConsumerStatefulWidget {
  const RecordItemsEditPage({
    super.key,
    required this.userId,
    required this.recordItem,
  });

  final String userId;
  final RecordItem recordItem;

  @override
  ConsumerState<RecordItemsEditPage> createState() =>
      _RecordItemsEditPageState();
}

class _RecordItemsEditPageState extends ConsumerState<RecordItemsEditPage> {
  @override
  void initState() {
    super.initState();
    // ViewModelで初期化を行う
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recordItemsEditViewModelProvider(widget.recordItem).notifier)
          .initializeForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      recordItemsEditViewModelProvider(widget.recordItem).notifier,
    );
    final viewModelState = ref.watch(
      recordItemsEditViewModelProvider(widget.recordItem),
    );

    return GradientScaffold(
      title: '記録項目編集',
      showBackButton: true,
      useWhiteContainer: true,
      body: RecordItemForm(
        userId: widget.userId,
        initialItem: widget.recordItem,
        formState: viewModelState.formState,
        onTitleChanged: viewModel.updateTitle,
        onDescriptionChanged: viewModel.updateDescription,
        onIconChanged: viewModel.updateIcon,
        onUnitChanged: viewModel.updateUnit,
        onErrorCleared: viewModel.clearError,
        onSubmit: viewModel.update,
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
