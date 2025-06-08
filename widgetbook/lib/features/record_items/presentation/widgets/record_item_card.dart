import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// Note: AppではRecordItemをimportしていますが、widgetbookでは依存関係を避けるため
// テスト用のシンプルなモデルを作成します
class MockRecordItem {
  const MockRecordItem({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.unit,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? unit;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}

// Widgetbook用の簡易版RecordItemCard
class RecordItemCard extends StatelessWidget {
  const RecordItemCard({
    super.key,
    required this.recordItem,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final MockRecordItem recordItem;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recordItem.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (recordItem.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        recordItem.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (recordItem.unit != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recordItem.unit!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      color: theme.colorScheme.primary,
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@UseCase(name: 'Default', type: RecordItemCard)
Widget recordItemCardDefault(BuildContext context) {
  return RecordItemCard(
    recordItem: MockRecordItem(
      id: 'test-id',
      userId: 'test-user-id',
      title: '体重測定',
      description: '毎朝起床後に体重を記録',
      unit: 'kg',
      sortOrder: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    onTap: () {},
    onEdit: () {},
    onDelete: () {},
  );
}

@UseCase(name: 'Without Description', type: RecordItemCard)
Widget recordItemCardWithoutDescription(BuildContext context) {
  return RecordItemCard(
    recordItem: MockRecordItem(
      id: 'test-id-2',
      userId: 'test-user-id',
      title: '読書記録',
      description: null,
      unit: 'ページ',
      sortOrder: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    onTap: () {},
    onEdit: () {},
    onDelete: () {},
  );
}

@UseCase(name: 'Without Unit', type: RecordItemCard)
Widget recordItemCardWithoutUnit(BuildContext context) {
  return RecordItemCard(
    recordItem: MockRecordItem(
      id: 'test-id-3',
      userId: 'test-user-id',
      title: '筋トレ',
      description: '腕立て伏せと腹筋を記録',
      unit: null,
      sortOrder: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    onTap: () {},
    onEdit: () {},
    onDelete: () {},
  );
}

@UseCase(name: 'Minimal', type: RecordItemCard)
Widget recordItemCardMinimal(BuildContext context) {
  return RecordItemCard(
    recordItem: MockRecordItem(
      id: 'test-id-4',
      userId: 'test-user-id',
      title: '散歩',
      description: null,
      unit: null,
      sortOrder: 4,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    onTap: () {},
  );
}
