import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../_gen/i18n/strings.g.dart';
import '../../../../components/scaffold/gradient_scaffold.dart';
import '../../../../routing/router_routes.dart';
import '../1_models/record_item.dart';
import '../4_view_model/record_items_list_view_model.dart';
import '../5_component/record_item_list_view.dart';

/// 記録項目一覧画面
class RecordItemsListPage extends HookConsumerWidget {
  const RecordItemsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(recordItemsListViewModelProvider);
    final viewModel = ref.read(recordItemsListViewModelProvider.notifier);

    // 日付フォーマット（例：2024年6月14日）
    final dateFormatter = DateFormat('yyyy/MM/dd(E)');

    return GradientScaffold(
      title: dateFormatter.format(viewModelState.selectedDate),
      leading: IconButton(
        iconSize: 36,
        icon: const Icon(Icons.chevron_left),
        onPressed: viewModel.goToPreviousDay,
      ),
      actions: [
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.chevron_right),
          onPressed: viewModel.goToNextDay,
        ),
      ],
      body: viewModelState.recordItemsAsync.when(
        data:
            (items) => RecordItemListView(
              items: items,
              completedItemIds: viewModelState.completedItemIds,
              onItemTap: (item) => _navigateToDetail(context, item),
              onItemToggleComplete:
                  (item) => viewModel.toggleItemComplete(item.id),
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
                    onPressed: viewModel.refresh,
                    child: Text(i18n.common.retry),
                  ),
                ],
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

  /// 記録項目詳細画面への遷移
  void _navigateToDetail(BuildContext context, RecordItem item) {
    RecordItemsDetailPageRoute(id: item.id).push(context);
  }

  /// 記録項目作成画面への遷移（現在はモック実装）
  void _navigateToCreate(BuildContext context) {
    // TODO: 作成画面の実装後に実際のナビゲーションを追加
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(i18n.recordItems.navigateToCreate)));
  }
}
