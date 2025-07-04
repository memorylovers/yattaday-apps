import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/exception/app_exception_helpers.dart';
import '../../../common/exception/handling_error.dart';
import '../1_models/profile.dart';

/// プロフィール管理リポジトリ
///
/// プロフィール単体の操作のみを管理
abstract class ProfileRepository {
  /// プロフィール取得
  Future<AccountProfile?> getProfileById(String userId);

  /// プロフィール更新（単体）
  Future<void> updateProfile(AccountProfile profile);

  /// プロフィール監視
  Stream<AccountProfile?> watchProfile(String userId);

  /// 表示名で検索
  Future<List<AccountProfile>> searchByDisplayName(
    String query, {
    int limit = 20,
  });

  /// 複数のUIDからプロフィール情報を一括取得
  Future<List<AccountProfile>> getProfilesByIds(List<String> userIds);

  /// アバター画像をアップロードしてURLを更新
  Future<String> uploadAvatar(String userId, String imagePath);
}

/// Firebase実装
class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;

  // コレクションリファレンスのキャッシュ
  late final CollectionReference<AccountProfile> _profilesRef;

  FirebaseProfileRepository(this._firestore) {
    _profilesRef = _getProfilesCollection();
  }

  @override
  Future<AccountProfile?> getProfileById(String userId) async {
    try {
      final doc = await _profilesRef.doc(userId).get();
      return doc.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<void> updateProfile(AccountProfile profile) async {
    try {
      // プロフィールの存在チェック
      final existing = await _profilesRef.doc(profile.uid).get();
      if (!existing.exists) {
        throw AppExceptions.notFound('プロフィール');
      }

      // 更新日時を設定
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());

      await _profilesRef.doc(profile.uid).set(updatedProfile);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Stream<AccountProfile?> watchProfile(String userId) {
    return _profilesRef
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .handleError((error) => handleError(error));
  }

  @override
  Future<List<AccountProfile>> searchByDisplayName(
    String query, {
    int limit = 20,
  }) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Firestoreの部分一致検索の制限により、前方一致検索を実装
      // 注: より高度な検索機能が必要な場合は、Algoliaなどの検索サービスを検討
      final querySnapshot =
          await _profilesRef
              .where('displayName', isGreaterThanOrEqualTo: query)
              .where('displayName', isLessThan: '$query\uf8ff')
              .limit(limit)
              .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Future<List<AccountProfile>> getProfilesByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      // Firestoreの制限により、10件ずつに分割して取得
      final List<AccountProfile> profiles = [];

      for (int i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();

        final querySnapshot =
            await _profilesRef
                .where(FieldPath.documentId, whereIn: batch)
                .get();

        profiles.addAll(querySnapshot.docs.map((doc) => doc.data()));
      }

      return profiles;
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String imagePath) async {
    try {
      // TODO: Firebase Storageへのアップロード実装
      // 現在は仮実装として固定URLを返す
      // 実際の実装では：
      // 1. Firebase Storageにアップロード
      // 2. URLを取得
      // 3. プロフィールのavatarUrlを更新

      throw AppExceptions.unknown('アバターアップロード機能は未実装です');
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  // Private helper methods

  CollectionReference<AccountProfile> _getProfilesCollection() {
    return _firestore
        .collection('account_profiles')
        .withConverter<AccountProfile>(
          fromFirestore:
              (snapshot, _) => AccountProfile.fromJson(snapshot.data() ?? {}),
          toFirestore: (profile, _) => profile.toJson(),
        );
  }
}
