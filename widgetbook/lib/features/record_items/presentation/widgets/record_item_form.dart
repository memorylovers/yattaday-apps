import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_item_form_provider.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_form.dart';
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

@widgetbook.UseCase(name: 'Default', type: RecordItemForm)
Widget recordItemFormDefault(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成')),
      body: RecordItemForm(
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

@widgetbook.UseCase(name: 'With Error', type: RecordItemForm)
Widget recordItemFormWithError(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldThrowError: true),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（エラーテスト）')),
      body: RecordItemForm(
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

@widgetbook.UseCase(name: 'With Delay', type: RecordItemForm)
Widget recordItemFormWithDelay(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(shouldDelay: true),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（ローディングテスト）')),
      body: RecordItemForm(
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

@widgetbook.UseCase(name: 'Without Callbacks', type: RecordItemForm)
Widget recordItemFormWithoutCallbacks(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（コールバックなし）')),
      body: const RecordItemForm(
        userId: 'widgetbook-user',
        // onSuccess・onCancelを指定しない
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Prefilled Form', type: RecordItemForm)
Widget recordItemFormPrefilled(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordItemRepositoryProvider.overrideWithValue(
        MockRecordItemRepository(),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text('記録項目作成（入力済み）')),
      body: const _PrefilledFormWrapper(),
    ),
  );
}

/// 事前入力済みフォームのラッパー
class _PrefilledFormWrapper extends ConsumerStatefulWidget {
  const _PrefilledFormWrapper();

  @override
  ConsumerState<_PrefilledFormWrapper> createState() =>
      _PrefilledFormWrapperState();
}

class _PrefilledFormWrapperState extends ConsumerState<_PrefilledFormWrapper> {
  @override
  void initState() {
    super.initState();
    // フォームに初期値を設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(recordItemFormProvider.notifier);
      notifier.updateTitle('読書記録');
      notifier.updateDescription('毎日30分以上本を読んで知識を身につける');
      notifier.updateUnit('ページ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecordItemForm(
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
    );
  }
}
