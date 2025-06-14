import 'package:flutter/material.dart';

import '../../domain/record_item.dart';

class RecordItemCard extends StatelessWidget {
  const RecordItemCard({
    super.key,
    required this.recordItem,
    required this.isCompleted,
    this.onTap,
    this.onToggleComplete,
  });

  final RecordItem recordItem;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 絵文字アイコン
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF87CEEB).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    recordItem.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recordItem.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (recordItem.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        recordItem.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // 完了/未完了ボタン
              IconButton(
                onPressed: onToggleComplete,
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  size: 32,
                  color: isCompleted ? Colors.green : Colors.grey[400],
                ),
                tooltip: isCompleted ? '未完了にする' : '完了にする',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
