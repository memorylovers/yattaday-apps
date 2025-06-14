import 'package:flutter/material.dart';

import '../../domain/record_item.dart';

/// 記録項目詳細画面のヘッダー
class RecordItemDetailHeader extends StatelessWidget {
  const RecordItemDetailHeader({super.key, required this.recordItem});

  final RecordItem recordItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // アイコン
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                recordItem.icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // タイトル
          Text(
            recordItem.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          // 説明（ある場合）
          if (recordItem.description != null &&
              recordItem.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              recordItem.description!,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // 単位（ある場合）
          if (recordItem.unit != null && recordItem.unit!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '単位: ${recordItem.unit}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
