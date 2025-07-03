import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulid4d/ulid4d.dart';

import '../../../../common/exception/handling_error.dart';
import '../../1_models/record_item.dart';
import '../interfaces/record_item_command_repository.dart';
import 'firebase_record_item_helper.dart';

/// RecordItemCommandRepositoryのFirestore実装
class FirebaseRecordItemCommandRepository
    implements IRecordItemCommandRepository {
  final FirebaseFirestore _firestore;

  FirebaseRecordItemCommandRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<RecordItem> _col(String userId) =>
      FirebaseRecordItemHelper.getTypedCollection(_firestore, userId);

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

  /// 新しいIDを生成（ULIDを使用）
  String generateId() => ULID.randomULID();
}
