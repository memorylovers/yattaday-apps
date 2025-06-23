import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../_authentication/3_store/auth_store.dart';
import '../1_models/account.dart';
import '../2_repository/providers.dart';

part 'account_store.g.dart';

/// アカウント情報を管理するStore
///
/// 認証されたユーザーのアカウント情報を管理し、
/// 初回ログイン時の自動作成も担当する。
/// 他のfeatureからはこのStoreを通じてアカウント情報にアクセスする。
@Riverpod(keepAlive: true)
class AccountStore extends _$AccountStore {
  @override
  Future<Account?> build() async {
    // 認証状態を監視
    final authState = await ref.watch(authStoreProvider.future);
    if (authState == null) return null;

    // アカウントが存在しない場合は自動作成
    final account = await _ensureAccountExists(authState.uid);

    // リアルタイム監視を設定
    _setupRealtimeListener(authState.uid);

    return account;
  }

  /// アカウントの存在を確認し、なければ作成する
  ///
  /// 初回ログイン時に自動的に呼び出される。
  /// アカウントが既に存在する場合はそのまま返す。
  ///
  /// [uid] 対象のユーザーID
  ///
  /// 戻り値: 作成または取得したアカウント情報
  Future<Account> _ensureAccountExists(String uid) async {
    final queryRepo = ref.read(accountQueryRepositoryProvider);
    final commandRepo = ref.read(accountCommandRepositoryProvider);

    // 既存確認
    final existing = await queryRepo.getById(uid);
    if (existing != null) {
      return existing;
    }

    // 新規作成
    await commandRepo.create(uid);

    // 作成したアカウントを取得
    final created = await queryRepo.getById(uid);
    if (created == null) {
      throw Exception('アカウントの作成に失敗しました');
    }

    return created;
  }

  /// リアルタイム監視を設定
  ///
  /// Firestoreの変更を監視して、自動的にStateを更新する
  void _setupRealtimeListener(String uid) {
    final queryRepo = ref.read(accountQueryRepositoryProvider);

    queryRepo
        .watchById(uid)
        .listen(
          (account) {
            if (account != null) {
              state = AsyncValue.data(account);
            }
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
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
