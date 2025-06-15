import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../_gen/i18n/strings.g.dart';
import '../../../_authentication/application/auth_providers.dart';
import '../../../daily_records/application/providers/record_item_histories_provider.dart';
import '../../../daily_records/application/providers/record_item_statistics_provider.dart';
import '../../application/providers/record_item_crud_provider.dart';
import '../../application/providers/record_items_provider.dart';
import '../widgets/record_item_calendar.dart';
import '../widgets/record_item_detail_header.dart';
import '../widgets/record_item_statistics_card.dart';

/// 記録項目詳細画面
class RecordItemsDetailPage extends HookConsumerWidget {
  const RecordItemsDetailPage({super.key, required this.recordItemId});

  final String recordItemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 記録項目の詳細を取得
    final recordItemAsync = ref.watch(recordItemByIdProvider(recordItemId));

    // 統計情報を取得
    final statisticsAsync = ref.watch(
      recordItemStatisticsProvider(recordItemId: recordItemId),
    );

    // 選択中の月（カレンダー表示用）
    final selectedMonth = useState(DateTime.now());

    // 今日の記録があるかどうか
    final todayRecordExistsAsync = ref.watch(
      watchTodayRecordExistsProvider(recordItemId: recordItemId),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmDialog(context, ref),
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
          child: recordItemAsync.when(
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
                        child: statisticsAsync.when(
                          data:
                              (statistics) => RecordItemStatisticsCard(
                                statistics: statistics,
                              ),
                          loading:
                              () => const SizedBox(
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ),

                      // カレンダー
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: RecordItemCalendar(
                          recordItemId: recordItemId,
                          selectedMonth: selectedMonth.value,
                          onMonthChanged:
                              (month) => selectedMonth.value = month,
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
                            () => ref.refresh(
                              recordItemByIdProvider(recordItemId),
                            ),
                        child: Text(i18n.common.retry),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
      floatingActionButton: todayRecordExistsAsync.when(
        data:
            (exists) => FloatingActionButton.extended(
              onPressed: () => _toggleTodayRecord(context, ref, exists),
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
      await _deleteRecordItem(context, ref);
    }
  }

  /// 記録項目を削除
  Future<void> _deleteRecordItem(BuildContext context, WidgetRef ref) async {
    try {
      final userId = await ref.read(authUidProvider.future);
      final success = await ref
          .read(recordItemCrudProvider.notifier)
          .deleteRecordItem(userId: userId!, recordItemId: recordItemId);

      if (context.mounted) {
        if (success) {
          // 削除成功したら一覧画面に戻る
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(i18n.recordItems.deleteSuccess)),
          );
        } else {
          // エラーメッセージを表示
          final errorMessage = ref.read(recordItemCrudProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? i18n.recordItems.deleteError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(i18n.recordItems.deleteError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// 今日の記録をトグル
  Future<void> _toggleTodayRecord(
    BuildContext context,
    WidgetRef ref,
    bool exists,
  ) async {
    try {
      if (exists) {
        // 削除
        final userId = await ref.read(authUidProvider.future);
        await ref
            .read(deleteRecordItemHistoryUseCaseProvider)
            .executeByDate(
              userId: userId!,
              recordItemId: recordItemId,
              date: DateTime.now(),
            );
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('記録を削除しました')));
        }
      } else {
        // 作成
        final userId = await ref.read(authUidProvider.future);
        await ref
            .read(createRecordItemHistoryUseCaseProvider)
            .execute(
              userId: userId!,
              recordItemId: recordItemId,
              date: DateTime.now(),
            );
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('記録を追加しました')));
        }
      }

      // プロバイダーをリフレッシュ
      ref.invalidate(recordItemStatisticsProvider(recordItemId: recordItemId));
      ref.invalidate(recordedDatesProvider(recordItemId: recordItemId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
      }
    }
  }
}
