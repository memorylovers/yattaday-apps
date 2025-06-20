import 'package:myapp/features/record_items/1_models/record_item.dart';

/// テスト用のRecordItemを作成するヘルパー関数
RecordItem createTestRecordItem({
  String? id,
  String? userId,
  String? title,
  String? description,
  String? icon,
  String? unit,
  int? sortOrder,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return RecordItem(
    id: id ?? 'test-id-${DateTime.now().millisecondsSinceEpoch}',
    userId: userId ?? 'test-user-id',
    title: title ?? 'テストタイトル',
    description: description,
    icon: icon ?? '📝',
    unit: unit,
    sortOrder: sortOrder ?? 0,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}
