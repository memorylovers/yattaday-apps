import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers/record_item_form_provider.dart';
import '../../domain/record_item.dart';

/// Maestroテスト対応版の記録項目作成・編集フォームウィジェット
/// Semanticsを追加してE2Eテストを容易にする
class RecordItemFormWithSemantics extends ConsumerStatefulWidget {
  const RecordItemFormWithSemantics({
    super.key,
    required this.userId,
    this.initialItem,
    this.onSuccess,
    this.onCancel,
  });

  final String userId;
  final RecordItem? initialItem;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  @override
  ConsumerState<RecordItemFormWithSemantics> createState() =>
      _RecordItemFormWithSemanticsState();
}

class _RecordItemFormWithSemanticsState
    extends ConsumerState<RecordItemFormWithSemantics> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    // 編集モードの場合は初期値を設定
    final initialItem = widget.initialItem;
    _titleController = TextEditingController(text: initialItem?.title ?? '');
    _descriptionController = TextEditingController(
      text: initialItem?.description ?? '',
    );
    _unitController = TextEditingController(text: initialItem?.unit ?? '');

    // 編集モードの場合は初期値をProviderに設定
    if (initialItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(recordItemFormProvider.notifier)
            .updateTitle(initialItem.title);
        if (initialItem.description != null) {
          ref
              .read(recordItemFormProvider.notifier)
              .updateDescription(initialItem.description!);
        }
        if (initialItem.unit != null) {
          ref
              .read(recordItemFormProvider.notifier)
              .updateUnit(initialItem.unit!);
        }
      });
    }

    // TextEditingControllerの変更をProviderに同期
    _titleController.addListener(() {
      ref
          .read(recordItemFormProvider.notifier)
          .updateTitle(_titleController.text);
    });
    _descriptionController.addListener(() {
      ref
          .read(recordItemFormProvider.notifier)
          .updateDescription(_descriptionController.text);
    });
    _unitController.addListener(() {
      ref
          .read(recordItemFormProvider.notifier)
          .updateUnit(_unitController.text);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(recordItemFormProvider);

    // フォームがリセットされた場合、TextEditingControllerもクリア
    ref.listen(recordItemFormProvider, (previous, next) {
      if (previous != null &&
          previous.title.isNotEmpty &&
          next.title.isEmpty &&
          next.description.isEmpty &&
          next.unit.isEmpty) {
        _titleController.clear();
        _descriptionController.clear();
        _unitController.clear();
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // タイトル入力フィールド
          Semantics(
            identifier: 'record_item_title_field',
            label: 'タイトル入力フィールド',
            textField: true,
            child: TextFormField(
              key: const Key('record_item_title_field'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                hintText: 'タイトルを入力してください',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // エラーメッセージをクリア
                if (formState.errorMessage != null) {
                  ref.read(recordItemFormProvider.notifier).clearError();
                }
              },
            ),
          ),
          const SizedBox(height: 16),

          // 説明入力フィールド
          Semantics(
            identifier: 'record_item_description_field',
            label: '説明入力フィールド',
            textField: true,
            child: TextFormField(
              key: const Key('record_item_description_field'),
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '説明',
                hintText: '説明を入力してください（任意）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                // エラーメッセージをクリア
                if (formState.errorMessage != null) {
                  ref.read(recordItemFormProvider.notifier).clearError();
                }
              },
            ),
          ),
          const SizedBox(height: 16),

          // 単位入力フィールド
          Semantics(
            identifier: 'record_item_unit_field',
            label: '単位入力フィールド',
            textField: true,
            child: TextFormField(
              key: const Key('record_item_unit_field'),
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: '単位',
                hintText: '単位を入力してください（任意）',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // エラーメッセージをクリア
                if (formState.errorMessage != null) {
                  ref.read(recordItemFormProvider.notifier).clearError();
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // エラーメッセージ表示
          if (formState.errorMessage != null) ...[
            Semantics(
              identifier: 'error_message',
              label: 'エラーメッセージ',
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formState.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ボタン行
          Row(
            children: [
              // キャンセルボタン
              Expanded(
                child: Semantics(
                  identifier: 'cancel_button',
                  label: 'キャンセルボタン',
                  button: true,
                  child: TextButton(
                    key: const Key('cancel_button'),
                    onPressed: widget.onCancel,
                    child: const Text('キャンセル'),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 作成ボタン
              Expanded(
                child: Semantics(
                  identifier: 'submit_button',
                  label: widget.initialItem != null ? '更新ボタン' : '作成ボタン',
                  button: true,
                  child: ElevatedButton(
                    key: const Key('submit_button'),
                    onPressed:
                        formState.isValid && !formState.isSubmitting
                            ? _onSubmit
                            : null,
                    child:
                        formState.isSubmitting
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(widget.initialItem != null ? '更新' : '作成'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// フォーム送信処理
  Future<void> _onSubmit() async {
    final success =
        widget.initialItem != null
            ? await ref
                .read(recordItemFormProvider.notifier)
                .update(
                  userId: widget.userId,
                  recordItemId: widget.initialItem!.id,
                )
            : await ref
                .read(recordItemFormProvider.notifier)
                .submit(widget.userId);

    if (success && widget.onSuccess != null) {
      widget.onSuccess!();
    }
  }
}
