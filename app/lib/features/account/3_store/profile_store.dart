import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../1_models/profile.dart';
import '../2_repository/providers.dart';
import 'account_store.dart';

part 'profile_store.g.dart';

/// プロフィール情報を管理するStore
///
/// ユーザーの公開プロフィール情報を管理し、
/// アカウント作成時のプロフィール自動作成も担当する。
@Riverpod(keepAlive: true)
class ProfileStore extends _$ProfileStore {
  @override
  Future<AccountProfile?> build() async {
    // アカウント情報を監視
    final account = await ref.watch(accountStoreProvider.future);
    if (account == null) return null;

    // プロフィールが存在しない場合は自動作成
    final profile = await _ensureProfileExists(account.uid);

    // リアルタイム監視を設定
    _setupRealtimeListener(account.uid);

    return profile;
  }

  /// プロフィールの存在を確認し、なければ作成する
  ///
  /// アカウント作成時に自動的に呼び出される。
  /// プロフィールが既に存在する場合はそのまま返す。
  ///
  /// [uid] 対象のユーザーID
  ///
  /// 戻り値: 作成または取得したプロフィール情報
  Future<AccountProfile> _ensureProfileExists(String uid) async {
    final queryRepo = ref.read(accountProfileQueryRepositoryProvider);
    final commandRepo = ref.read(accountProfileCommandRepositoryProvider);

    // 既存確認
    final existing = await queryRepo.getById(uid);
    if (existing != null) {
      return existing;
    }

    // 新規作成
    await commandRepo.create(uid: uid);

    // 作成したプロフィールを取得
    final created = await queryRepo.getById(uid);
    if (created == null) {
      throw Exception('プロフィールの作成に失敗しました');
    }

    return created;
  }

  /// リアルタイム監視を設定
  ///
  /// Firestoreの変更を監視して、自動的にStateを更新する
  void _setupRealtimeListener(String uid) {
    final queryRepo = ref.read(accountProfileQueryRepositoryProvider);

    queryRepo
        .watchById(uid)
        .listen(
          (profile) {
            if (profile != null) {
              state = AsyncValue.data(profile);
            }
          },
          onError: (error) {
            state = AsyncValue.error(error, StackTrace.current);
          },
        );
  }

  /// プロフィールを更新する
  ///
  /// ユーザーがプロフィールを編集した際に呼び出される。
  ///
  /// [displayName] 新しい表示名（nullの場合は更新しない）
  /// [avatarUrl] 新しいアバターURL（nullの場合は更新しない）
  Future<void> updateProfile({String? displayName, String? avatarUrl}) async {
    final account = await ref.read(accountStoreProvider.future);
    if (account == null) {
      throw Exception('アカウントが見つかりません');
    }

    final commandRepo = ref.read(accountProfileCommandRepositoryProvider);
    await commandRepo.update(
      uid: account.uid,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}

/// ログインユーザーのプロフィール情報を取得するProvider
///
/// 他のfeatureから参照する際の主要なエントリポイント
@riverpod
Future<AccountProfile?> myAccountProfile(Ref ref) async {
  return ref.watch(profileStoreProvider.future);
}

/// 特定ユーザーのプロフィール情報を取得するProvider
///
/// 他ユーザーのプロフィールを参照する際に使用
@riverpod
Future<AccountProfile?> accountProfile(Ref ref, String uid) async {
  if (uid.isEmpty) return null;

  final queryRepo = ref.read(accountProfileQueryRepositoryProvider);
  return queryRepo.getById(uid);
}

/// 表示名でユーザーを検索するProvider
///
/// ユーザー検索機能で使用
@riverpod
Future<List<AccountProfile>> searchAccountProfiles(
  Ref ref,
  String query, {
  int limit = 20,
}) async {
  final queryRepo = ref.read(accountProfileQueryRepositoryProvider);
  return queryRepo.searchByDisplayName(query, limit: limit);
}
