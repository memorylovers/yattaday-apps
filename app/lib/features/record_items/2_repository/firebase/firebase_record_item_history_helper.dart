import 'package:cloud_firestore/cloud_firestore.dart';

import '../../1_models/record_item_history.dart';

/// Firestore用の記録項目履歴関連ヘルパークラス
///
/// FirebaseのRecordItemHistoryRepositoryで使用される
/// Firestore関連の定義を集約
class FirebaseRecordItemHistoryHelper {
  FirebaseRecordItemHistoryHelper._();

  /// Firestoreのコレクションパス
  static String collectionPath(String userId, String recordItemId) =>
      'users/$userId/recordItems/$recordItemId/histories';

  /// FirestoreのスナップショットからRecordItemHistoryモデルへの変換
  static RecordItemHistory fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return RecordItemHistory.fromJson(snapshot.data() ?? {});
  }

  /// RecordItemHistoryモデルからFirestoreドキュメントへの変換
  static Map<String, dynamic> toFirestore(
    RecordItemHistory history,
    SetOptions? options,
  ) {
    return history.toJson();
  }

  /// 型付きコレクション参照を生成
  static CollectionReference<RecordItemHistory> getTypedCollection(
    FirebaseFirestore firestore,
    String userId,
    String recordItemId,
  ) {
    return firestore
        .collection(collectionPath(userId, recordItemId))
        .withConverter<RecordItemHistory>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
