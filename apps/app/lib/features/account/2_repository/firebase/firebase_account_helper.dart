import 'package:cloud_firestore/cloud_firestore.dart';

import '../../1_models/account.dart';

/// Firestore用のアカウント関連ヘルパークラス
///
/// FirebaseのQuery/CommandRepositoryで共通して使用される
/// Firestore関連の定義を集約
class FirebaseAccountHelper {
  FirebaseAccountHelper._();

  /// Firestoreのコレクションパス
  static const String collectionPath = 'accounts';

  /// FirestoreのスナップショットからAccountモデルへの変換
  static Account fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return Account.fromJson(snapshot.data() ?? {});
  }

  /// AccountモデルからFirestoreドキュメントへの変換
  static Map<String, dynamic> toFirestore(
    Account account,
    SetOptions? options,
  ) {
    return account.toJson();
  }

  /// 型付きコレクション参照を生成
  static CollectionReference<Account> getTypedCollection(
    FirebaseFirestore firestore,
  ) {
    return firestore
        .collection(collectionPath)
        .withConverter<Account>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
