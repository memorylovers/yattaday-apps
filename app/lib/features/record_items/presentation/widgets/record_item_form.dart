import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers/record_item_form_provider.dart';
import '../../domain/record_item.dart';

/// 記録項目作成・編集フォームウィジェット
class RecordItemForm extends ConsumerStatefulWidget {
  const RecordItemForm({
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
  ConsumerState<RecordItemForm> createState() => _RecordItemFormState();
}

class _RecordItemFormState extends ConsumerState<RecordItemForm> {
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
        ref.read(recordItemFormProvider.notifier).updateIcon(initialItem.icon);
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
                        ref
                            .read(recordItemFormProvider.notifier)
                            .updateIcon(emoji);
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
                ref.read(recordItemFormProvider.notifier).clearError();
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
                ref.read(recordItemFormProvider.notifier).clearError();
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
                ref.read(recordItemFormProvider.notifier).clearError();
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
