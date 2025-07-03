import 'package:cloud_firestore/cloud_firestore.dart';

import '../../1_models/profile.dart';

/// Firestore用のアカウントプロフィール関連ヘルパークラス
///
/// FirebaseのQuery/CommandRepositoryで共通して使用される
/// Firestore関連の定義を集約
class FirebaseAccountProfileHelper {
  FirebaseAccountProfileHelper._();

  /// Firestoreのコレクションパス
  static const String collectionPath = 'account_profiles';

  /// FirestoreのスナップショットからAccountProfileモデルへの変換
  static AccountProfile fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return AccountProfile.fromJson(snapshot.data() ?? {});
  }

  /// AccountProfileモデルからFirestoreドキュメントへの変換
  static Map<String, dynamic> toFirestore(
    AccountProfile profile,
    SetOptions? options,
  ) {
    return profile.toJson();
  }

  /// 型付きコレクション参照を生成
  static CollectionReference<AccountProfile> getTypedCollection(
    FirebaseFirestore firestore,
  ) {
    return firestore
        .collection(collectionPath)
        .withConverter<AccountProfile>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
