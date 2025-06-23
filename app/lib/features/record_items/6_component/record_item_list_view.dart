import 'package:flutter/material.dart';

import '../../../../_gen/i18n/strings.g.dart';
import '../1_models/record_item.dart';
import 'record_item_card.dart';

/// 記録項目のリストを表示するウィジェット
class RecordItemListView extends StatelessWidget {
  const RecordItemListView({
    super.key,
    required this.items,
    required this.completedItemIds,
    this.onItemTap,
    this.onItemToggleComplete,
  });

  final List<RecordItem> items;
  final Set<String> completedItemIds;
  final void Function(RecordItem item)? onItemTap;
  final void Function(RecordItem item)? onItemToggleComplete;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          i18n.recordItems.empty,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // sortOrder順でソート
    final sortedItems = List<RecordItem>.from(items)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ListView.builder(
      itemCount: sortedItems.length,
      itemBuilder: (context, index) {
        final item = sortedItems[index];
        return RecordItemCard(
          recordItem: item,
          isCompleted: completedItemIds.contains(item.id),
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
          onToggleComplete:
              onItemToggleComplete != null
                  ? () => onItemToggleComplete!(item)
                  : null,
        );
      },
    );
  }
}
