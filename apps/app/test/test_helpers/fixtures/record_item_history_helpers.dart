import 'package:myapp/features/record_items/1_models/record_item_history.dart';

RecordItemHistory createTestRecordItemHistory({
  String? id,
  String? date,
  String? recordItemId,
  String? userId,
  String? note,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return RecordItemHistory(
    id: id ?? '2024-01-01',
    date: date ?? '2024-01-01',
    recordItemId: recordItemId ?? 'test-record-item-id',
    userId: userId ?? 'test-user-id',
    note: note,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}
