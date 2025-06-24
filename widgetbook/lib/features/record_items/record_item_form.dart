import 'package:flutter/material.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/3_store/record_item_form_store.dart';
import 'package:myapp/features/record_items/6_component/record_item_form.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Default State
@widgetbook.UseCase(
  name: '基本表示',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormDefaultUseCase(BuildContext context) {
  return RecordItemForm(
    userId: 'test-user-id',
    formState: const RecordItemFormState(),
    onTitleChanged: (title) => debugPrint('Title: $title'),
    onDescriptionChanged: (desc) => debugPrint('Description: $desc'),
    onIconChanged: (icon) => debugPrint('Icon: $icon'),
    onUnitChanged: (unit) => debugPrint('Unit: $unit'),
    onErrorCleared: () => debugPrint('Error cleared'),
    onSubmit: () async {
      debugPrint('Submit');
      return true;
    },
    onSuccess: () => debugPrint('フォーム送信成功'),
    onCancel: () => debugPrint('フォームキャンセル'),
  );
}

// Filled State
@widgetbook.UseCase(
  name: '入力済み',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormFilledUseCase(BuildContext context) {
  return RecordItemForm(
    userId: 'test-user-id',
    formState: const RecordItemFormState(
      title: '読書',
      description: '毎日読んだ本のページ数を記録',
      icon: '📚',
      unit: 'ページ',
    ),
    onTitleChanged: (title) => debugPrint('Title: $title'),
    onDescriptionChanged: (desc) => debugPrint('Description: $desc'),
    onIconChanged: (icon) => debugPrint('Icon: $icon'),
    onUnitChanged: (unit) => debugPrint('Unit: $unit'),
    onErrorCleared: () => debugPrint('Error cleared'),
    onSubmit: () async {
      debugPrint('Submit');
      return true;
    },
    onSuccess: () => debugPrint('フォーム送信成功'),
    onCancel: () => debugPrint('フォームキャンセル'),
  );
}

// Submitting State
@widgetbook.UseCase(
  name: '送信中',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormSubmittingUseCase(BuildContext context) {
  return RecordItemForm(
    userId: 'test-user-id',
    formState: const RecordItemFormState(
      title: '筋トレ',
      description: 'ジムでのトレーニング記録',
      icon: '💪',
      unit: '回',
      isSubmitting: true,
    ),
    onTitleChanged: (title) => debugPrint('Title: $title'),
    onDescriptionChanged: (desc) => debugPrint('Description: $desc'),
    onIconChanged: (icon) => debugPrint('Icon: $icon'),
    onUnitChanged: (unit) => debugPrint('Unit: $unit'),
    onErrorCleared: () => debugPrint('Error cleared'),
    onSubmit: () async {
      debugPrint('Submit');
      return true;
    },
    onSuccess: () => debugPrint('フォーム送信成功'),
    onCancel: () => debugPrint('フォームキャンセル'),
  );
}

// Error State
@widgetbook.UseCase(
  name: 'エラー表示',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormErrorUseCase(BuildContext context) {
  return RecordItemForm(
    userId: 'test-user-id',
    formState: const RecordItemFormState(
      title: '水分補給',
      icon: '💧',
      unit: 'ml',
      errorMessage: 'ネットワークエラーが発生しました。再度お試しください。',
    ),
    onTitleChanged: (title) => debugPrint('Title: $title'),
    onDescriptionChanged: (desc) => debugPrint('Description: $desc'),
    onIconChanged: (icon) => debugPrint('Icon: $icon'),
    onUnitChanged: (unit) => debugPrint('Unit: $unit'),
    onErrorCleared: () => debugPrint('Error cleared'),
    onSubmit: () async {
      debugPrint('Submit with error');
      return false;
    },
    onSuccess: () => debugPrint('フォーム送信成功'),
    onCancel: () => debugPrint('フォームキャンセル'),
  );
}

// Edit Mode
@widgetbook.UseCase(
  name: '編集モード',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormEditModeUseCase(BuildContext context) {
  return RecordItemForm(
    userId: 'test-user-id',
    formState: const RecordItemFormState(
      title: '瞑想',
      description: '朝の瞑想時間を記録',
      icon: '🧘',
      unit: '分',
    ),
    onTitleChanged: (title) => debugPrint('Title: $title'),
    onDescriptionChanged: (desc) => debugPrint('Description: $desc'),
    onIconChanged: (icon) => debugPrint('Icon: $icon'),
    onUnitChanged: (unit) => debugPrint('Unit: $unit'),
    onErrorCleared: () => debugPrint('Error cleared'),
    onSubmit: () async {
      debugPrint('Update');
      return true;
    },
    initialItem: RecordItem(
      id: 'test-item-id',
      userId: 'test-user-id',
      title: '瞑想',
      description: '朝の瞑想時間を記録',
      icon: '🧘',
      unit: '分',
      sortOrder: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
    onSuccess: () => debugPrint('編集成功'),
    onCancel: () => debugPrint('編集キャンセル'),
  );
}