import 'package:flutter/material.dart';

import '../3_application/record_item_form_store.dart';
import '../1_models/record_item.dart';

/// 記録項目作成・編集フォームウィジェット
class RecordItemForm extends StatefulWidget {
  const RecordItemForm({
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
  State<RecordItemForm> createState() => _RecordItemFormState();
}

class _RecordItemFormState extends State<RecordItemForm> {
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

    // 編集モードの場合、TextEditingControllerはinitialItemから初期値を設定済み
    // formStateの更新はViewModelまたは親ウィジェットの責任とする

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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 絵文字ピッカー
          const Text(
            'アイコンを選択',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: GridView.count(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children:
                  [
                    '📝',
                    '✓',
                    '🏃',
                    '💪',
                    '📖',
                    '🛍',
                    '🍴',
                    '💧',
                    '💰',
                    '🎯',
                    '🎮',
                    '🎨',
                    '🎵',
                    '🌱',
                    '❤️',
                  ].map((emoji) {
                    final isSelected = formState.icon == emoji;
                    return InkWell(
                      onTap: () {
                        widget.onIconChanged(emoji);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              isSelected
                                  ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  )
                                  : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // タイトル入力フィールド
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'タイトル *',
              hintText: 'タイトルを入力してください',
              border: const OutlineInputBorder(),
              counterText: '${_titleController.text.length}/20',
            ),
            maxLength: 20,
            onChanged: (value) {
              setState(() {});
              // エラーメッセージをクリア
              if (formState.errorMessage != null) {
                widget.onErrorCleared();
              }
            },
          ),
          const SizedBox(height: 16),

          // 説明入力フィールド
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: '説明',
              hintText: '説明を入力してください（任意）',
              border: const OutlineInputBorder(),
              counterText: '${_descriptionController.text.length}/200',
            ),
            maxLength: 200,
            maxLines: 3,
            onChanged: (value) {
              setState(() {});
              // エラーメッセージをクリア
              if (formState.errorMessage != null) {
                widget.onErrorCleared();
              }
            },
          ),
          const SizedBox(height: 16),

          // 単位入力フィールド
          TextFormField(
            controller: _unitController,
            decoration: InputDecoration(
              labelText: '単位',
              hintText: '単位を入力してください（任意）',
              border: const OutlineInputBorder(),
              counterText: '${_unitController.text.length}/10',
            ),
            maxLength: 10,
            onChanged: (value) {
              setState(() {});
              // エラーメッセージをクリア
              if (formState.errorMessage != null) {
                widget.onErrorCleared();
              }
            },
          ),
          const SizedBox(height: 24),

          // エラーメッセージ表示
          if (formState.errorMessage != null) ...[
            Container(
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
            const SizedBox(height: 16),
          ],

          // ボタン行
          Row(
            children: [
              // キャンセルボタン
              Expanded(
                child: TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('キャンセル'),
                ),
              ),
              const SizedBox(width: 16),

              // 作成ボタン
              Expanded(
                child: ElevatedButton(
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
