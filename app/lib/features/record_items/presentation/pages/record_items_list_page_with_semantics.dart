import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers/record_items_provider.dart';
import '../../domain/record_item.dart';
import '../widgets/record_item_list_view.dart';

/// Maestroテスト対応版の記録項目一覧画面
/// Semanticsを追加してE2Eテストを容易にする
class RecordItemsListPageWithSemantics extends ConsumerWidget {
  const RecordItemsListPageWithSemantics({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordItemsAsync = ref.watch(watchRecordItemsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('記録項目')),
      body: recordItemsAsync.when(
        data:
            (items) =>
                items.isEmpty
                    ? Semantics(
                      identifier: 'empty_state',
                      label: '記録項目が空の状態',
                      child: const Center(
                        child: Text(
                          '記録項目がありません',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    : RecordItemListView(
                      items: items,
                      onItemTap: (item) => _navigateToDetail(context, item),
                      onItemEdit: (item) => _navigateToEdit(context, item),
                      onItemDelete:
                          (item) =>
                              _showDeleteConfirmDialog(context, ref, item),
                    ),
        loading:
            () => Semantics(
              identifier: 'loading_indicator',
              label: '読み込み中',
              child: const Center(child: CircularProgressIndicator()),
            ),
        error:
            (error, stackTrace) => Semantics(
              identifier: 'error_state',
              label: 'エラー状態',
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('エラーが発生しました', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Semantics(
                      identifier: 'retry_button',
                      label: '再試行ボタン',
                      button: true,
                      child: ElevatedButton(
                        key: const Key('retry_button'),
                        onPressed:
                            () => ref.refresh(watchRecordItemsProvider(userId)),
                        child: const Text('再試行'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
      floatingActionButton: Semantics(
        identifier: 'add_record_item_fab',
        label: '記録項目追加ボタン',
        button: true,
        child: FloatingActionButton(
          key: const Key('add_record_item_fab'),
          onPressed: () => _navigateToCreate(context),
          child: const Icon(Icons.add),
        ),
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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('削除の確認'),
            content: Text('「${item.title}」を本当に削除しますか？'),
            actions: [
              Semantics(
                identifier: 'delete_cancel_button',
                label: '削除キャンセルボタン',
                button: true,
                child: TextButton(
                  key: const Key('delete_cancel_button'),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
              ),
              Semantics(
                identifier: 'delete_confirm_button',
                label: '削除確認ボタン',
                button: true,
                child: TextButton(
                  key: const Key('delete_confirm_button'),
                  onPressed: () {
                    // TODO: 実際の削除処理を実装
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.title}を削除しました')),
                    );
                  },
                  child: const Text('削除する'),
                ),
              ),
            ],
          ),
    );
  }
}
