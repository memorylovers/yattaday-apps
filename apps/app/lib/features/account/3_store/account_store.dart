import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../_authentication/3_store/auth_store.dart';
import '../1_models/account.dart';
import '../2_repository/account_repository.dart';

part 'account_store.g.dart';

/// AccountRepositoryのProvider
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return FirebaseAccountRepository(FirebaseFirestore.instance);
});

/// アカウント情報を管理するStore
///
/// 認証されたユーザーのアカウント情報を管理し、
/// 初回ログイン時の自動作成も担当する。
/// 他のfeatureからはこのStoreを通じてアカウント情報にアクセスする。
@Riverpod(keepAlive: true)
class AccountStore extends _$AccountStore {
  StreamSubscription<Account?>? _subscription;
  @override
  Future<Account?> build() async {
    // クリーンアップ処理を設定
    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });

    // 認証状態を監視
    final authState = await ref.watch(authStoreProvider.future);
    if (authState == null) {
      // 既存のサブスクリプションをキャンセル
      _subscription?.cancel();
      _subscription = null;
      return null;
    }

    // アカウントが存在しない場合は自動作成
    final accountRepo = ref.read(accountRepositoryProvider);

    try {
      final account = await accountRepo.createAccountIfNotExists(authState.uid);

      // リアルタイム監視を設定
      _setupRealtimeListener(authState.uid);

      return account;
    } catch (error, stackTrace) {
      throw AsyncValue.error(error, stackTrace).error!;
    }
  }

  /// リアルタイム監視を設定
  ///
  /// Firestoreの変更を監視して、自動的にStateを更新する
  void _setupRealtimeListener(String uid) {
    // 既存のサブスクリプションをキャンセル
    _subscription?.cancel();

    final accountRepo = ref.read(accountRepositoryProvider);

    _subscription = accountRepo
        .watchAccount(uid)
        .listen(
          (account) {
            if (account != null) {
              state = AsyncValue.data(account);
            }
          },
          onError: (error, stackTrace) {
            state = AsyncValue.error(error, stackTrace ?? StackTrace.current);
          },
        );
  }
}

/// ログインユーザーのアカウント情報を取得するProvider
///
/// 他のfeatureから参照する際の主要なエントリポイント
@riverpod
Future<Account?> myAccount(Ref ref) async {
  return ref.watch(accountStoreProvider.future);
}
