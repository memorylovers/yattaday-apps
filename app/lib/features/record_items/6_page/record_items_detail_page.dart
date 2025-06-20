import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../_gen/i18n/strings.g.dart';
import '../../../../components/scaffold/gradient_scaffold.dart';
import '../4_view_model/record_item_detail_view_model.dart';
import '../5_component/record_item_calendar.dart';
import '../5_component/record_item_detail_header.dart';
import '../5_component/record_item_statistics_card.dart';

/// 記録項目詳細画面
class RecordItemsDetailPage extends HookConsumerWidget {
  const RecordItemsDetailPage({super.key, required this.recordItemId});

  final String recordItemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelState = ref.watch(
      recordItemDetailViewModelProvider(recordItemId),
    );
    final viewModel = ref.read(
      recordItemDetailViewModelProvider(recordItemId).notifier,
    );

    return GradientScaffold(
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _navigateToEdit(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _showDeleteConfirmDialog(context, ref, viewModel),
        ),
      ],
      body: viewModelState.recordItem.when(
        data: (recordItem) {
          if (recordItem == null) {
            return Center(child: Text(i18n.recordItems.notFound));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120), // FABのためのスペース
              child: Column(
                children: [
                  // ヘッダー部分
                  RecordItemDetailHeader(recordItem: recordItem),

                  // 統計情報
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: viewModelState.statistics.when(
                      data:
                          (statistics) =>
                              RecordItemStatisticsCard(statistics: statistics),
                      loading:
                          () => const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),

                  // カレンダー
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: viewModelState.recordedDates.when(
                      data:
                          (recordedDates) => RecordItemCalendar(
                            recordedDates: recordedDates,
                            selectedMonth: viewModelState.selectedMonth,
                            onMonthChanged: viewModel.setSelectedMonth,
                          ),
                      loading:
                          () => RecordItemCalendar(
                            recordedDates: const [],
                            selectedMonth: viewModelState.selectedMonth,
                            onMonthChanged: viewModel.setSelectedMonth,
                            isLoading: true,
                          ),
                      error:
                          (error, _) => RecordItemCalendar(
                            recordedDates: const [],
                            selectedMonth: viewModelState.selectedMonth,
                            onMonthChanged: viewModel.setSelectedMonth,
                            error: error.toString(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
                        () => ref.invalidate(
                          recordItemDetailViewModelProvider(recordItemId),
                        ),
                    child: Text(i18n.common.retry),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: viewModelState.todayRecordExists.when(
        data:
            (exists) => FloatingActionButton.extended(
              onPressed: () async {
                await viewModel.toggleTodayRecord(exists);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(exists ? '記録を削除しました' : '記録を追加しました')),
                  );
                }
              },
              backgroundColor: exists ? Colors.red : const Color(0xFF5DD3DC),
              icon: Icon(
                exists ? Icons.check_circle : Icons.add_circle,
                color: Colors.white,
              ),
              label: Text(
                exists ? '今日の記録を削除' : '今日の記録を追加',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  /// 編集画面への遷移
  void _navigateToEdit(BuildContext context) {
    // TODO: 編集画面への遷移を実装
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('編集画面への遷移は未実装です')));
  }

  /// 削除確認ダイアログを表示
  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    RecordItemDetailViewModel viewModel,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(i18n.recordItems.deleteTitle),
            content: Text(i18n.recordItems.deleteConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(i18n.common.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(i18n.common.delete),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      await viewModel.deleteRecordItem();

      if (context.mounted) {
        final deleteError =
            ref
                .read(recordItemDetailViewModelProvider(recordItemId))
                .deleteError;

        if (deleteError == null) {
          // 削除成功したら一覧画面に戻る
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(i18n.recordItems.deleteSuccess)),
          );
        } else {
          // エラーメッセージを表示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(deleteError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
