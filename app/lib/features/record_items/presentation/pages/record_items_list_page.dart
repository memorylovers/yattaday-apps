import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers/record_items_provider.dart';
import '../../domain/record_item.dart';
import '../widgets/record_item_list_view.dart';

/// 記録項目一覧画面
class RecordItemsListPage extends ConsumerWidget {
  const RecordItemsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordItemsAsync = ref.watch(watchRecordItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('記録項目')),
      body: recordItemsAsync.when(
        data:
            (items) => RecordItemListView(
              items: items,
              onItemTap: (item) => _navigateToDetail(context, item),
              onItemEdit: (item) => _navigateToEdit(context, item),
              onItemDelete:
                  (item) => _showDeleteConfirmDialog(context, ref, item),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('エラーが発生しました', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(watchRecordItemsProvider),
                    child: const Text('再試行'),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 記録項目詳細画面への遷移（現在はモック実装）
  void _navigateToDetail(BuildContext context, RecordItem item) {
    // TODO: 詳細画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.title}の詳細画面へ遷移')));
  }

  /// 記録項目編集画面への遷移（現在はモック実装）
  void _navigateToEdit(BuildContext context, RecordItem item) {
    // TODO: 編集画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.title}の編集画面へ遷移')));
  }

  /// 記録項目作成画面への遷移（現在はモック実装）
  void _navigateToCreate(BuildContext context) {
    // TODO: 作成画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('作成画面へ遷移')));
  }

  /// 削除確認ダイアログの表示（現在はモック実装）
  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    RecordItem item,
  ) {
    // TODO: 削除機能の実装後に実際の削除処理を追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.title}の削除確認ダイアログ表示')));
  }
}
