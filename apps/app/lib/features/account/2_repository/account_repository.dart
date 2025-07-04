import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/exception/app_exception_helpers.dart';
import '../../../common/exception/handling_error.dart';
import '../1_models/account.dart';
import '../1_models/profile.dart';
import '../1_models/user_settings.dart';

/// アカウント管理リポジトリ
///
/// アカウントが主たるエンティティのため、プロフィールの同時作成もここで管理
abstract class AccountRepository {
  /// アカウントとプロフィールを同時に登録
  /// トランザクション境界: 1つのトランザクションで完結
  Future<void> registerAccount(Account account, AccountProfile profile);

  /// アカウントとプロフィールを同時に更新
  Future<void> updateAccountWithProfile(
    Account account,
    AccountProfile profile,
  );

  /// アカウント取得
  Future<Account?> getAccountById(String uid);

  /// アカウント監視
  Stream<Account?> watchAccount(String uid);

  /// ユーザー設定の更新
  Future<void> updateUserSettings(String userId, UserSettings settings);

  /// アカウントの存在確認
  Future<bool> exists(String uid);

  /// アカウントを削除
  Future<void> deleteAccount(String uid);

  /// アカウントが存在しない場合のみ作成
  /// プロフィールも同時に作成される
  Future<Account> createAccountIfNotExists(
    String uid, {
    String displayName = '',
  });
}

/// Firebase実装
class FirebaseAccountRepository implements AccountRepository {
  final FirebaseFirestore _firestore;

  // コレクションリファレンスのキャッシュ
  late final CollectionReference<Account> _accountsRef;
  late final CollectionReference<AccountProfile> _profilesRef;
  late final CollectionReference<UserSettings> _settingsRef;

  FirebaseAccountRepository(this._firestore) {
    _accountsRef = _getAccountsCollection();
    _profilesRef = _getProfilesCollection();
    _settingsRef = _getSettingsCollection();
  }

  @override
  Future<void> registerAccount(Account account, AccountProfile profile) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // アカウントの存在チェック
        final accountDoc = await transaction.get(_accountsRef.doc(account.uid));
        if (accountDoc.exists) {
          throw AppExceptions.concurrentUpdate('アカウントは既に存在します');
        }

        // トランザクション内で両方のドキュメントを作成
        transaction.set(_accountsRef.doc(account.uid), account);
        transaction.set(_profilesRef.doc(account.uid), profile);

        // ユーザー設定も初期化
        final settings = UserSettings(
          userId: account.uid,
          locale: 'ja',
          notificationsEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        transaction.set(_settingsRef.doc(account.uid), settings);
      });
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<void> updateAccountWithProfile(
    Account account,
    AccountProfile profile,
  ) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // アカウントの存在チェック
        final accountDoc = await transaction.get(_accountsRef.doc(account.uid));
        if (!accountDoc.exists) {
          throw AppExceptions.notFound('アカウント');
        }

        // トランザクション内で両方のドキュメントを更新
        transaction.set(_accountsRef.doc(account.uid), account);
        transaction.set(_profilesRef.doc(account.uid), profile);
      });
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<Account?> getAccountById(String uid) async {
    try {
      final doc = await _accountsRef.doc(uid).get();
      return doc.data();
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Stream<Account?> watchAccount(String uid) {
    return _accountsRef
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .handleError((error) => handleError(error));
  }

  @override
  Future<void> updateUserSettings(String userId, UserSettings settings) async {
    try {
      await _settingsRef.doc(userId).set(settings);
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<bool> exists(String uid) async {
    try {
      final doc = await _accountsRef.doc(uid).get();
      return doc.exists;
    } catch (error) {
      handleError(error);
      return false;
    }
  }

  @override
  Future<void> deleteAccount(String uid) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // アカウントの存在チェック
        final accountDoc = await transaction.get(_accountsRef.doc(uid));
        if (!accountDoc.exists) {
          throw AppExceptions.notFound('アカウント');
        }

        // トランザクション内で関連データを削除
        transaction.delete(_accountsRef.doc(uid));
        transaction.delete(_profilesRef.doc(uid));
        transaction.delete(_settingsRef.doc(uid));
      });
    } catch (error) {
      handleError(error);
    }
  }

  @override
  Future<Account> createAccountIfNotExists(
    String uid, {
    String displayName = '',
  }) async {
    try {
      // 既存チェック
      final existing = await _accountsRef.doc(uid).get();
      if (existing.exists) {
        // 既に存在する場合はそのまま返す
        return existing.data()!;
      }

      // 存在しない場合は新規作成
      final now = DateTime.now();
      final account = Account(uid: uid, createdAt: now, updatedAt: now);
      final profile = AccountProfile(
        uid: uid,
        displayName: displayName,
        avatarUrl: '',
        createdAt: now,
        updatedAt: now,
      );

      // トランザクションで作成
      await registerAccount(account, profile);

      return account;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  // Private helper methods (元のhelperクラスの内容を統合)

  CollectionReference<Account> _getAccountsCollection() {
    return _firestore
        .collection('accounts')
        .withConverter<Account>(
          fromFirestore:
              (snapshot, _) => Account.fromJson(snapshot.data() ?? {}),
          toFirestore: (account, _) => account.toJson(),
        );
  }

  CollectionReference<AccountProfile> _getProfilesCollection() {
    return _firestore
        .collection('account_profiles')
        .withConverter<AccountProfile>(
          fromFirestore:
              (snapshot, _) => AccountProfile.fromJson(snapshot.data() ?? {}),
          toFirestore: (profile, _) => profile.toJson(),
        );
  }

  CollectionReference<UserSettings> _getSettingsCollection() {
    return _firestore
        .collection('user_settings')
        .withConverter<UserSettings>(
          fromFirestore:
              (snapshot, _) => UserSettings.fromJson(snapshot.data() ?? {}),
          toFirestore: (settings, _) => settings.toJson(),
        );
  }
}
