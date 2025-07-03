import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/exception/app_exception.dart';
import '../../../../common/exception/app_error_code.dart';
import '../../../../common/exception/handling_error.dart';
import '../../1_models/profile.dart';
import '../interfaces/account_profile_command_repository.dart';
import 'firebase_account_profile_helper.dart';

/// アカウントプロフィール情報の更新用リポジトリのFirebase実装
///
/// Firestoreへのプロフィール情報の作成・更新・削除を行う
/// 書き込み専用のリポジトリ実装クラス。
class FirebaseAccountProfileCommandRepository
    implements IAccountProfileCommandRepository {
  final FirebaseFirestore _firestore;

  /// コレクションリファレンスのキャッシュ
  late final CollectionReference<AccountProfile> _collection;

  /// コンストラクタ
  ///
  /// [firestore] Firestoreインスタンス（テスト時はモックを注入可能）
  FirebaseAccountProfileCommandRepository(this._firestore) {
    _collection = FirebaseAccountProfileHelper.getTypedCollection(_firestore);
  }

  @override
  Future<void> create({
    required String uid,
    String displayName = '',
    String? avatarUrl,
  }) async {
    try {
      // 既存チェック
      final existing = await _collection.doc(uid).get();
      if (existing.exists) {
        throw const AppException(
          code: AppErrorCode.concurrentUpdate,
          message: 'プロフィールは既に存在します',
        );
      }

      // プロフィール作成
      final now = DateTime.now();
      final profile = AccountProfile(
        uid: uid,
        displayName: displayName,
        avatarUrl: avatarUrl,
        createdAt: now,
        updatedAt: now,
      );

      await _collection.doc(uid).set(profile);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> update({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      // 存在チェック
      final existing = await _collection.doc(uid).get();
      if (!existing.exists) {
        throw const AppException(
          code: AppErrorCode.notFound,
          message: 'プロフィールが見つかりません',
        );
      }

      // 更新データの準備
      final currentData = existing.data()!;
      final updatedProfile = currentData.copyWith(
        displayName: displayName ?? currentData.displayName,
        avatarUrl: avatarUrl ?? currentData.avatarUrl,
        updatedAt: DateTime.now(),
      );

      await _collection.doc(uid).set(updatedProfile);
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
          message: 'プロフィールが見つかりません',
        );
      }

      // アバター画像の削除はStorageサービス層で実装

      await _collection.doc(uid).delete();
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<String> uploadAvatar(String uid, String imagePath) async {
    // アバターアップロードはService層で実装予定
    // 現在は未実装
    throw UnimplementedError('アバターアップロードは別途Service層で実装予定です');
  }
}
