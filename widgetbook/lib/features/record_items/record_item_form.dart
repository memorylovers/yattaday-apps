import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_application/providers/record_item_form_provider.dart';
import 'package:myapp/features/record_items/3_application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/5_component/record_item_form.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// RecordItemForm用のモックリポジトリ
class MockRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  final bool _shouldThrowError;
  final bool _shouldDelay;

  MockRecordItemRepository({
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
  Future<void> update(RecordItem recordItem) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String userId, String recordItemId) async =>
      throw UnimplementedError();

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async =>
      throw UnimplementedError();
}

/// RecordItemFormをラップして新しいパラメータに対応
class _MockRecordItemFormWrapper extends ConsumerWidget {
  const _MockRecordItemFormWrapper({
    required this.userId,
    this.onSuccess,
    this.onCancel,
  });

  final String userId;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(recordItemFormProvider);
    final notifier = ref.read(recordItemFormProvider.notifier);

    return RecordItemForm(
      userId: userId,
      formState: formState,
      onTitleChanged: notifier.updateTitle,
      onDescriptionChanged: notifier.updateDescription,
      onIconChanged: notifier.updateIcon,
      onUnitChanged: notifier.updateUnit,
      onErrorCleared: notifier.clearError,
      onSubmit: () async {
        final success = await notifier.submit(userId);
        if (success && onSuccess != null) {
          onSuccess!();
        }
        return success;
      },
      onSuccess: onSuccess,
      onCancel: onCancel,
    );
  }
}

@widgetbook.UseCase(
  name: 'Default',
  type: RecordItemForm,
  path: 'features/record_items/',
)
Widget recordItemFormDefault(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成')),
      body: _MockRecordItemFormWrapper(
        userId: 'widgetbook-user',
        onSuccess: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('作成が完了しました！')));
        },
        onCancel: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('キャンセルしました')));
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: RecordItemForm,
  path: 'features/record_items/',
)
Widget recordItemFormWithError(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldThrowError: true),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（エラーテスト）')),
      body: _MockRecordItemFormWrapper(
        userId: 'widgetbook-user',
        onSuccess: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('作成が完了しました！')));
        },
        onCancel: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('キャンセルしました')));
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Delay',
  type: RecordItemForm,
  path: 'features/record_items/',
)
Widget recordItemFormWithDelay(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldDelay: true),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（ローディングテスト）')),
      body: _MockRecordItemFormWrapper(
        userId: 'widgetbook-user',
        onSuccess: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('作成が完了しました！')));
        },
        onCancel: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('キャンセルしました')));
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Without Callbacks',
  type: RecordItemForm,
  path: 'features/record_items/',
)
Widget recordItemFormWithoutCallbacks(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（コールバックなし）')),
      body: const _MockRecordItemFormWrapper(
        userId: 'widgetbook-user',
        // onSuccess・onCancelを指定しない
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Prefilled Form',
  type: RecordItemForm,
  path: 'features/record_items/',
)
Widget recordItemFormPrefilled(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('記録項目作成（入力済み）')),
    body: const _PrefilledFormWrapper(),
  );
}

/// 事前入力済みフォームのラッパー
class _PrefilledFormWrapper extends StatelessWidget {
  const _PrefilledFormWrapper();

  @override
  Widget build(BuildContext context) {
    // 初期値を持つモックフォーム状態を作成
    const prefilledFormState = RecordItemFormState(
      title: '読書記録',
      description: '毎日30分以上本を読んで知識を身につける',
      icon: '📖',
      unit: 'ページ',
      isSubmitting: false,
      errorMessage: null,
    );

    return RecordItemForm(
      userId: 'widgetbook-user',
      formState: prefilledFormState,
      onTitleChanged: (_) {},
      onDescriptionChanged: (_) {},
      onIconChanged: (_) {},
      onUnitChanged: (_) {},
      onErrorCleared: () {},
      onSubmit: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('作成が完了しました！')));
        }
        return true;
      },
      onSuccess: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('作成が完了しました！')));
      },
      onCancel: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('キャンセルしました')));
      },
    );
  }
}
