import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/exception/app_error_code.dart';
import '../../../common/exception/app_exception.dart';
import '../../../common/exception/handling_error.dart';
import '../1_models/record_item.dart';

/// 記録項目関連のリポジトリ
abstract class RecordItemRepository {
  /// 記録項目を作成
  Future<void> create(RecordItem recordItem);

  /// 記録項目を更新
  Future<void> update(RecordItem recordItem);

  /// 記録項目を削除
  Future<void> delete(String userId, String recordItemId);

  /// 特定の記録項目を取得
  Future<RecordItem?> getById(String userId, String recordItemId);

  /// ユーザーの記録項目一覧を取得（sortOrder順）
  Future<List<RecordItem>> getByUserId(String userId);

  /// ユーザーの記録項目一覧をリアルタイム監視
  Stream<List<RecordItem>> watchByUserId(String userId);

  /// 次の表示順序を取得
  Future<int> getNextSortOrder(String userId);
}

/// Firebase実装
class FirebaseRecordItemRepository implements RecordItemRepository {
  final FirebaseFirestore _firestore;

  FirebaseRecordItemRepository(this._firestore);

  @override
  Future<void> create(RecordItem recordItem) async {
    try {
      final collection = _getTypedCollection(recordItem.userId);
      
      // IDが既に設定されている場合は指定のIDで作成
      if (recordItem.id.isNotEmpty) {
        await collection.doc(recordItem.id).set(recordItem);
      } else {
        // IDが未設定の場合は自動生成
        await collection.add(recordItem);
      }
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    try {
      final collection = _getTypedCollection(recordItem.userId);
      
      // 存在チェック
      final doc = await collection.doc(recordItem.id).get();
      if (!doc.exists) {
        throw const AppException(
          code: AppErrorCode.notFound,
          message: '記録項目が見つかりません',
        );
      }
      
      await collection.doc(recordItem.id).set(recordItem);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    try {
      final collection = _getTypedCollection(userId);
      
      // 存在チェック
      final doc = await collection.doc(recordItemId).get();
      if (!doc.exists) {
        throw const AppException(
          code: AppErrorCode.notFound,
          message: '記録項目が見つかりません',
        );
      }
      
      await collection.doc(recordItemId).delete();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    try {
      final collection = _getTypedCollection(userId);
      final doc = await collection.doc(recordItemId).get();
      return doc.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    try {
      final collection = _getTypedCollection(userId);
      final querySnapshot = await collection
          .orderBy('sortOrder')
          .get();
      
      return querySnapshot.docs
          .map((doc) => doc.data())
          .toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    try {
      final collection = _getTypedCollection(userId);
      return collection
          .orderBy('sortOrder')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data())
              .toList())
          .handleError((error) => handleError(error));
    } catch (error) {
      handleError(error);
      return Stream.value([]);
    }
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    try {
      final collection = _getTypedCollection(userId);
      final querySnapshot = await collection
          .orderBy('sortOrder', descending: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return 0;
      }
      
      final lastItem = querySnapshot.docs.first.data();
      return lastItem.sortOrder + 1;
    } catch (error) {
      handleError(error);
      return 0;
    }
  }

  // Private helper methods (元のhelperクラスの内容を統合)

  /// Firestoreのコレクションパス
  String _collectionPath(String userId) => 'users/$userId/recordItems';

  /// 型付きコレクション参照を生成
  CollectionReference<RecordItem> _getTypedCollection(String userId) {
    return _firestore
        .collection(_collectionPath(userId))
        .withConverter<RecordItem>(
          fromFirestore: (snapshot, _) => 
              RecordItem.fromJson(snapshot.data() ?? {}),
          toFirestore: (recordItem, _) => recordItem.toJson(),
        );
  }
}