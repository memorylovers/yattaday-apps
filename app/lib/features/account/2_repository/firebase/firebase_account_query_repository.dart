import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/handling_error.dart';
import '../../1_models/account.dart';
import '../interfaces/account_query_repository.dart';
import 'firebase_account_helper.dart';

/// アカウント情報の参照用リポジトリのFirebase実装
///
/// Firestoreからアカウント情報を取得する
/// 読み取り専用のリポジトリ実装クラス。
class FirebaseAccountQueryRepository implements IAccountQueryRepository {
  final FirebaseFirestore _firestore;

  /// コレクションリファレンスのキャッシュ
  late final CollectionReference<Account> _collection;

  /// コンストラクタ
  ///
  /// [firestore] Firestoreインスタンス（テスト時はモックを注入可能）
  FirebaseAccountQueryRepository(this._firestore) {
    _collection = FirebaseAccountHelper.getTypedCollection(_firestore);
  }

  @override
  Future<Account?> getById(String uid) async {
    try {
      final snapshot = await _collection.doc(uid).get();
      return snapshot.data();
    } catch (error) {
      handleError(error);
      return null; // handleErrorが例外を投げない場合のフォールバック
    }
  }

  @override
  Stream<Account?> watchById(String uid) {
    return _collection
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .handleError((error) {
          handleError(error);
        });
  }

  @override
  Future<bool> exists(String uid) async {
    try {
      final snapshot = await _collection.doc(uid).get();
      return snapshot.exists;
    } catch (error) {
      handleError(error);
      return false; // handleErrorが例外を投げない場合のフォールバック
    }
  }
}
