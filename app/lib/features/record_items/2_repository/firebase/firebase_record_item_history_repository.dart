import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulid4d/ulid4d.dart';

import '../../1_models/record_item_history.dart';
import '../interfaces/record_item_history_repository.dart';
import 'firebase_record_item_history_helper.dart';

/// Firebase実装の記録項目履歴リポジトリ
class FirebaseRecordItemHistoryRepository
    implements IRecordItemHistoryRepository {
  final FirebaseFirestore _firestore;

  const FirebaseRecordItemHistoryRepository(this._firestore);

  /// CollectionReferenceを取得
  CollectionReference<RecordItemHistory> _collection(
    String userId,
    String recordItemId,
  ) {
    return FirebaseRecordItemHistoryHelper.getTypedCollection(
      _firestore,
      userId,
      recordItemId,
    );
  }

  /// 新しいIDを生成
  String generateId() => ULID.randomULID();

  @override
  Future<void> create(RecordItemHistory history) async {
    await _collection(
      history.userId,
      history.recordItemId,
    ).doc(history.id).set(history);
  }

  @override
  Future<void> update(RecordItemHistory history) async {
    await _collection(
      history.userId,
      history.recordItemId,
    ).doc(history.id).update(history.toJson());
  }

  @override
  Future<void> delete({
    required String userId,
    required String recordItemId,
    required String historyId,
  }) async {
    await _collection(userId, recordItemId).doc(historyId).delete();
  }

  @override
  Future<RecordItemHistory?> getById({
    required String userId,
    required String recordItemId,
    required String historyId,
  }) async {
    final doc = await _collection(userId, recordItemId).doc(historyId).get();
    return doc.data();
  }

  @override
  Future<RecordItemHistory?> getByDate({
    required String userId,
    required String recordItemId,
    required String date,
  }) async {
    final snapshot =
        await _collection(
          userId,
          recordItemId,
        ).where('date', isEqualTo: date).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }

  @override
  Future<List<RecordItemHistory>> getByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);

    final snapshot =
        await _collection(userId, recordItemId)
            .where('date', isGreaterThanOrEqualTo: startDateStr)
            .where('date', isLessThanOrEqualTo: endDateStr)
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Stream<List<RecordItemHistory>> watchByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final startDateStr = _formatDate(startDate);
    final endDateStr = _formatDate(endDate);

    return _collection(userId, recordItemId)
        .where('date', isGreaterThanOrEqualTo: startDateStr)
        .where('date', isLessThanOrEqualTo: endDateStr)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<List<RecordItemHistory>> getAll({
    required String userId,
    required String recordItemId,
  }) async {
    final snapshot =
        await _collection(
          userId,
          recordItemId,
        ).orderBy('date', descending: true).get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<String>> getRecordedDates({
    required String userId,
    required String recordItemId,
  }) async {
    final snapshot =
        await _collection(
          userId,
          recordItemId,
        ).orderBy('date', descending: true).get();

    return snapshot.docs.map((doc) => doc.data().date).toList();
  }

  /// DateTimeをyyyy-MM-dd形式の文字列に変換
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
