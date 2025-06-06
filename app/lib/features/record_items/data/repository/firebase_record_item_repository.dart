import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/handling_error.dart';
import '../../domain/record_item.dart';
import 'record_item_repository.dart';

/// RecordItemRepositoryのFirestore実装
class FirebaseRecordItemRepository implements IRecordItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<RecordItem> _col(String userId) => _firestore
      .collection(RecordItem.collectionPath(userId))
      .withConverter(
        fromFirestore: RecordItem.fromFirestore,
        toFirestore: RecordItem.toFirestore,
      );

  @override
  Future<void> create(RecordItem recordItem) async {
    try {
      final docRef = _col(recordItem.userId).doc(recordItem.id);
      await docRef.set(recordItem, SetOptions(merge: false));
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    try {
      final docRef = _col(recordItem.userId).doc(recordItem.id);

      await docRef.set(recordItem, SetOptions(merge: true));
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    try {
      final docRef = _col(userId).doc(recordItemId);
      await docRef.delete();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    try {
      final docSnapshot = await _col(userId).doc(recordItemId).get();
      if (!docSnapshot.exists) return null;

      return docSnapshot.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    try {
      final querySnapshot = await _col(userId).orderBy('sortOrder').get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    try {
      return _col(userId)
          .orderBy('sortOrder')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (error) {
      handleError(error);
      return Stream.value([]);
    }
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    try {
      final querySnapshot =
          await _col(
            userId,
          ).orderBy('sortOrder', descending: true).limit(1).get();

      if (querySnapshot.docs.isEmpty) return 0;

      final lastItem = querySnapshot.docs.first.data();
      return lastItem.sortOrder + 1;
    } catch (error) {
      handleError(error);
      return 0;
    }
  }

  /// 新しいIDを生成（Firestoreのauto-IDを使用）
  String generateId() => _firestore.collection('temp').doc().id;
}
