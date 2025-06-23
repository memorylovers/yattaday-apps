import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_store/record_item_form_store.dart';
import 'package:myapp/features/record_items/3_store/record_items_store.dart';
import 'package:myapp/features/record_items/3_store/record_item_crud_store.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_query_repository.dart';
import 'package:myapp/features/record_items/2_repository/interfaces/record_item_command_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/6_component/record_item_form.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemForm用のモッククエリリポジトリ
class MockRecordItemQueryRepository implements IRecordItemQueryRepository {
  final List<RecordItem> _items = [];
  final bool _shouldThrowError;

  MockRecordItemQueryRepository({
    bool shouldThrowError = false,
    bool shouldDelay = false,
  }) : _shouldThrowError = shouldThrowError;

  @override
  Future<int> getNextSortOrder(String userId) async {
    if (_shouldThrowError) {
      throw Exception('ソート順序取得エラー');
    }
    return _items.where((item) => item.userId == userId).length;
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async => [];

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) => Stream.value([]);

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    if (_shouldThrowError) {
      throw Exception('記録項目取得エラー');
    }
    try {
      return _items.firstWhere(
        (item) => item.id == recordItemId && item.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }
}

/// RecordItemForm用のモックコマンドリポジトリ
class MockRecordItemCommandRepository implements IRecordItemCommandRepository {
  final List<RecordItem> _items = [];
  final bool _shouldThrowError;
  final bool _shouldDelay;

  MockRecordItemCommandRepository({
    bool shouldThrowError = false,
    bool shouldDelay = false,
  }) : _shouldThrowError = shouldThrowError,
       _shouldDelay = shouldDelay;

  @override
  Future<void> create(RecordItem recordItem) async {
    if (_shouldDelay) {
      await Future.delayed(const Duration(seconds: 2));
    }
    if (_shouldThrowError) {
      throw Exception('ネットワークエラーが発生しました');
    }
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    if (_shouldThrowError) {
      throw Exception('更新エラー');
    }
    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) {
      _items[index] = recordItem;
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (_shouldThrowError) {
      throw Exception('削除エラー');
    }
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );
  }
}

class _MockRecordItemFormWrapper extends ConsumerWidget {
  final RecordItemFormState formState;

  const _MockRecordItemFormWrapper({required this.formState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recordItemFormProvider.notifier);
    
    return RecordItemForm(
      userId: 'test-user-id',
      formState: formState,
      onTitleChanged: notifier.updateTitle,
      onDescriptionChanged: notifier.updateDescription,
      onIconChanged: notifier.updateIcon,
      onUnitChanged: notifier.updateUnit,
      onErrorCleared: notifier.clearError,
      onSubmit: () => notifier.submit('test-user-id'),
      onSuccess: () => debugPrint('フォーム送信成功'),
      onCancel: () => debugPrint('フォームキャンセル'),
    );
  }
}

// Default State
@widgetbook.UseCase(
  name: '基本表示',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormDefaultUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(),
      ),
    ],
    child: _MockRecordItemFormWrapper(
      formState: const RecordItemFormState(),
    ),
  );
}

// Filled State
@widgetbook.UseCase(
  name: '入力済み',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormFilledUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(),
      ),
    ],
    child: _MockRecordItemFormWrapper(
      formState: const RecordItemFormState(
        title: '読書',
        description: '毎日読んだ本のページ数を記録',
        icon: '📚',
        unit: 'ページ',
      ),
    ),
  );
}

// Submitting State
@widgetbook.UseCase(
  name: '送信中',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormSubmittingUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(shouldDelay: true),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(shouldDelay: true),
      ),
    ],
    child: _MockRecordItemFormWrapper(
      formState: const RecordItemFormState(
        title: '筋トレ',
        description: 'ジムでのトレーニング記録',
        icon: '💪',
        unit: '回',
        isSubmitting: true,
      ),
    ),
  );
}

// Error State
@widgetbook.UseCase(
  name: 'エラー表示',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormErrorUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(shouldThrowError: true),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(shouldThrowError: true),
      ),
    ],
    child: _MockRecordItemFormWrapper(
      formState: const RecordItemFormState(
        title: '水分補給',
        icon: '💧',
        unit: 'ml',
        errorMessage: 'ネットワークエラーが発生しました。再度お試しください。',
      ),
    ),
  );
}

// Edit Mode
@widgetbook.UseCase(
  name: '編集モード',
  type: RecordItemForm,
  path: 'features/record_item',
)
Widget buildRecordItemFormEditModeUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemQueryRepositoryProvider.overrideWithValue(
        MockRecordItemQueryRepository(),
      ),
      recordItemCommandRepositoryProvider.overrideWithValue(
        MockRecordItemCommandRepository(),
      ),
    ],
    child: const _PrefilledFormWrapper(),
  );
}

// 編集モード用のWrapper（既存データをフォームに設定）
class _PrefilledFormWrapper extends ConsumerWidget {
  const _PrefilledFormWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 既存の記録項目データで初期化
    const formState = RecordItemFormState(
      title: '瞑想',
      description: '朝の瞑想時間を記録',
      icon: '🧘',
      unit: '分',
    );

    final notifier = ref.read(recordItemFormProvider.notifier);

    return RecordItemForm(
      userId: 'test-user-id',
      formState: formState,
      onTitleChanged: notifier.updateTitle,
      onDescriptionChanged: notifier.updateDescription,
      onIconChanged: notifier.updateIcon,
      onUnitChanged: notifier.updateUnit,
      onErrorCleared: notifier.clearError,
      onSubmit: () => notifier.update(
        userId: 'test-user-id',
        recordItemId: 'test-item-id',
      ),
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
}