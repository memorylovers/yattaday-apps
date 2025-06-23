import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/handling_error.dart';
import '../1_models/record_item.dart';
import 'record_item_query_repository.dart';

/// RecordItemQueryRepositoryのFirestore実装
class FirebaseRecordItemQueryRepository implements IRecordItemQueryRepository {
  final FirebaseFirestore _firestore;

  FirebaseRecordItemQueryRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<RecordItem> _col(String userId) => _firestore
      .collection(RecordItem.collectionPath(userId))
      .withConverter(
        fromFirestore: RecordItem.fromFirestore,
        toFirestore: RecordItem.toFirestore,
      );

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
}
