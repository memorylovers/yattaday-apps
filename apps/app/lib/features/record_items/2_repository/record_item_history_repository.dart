import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/exception/app_exception_helpers.dart';
import '../../../common/exception/handling_error.dart';
import '../1_models/record_item_history.dart';

/// 記録項目履歴のリポジトリ
abstract class RecordItemHistoryRepository {
  /// 記録を作成
  Future<void> create(RecordItemHistory history);

  /// 記録を更新
  Future<void> update(RecordItemHistory history);

  /// 記録を削除
  Future<void> delete({
    required String userId,
    required String recordItemId,
    required String historyId,
  });

  /// 特定の記録を取得
  Future<RecordItemHistory?> getById({
    required String userId,
    required String recordItemId,
    required String historyId,
  });

  /// 特定の日付の記録を取得
  Future<RecordItemHistory?> getByDate({
    required String userId,
    required String recordItemId,
    required String date,
  });

  /// 指定期間の記録履歴を取得
  Future<List<RecordItemHistory>> getByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 記録履歴をリアルタイム監視
  Stream<List<RecordItemHistory>> watchByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 全ての記録履歴を取得（統計用）
  Future<List<RecordItemHistory>> getAll({
    required String userId,
    required String recordItemId,
  });

  /// 記録が存在する日付のリストを取得
  Future<List<String>> getRecordedDates({
    required String userId,
    required String recordItemId,
  });
}

/// Firebase実装
class FirebaseRecordItemHistoryRepository
    implements RecordItemHistoryRepository {
  final FirebaseFirestore _firestore;

  FirebaseRecordItemHistoryRepository(this._firestore);

  @override
  Future<void> create(RecordItemHistory history) async {
    try {
      final collection = _getTypedCollection(
        history.userId,
        history.recordItemId,
      );

      // 同じ日付の記録が既に存在するか確認
      final existingDoc = await collection.doc(history.date).get();
      if (existingDoc.exists) {
        throw AppExceptions.concurrentUpdate('この日付の記録は既に存在します');
      }

      await collection.doc(history.date).set(history);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update(RecordItemHistory history) async {
    try {
      final collection = _getTypedCollection(
        history.userId,
        history.recordItemId,
      );

      // 存在チェック
      final doc = await collection.doc(history.date).get();
      if (!doc.exists) {
        throw AppExceptions.notFound('記録');
      }

      await collection.doc(history.date).set(history);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> delete({
    required String userId,
    required String recordItemId,
    required String historyId,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);

      // 存在チェック
      final doc = await collection.doc(historyId).get();
      if (!doc.exists) {
        throw AppExceptions.notFound('記録');
      }

      await collection.doc(historyId).delete();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<RecordItemHistory?> getById({
    required String userId,
    required String recordItemId,
    required String historyId,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);
      final doc = await collection.doc(historyId).get();
      return doc.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<RecordItemHistory?> getByDate({
    required String userId,
    required String recordItemId,
    required String date,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);
      final doc = await collection.doc(date).get();
      return doc.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<RecordItemHistory>> getByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);

      // 日付をyyyy-MM-dd形式の文字列に変換
      final startDateStr = _formatDate(startDate);
      final endDateStr = _formatDate(endDate);

      final querySnapshot =
          await collection
              .where('date', isGreaterThanOrEqualTo: startDateStr)
              .where('date', isLessThanOrEqualTo: endDateStr)
              .orderBy('date', descending: true)
              .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Stream<List<RecordItemHistory>> watchByDateRange({
    required String userId,
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    try {
      final collection = _getTypedCollection(userId, recordItemId);

      // 日付をyyyy-MM-dd形式の文字列に変換
      final startDateStr = _formatDate(startDate);
      final endDateStr = _formatDate(endDate);

      return collection
          .where('date', isGreaterThanOrEqualTo: startDateStr)
          .where('date', isLessThanOrEqualTo: endDateStr)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
          .handleError((error) => handleError(error));
    } catch (error) {
      handleError(error);
      return Stream.value([]);
    }
  }

  @override
  Future<List<RecordItemHistory>> getAll({
    required String userId,
    required String recordItemId,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);
      final querySnapshot =
          await collection.orderBy('date', descending: true).get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Future<List<String>> getRecordedDates({
    required String userId,
    required String recordItemId,
  }) async {
    try {
      final collection = _getTypedCollection(userId, recordItemId);
      final querySnapshot = await collection.get();

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  // Private helper methods (元のhelperクラスの内容を統合)

  /// Firestoreのコレクションパス
  String _collectionPath(String userId, String recordItemId) =>
      'users/$userId/recordItems/$recordItemId/histories';

  /// 型付きコレクション参照を生成
  CollectionReference<RecordItemHistory> _getTypedCollection(
    String userId,
    String recordItemId,
  ) {
    return _firestore
        .collection(_collectionPath(userId, recordItemId))
        .withConverter<RecordItemHistory>(
          fromFirestore:
              (snapshot, _) =>
                  RecordItemHistory.fromJson(snapshot.data() ?? {}),
          toFirestore: (history, _) => history.toJson(),
        );
  }

  /// 日付をyyyy-MM-dd形式の文字列に変換
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
