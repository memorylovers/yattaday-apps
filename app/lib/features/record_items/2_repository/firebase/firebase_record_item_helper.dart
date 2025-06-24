import 'package:cloud_firestore/cloud_firestore.dart';

import '../../1_models/record_item.dart';

/// Firestore用の記録項目関連ヘルパークラス
///
/// FirebaseのQuery/CommandRepositoryで共通して使用される
/// Firestore関連の定義を集約
class FirebaseRecordItemHelper {
  FirebaseRecordItemHelper._();

  /// Firestoreのコレクションパス
  static String collectionPath(String userId) => 'users/$userId/recordItems';

  /// FirestoreのスナップショットからRecordItemモデルへの変換
  static RecordItem fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return RecordItem.fromJson(snapshot.data() ?? {});
  }

  /// RecordItemモデルからFirestoreドキュメントへの変換
  static Map<String, dynamic> toFirestore(
    RecordItem recordItem,
    SetOptions? options,
  ) {
    return recordItem.toJson();
  }

  /// 型付きコレクション参照を生成
  static CollectionReference<RecordItem> getTypedCollection(
    FirebaseFirestore firestore,
    String userId,
  ) {
    return firestore
        .collection(collectionPath(userId))
        .withConverter<RecordItem>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
