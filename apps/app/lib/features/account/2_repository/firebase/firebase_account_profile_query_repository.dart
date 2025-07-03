import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/handling_error.dart';
import '../../1_models/profile.dart';
import '../interfaces/account_profile_query_repository.dart';
import 'firebase_account_profile_helper.dart';

/// アカウントプロフィール情報の参照用リポジトリのFirebase実装
///
/// Firestoreからプロフィール情報を取得する
/// 読み取り専用のリポジトリ実装クラス。
class FirebaseAccountProfileQueryRepository
    implements IAccountProfileQueryRepository {
  final FirebaseFirestore _firestore;

  /// コレクションリファレンスのキャッシュ
  late final CollectionReference<AccountProfile> _collection;

  /// コンストラクタ
  ///
  /// [firestore] Firestoreインスタンス（テスト時はモックを注入可能）
  FirebaseAccountProfileQueryRepository(this._firestore) {
    _collection = FirebaseAccountProfileHelper.getTypedCollection(_firestore);
  }

  @override
  Future<AccountProfile?> getById(String uid) async {
    try {
      final snapshot = await _collection.doc(uid).get();
      return snapshot.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Stream<AccountProfile?> watchById(String uid) {
    return _collection
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .handleError((error) {
          handleError(error);
        });
  }

  @override
  Future<List<AccountProfile>> searchByDisplayName(
    String query, {
    int limit = 20,
  }) async {
    try {
      // Firestoreの制約により、部分一致検索は制限がある
      // ここでは前方一致検索を実装
      final lowerQuery = query.toLowerCase();

      final snapshot =
          await _collection
              .where('displayName', isGreaterThanOrEqualTo: query)
              .where('displayName', isLessThan: '${query}z')
              .limit(limit)
              .get();

      return snapshot.docs
          .map((doc) => doc.data())
          .where(
            (profile) => profile.displayName.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (error) {
      handleError(error);
      return [];
    }
  }

  @override
  Future<List<AccountProfile>> getByIds(List<String> uids) async {
    try {
      if (uids.isEmpty) {
        return [];
      }

      // Firestoreのin演算子は最大10件までの制限がある
      final results = <AccountProfile>[];

      // 10件ずつに分割して取得
      for (var i = 0; i < uids.length; i += 10) {
        final batch = uids.skip(i).take(10).toList();
        final snapshot =
            await _collection.where(FieldPath.documentId, whereIn: batch).get();

        results.addAll(snapshot.docs.map((doc) => doc.data()));
      }

      return results;
    } catch (error) {
      handleError(error);
      return [];
    }
  }
}
