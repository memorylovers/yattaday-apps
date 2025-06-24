import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/app_exception.dart';
import '../../../../common/exception/app_error_code.dart';
import '../../../../common/exception/handling_error.dart';
import '../../1_models/account.dart';
import '../interfaces/account_command_repository.dart';
import 'firebase_account_helper.dart';

/// アカウント情報の更新用リポジトリのFirebase実装
///
/// Firestoreへのアカウント情報の作成・更新・削除を行う
/// 書き込み専用のリポジトリ実装クラス。
class FirebaseAccountCommandRepository implements IAccountCommandRepository {
  final FirebaseFirestore _firestore;

  /// コレクションリファレンスのキャッシュ
  late final CollectionReference<Account> _collection;

  /// コンストラクタ
  ///
  /// [firestore] Firestoreインスタンス（テスト時はモックを注入可能）
  FirebaseAccountCommandRepository(this._firestore) {
    _collection = FirebaseAccountHelper.getTypedCollection(_firestore);
  }

  @override
  Future<void> create(String uid) async {
    try {
      // 既存チェック
      final existing = await _collection.doc(uid).get();
      if (existing.exists) {
        throw const AppException(
          code: AppErrorCode.concurrentUpdate,
          message: 'アカウントは既に存在します',
        );
      }

      // アカウント作成
      final now = DateTime.now();
      final account = Account(uid: uid, createdAt: now, updatedAt: now);

      await _collection.doc(uid).set(account);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update(String uid) async {
    try {
      // 存在チェック
      final existing = await _collection.doc(uid).get();
      if (!existing.exists) {
        throw const AppException(
          code: AppErrorCode.notFound,
          message: 'アカウントが見つかりません',
        );
      }

      // 更新データの準備
      final currentData = existing.data()!;
      final updatedAccount = currentData.copyWith(updatedAt: DateTime.now());

      await _collection.doc(uid).set(updatedAccount);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> delete(String uid) async {
    try {
      // 存在チェック
      final existing = await _collection.doc(uid).get();
      if (!existing.exists) {
        throw const AppException(
          code: AppErrorCode.notFound,
          message: 'アカウントが見つかりません',
        );
      }

      await _collection.doc(uid).delete();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<Account> createIfNotExists(String uid) async {
    try {
      // 既存チェック
      final existing = await _collection.doc(uid).get();
      if (existing.exists) {
        // 既に存在する場合はそのまま返す
        return existing.data()!;
      }

      // 存在しない場合は新規作成
      final now = DateTime.now();
      final account = Account(uid: uid, createdAt: now, updatedAt: now);

      await _collection.doc(uid).set(account);

      // 作成したアカウントを返す
      return account;
    } catch (error) {
      handleError(error);
      // handleErrorがエラーを再throwするので、ここには到達しない
      rethrow;
    }
  }
}
