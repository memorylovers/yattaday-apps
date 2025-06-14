import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../_gen/i18n/strings.g.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(i18n.recordItems.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 検索機能の実装
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(i18n.recordItems.searchNotAvailable)),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5DD3DC),
              const Color(0xFF7EDBB7),
              const Color(0xFFF5D563),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            // color: Colors.white,
            child: recordItemsAsync.when(
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
                        Text(
                          i18n.recordItems.errorMessage,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => ref.refresh(watchRecordItemsProvider),
                          child: Text(i18n.common.retry),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        backgroundColor: const Color(0xFF5DD3DC),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 記録項目詳細画面への遷移（現在はモック実装）
  void _navigateToDetail(BuildContext context, RecordItem item) {
    // TODO: 詳細画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(i18n.recordItems.navigateToDetail(title: item.title)),
      ),
    );
  }

  /// 記録項目編集画面への遷移（現在はモック実装）
  void _navigateToEdit(BuildContext context, RecordItem item) {
    // TODO: 編集画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(i18n.recordItems.navigateToEdit(title: item.title)),
      ),
    );
  }

  /// 記録項目作成画面への遷移（現在はモック実装）
  void _navigateToCreate(BuildContext context) {
    // TODO: 作成画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(i18n.recordItems.navigateToCreate)));
  }

  /// 削除確認ダイアログの表示（現在はモック実装）
  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    RecordItem item,
  ) {
    // TODO: 削除機能の実装後に実際の削除処理を追加
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(i18n.recordItems.deleteConfirm(title: item.title)),
      ),
    );
  }
}
