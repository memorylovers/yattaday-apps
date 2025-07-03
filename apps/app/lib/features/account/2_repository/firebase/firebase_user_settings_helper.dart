import 'package:cloud_firestore/cloud_firestore.dart';

import '../../1_models/user_settings.dart';

/// Firestore用のユーザー設定関連ヘルパークラス
///
/// FirebaseのUserSettings repositoryで共通して使用される
/// Firestore関連の定義を集約
class FirebaseUserSettingsHelper {
  FirebaseUserSettingsHelper._();

  /// Firestoreのコレクションパス
  static const String collectionPath = 'user_settings';

  /// FirestoreのスナップショットからUserSettingsモデルへの変換
  static UserSettings fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return UserSettings.fromJson(snapshot.data() ?? {});
  }

  /// UserSettingsモデルからFirestoreドキュメントへの変換
  static Map<String, dynamic> toFirestore(
    UserSettings settings,
    SetOptions? options,
  ) {
    return settings.toJson();
  }

  /// 型付きコレクション参照を生成
  static CollectionReference<UserSettings> getTypedCollection(
    FirebaseFirestore firestore,
  ) {
    return firestore
        .collection(collectionPath)
        .withConverter<UserSettings>(
          fromFirestore: fromFirestore,
          toFirestore: toFirestore,
        );
  }
}
