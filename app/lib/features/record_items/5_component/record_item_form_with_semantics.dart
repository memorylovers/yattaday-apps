import 'package:flutter/material.dart';

import '../3_application/record_item_form_store.dart';
import '../1_models/record_item.dart';

/// Maestroテスト対応版の記録項目作成・編集フォームウィジェット
/// Semanticsを追加してE2Eテストを容易にする
class RecordItemFormWithSemantics extends StatefulWidget {
  const RecordItemFormWithSemantics({
    super.key,
    required this.userId,
    required this.formState,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onIconChanged,
    required this.onUnitChanged,
    required this.onErrorCleared,
    required this.onSubmit,
    this.initialItem,
    this.onSuccess,
    this.onCancel,
  });

  final String userId;
  final RecordItemFormState formState;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onIconChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onErrorCleared;
  final Future<bool> Function() onSubmit;
  final RecordItem? initialItem;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  @override
  State<RecordItemFormWithSemantics> createState() =>
      _RecordItemFormWithSemanticsState();
}

class _RecordItemFormWithSemanticsState
    extends State<RecordItemFormWithSemantics> {
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

    // 編集モードの場合は初期値を設定
    if (initialItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTitleChanged(initialItem.title);
        if (initialItem.description != null) {
          widget.onDescriptionChanged(initialItem.description!);
        }
        if (initialItem.unit != null) {
          widget.onUnitChanged(initialItem.unit!);
        }
        widget.onIconChanged(initialItem.icon);
      });
    }

    // TextEditingControllerの変更をコールバックに同期
    _titleController.addListener(() {
      widget.onTitleChanged(_titleController.text);
    });
    _descriptionController.addListener(() {
      widget.onDescriptionChanged(_descriptionController.text);
    });
    _unitController.addListener(() {
      widget.onUnitChanged(_unitController.text);
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
    final formState = widget.formState;

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
                  widget.onErrorCleared();
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
                  widget.onErrorCleared();
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
                  widget.onErrorCleared();
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
    final success = await widget.onSubmit();

    if (success && widget.onSuccess != null) {
      widget.onSuccess!();
    }
  }
}
