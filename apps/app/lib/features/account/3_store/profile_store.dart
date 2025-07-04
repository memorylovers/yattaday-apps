import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../common/exception/app_exception_helpers.dart';
import '../../../common/providers/firebase_providers.dart';
import '../1_models/profile.dart';
import '../2_repository/profile_repository.dart';
import 'account_store.dart';

part 'profile_store.g.dart';

/// ProfileRepositoryのProvider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirebaseProfileRepository(firestore);
});

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

    // プロフィールを取得（アカウント作成時に自動作成されているはず）
    final profileRepo = ref.read(profileRepositoryProvider);

    try {
      final profile = await profileRepo.getProfileById(account.uid);

      // リアルタイム監視を設定
      _setupRealtimeListener(account.uid);

      return profile;
    } catch (error, stackTrace) {
      throw AsyncValue.error(error, stackTrace).error!;
    }
  }

  /// リアルタイム監視を設定
  ///
  /// Firestoreの変更を監視して、自動的にStateを更新する
  void _setupRealtimeListener(String uid) {
    final profileRepo = ref.read(profileRepositoryProvider);

    profileRepo
        .watchProfile(uid)
        .listen(
          (profile) {
            if (profile != null) {
              state = AsyncValue.data(profile);
            }
          },
          onError: (error, stackTrace) {
            state = AsyncValue.error(error, stackTrace ?? StackTrace.current);
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
    final currentProfile = state.value;
    if (currentProfile == null) {
      throw AppExceptions.notFound('プロフィール');
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 更新対象のフィールドのみ変更
      final updatedProfile = currentProfile.copyWith(
        displayName: displayName ?? currentProfile.displayName,
        avatarUrl: avatarUrl ?? currentProfile.avatarUrl,
      );

      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.updateProfile(updatedProfile);

      // 更新後のプロフィールを返す
      return updatedProfile;
    });
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

  final profileRepo = ref.read(profileRepositoryProvider);

  try {
    return await profileRepo.getProfileById(uid);
  } catch (error) {
    // エラーを再スローしてAsyncValue.guardでハンドリング
    rethrow;
  }
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
  final profileRepo = ref.read(profileRepositoryProvider);

  try {
    return await profileRepo.searchByDisplayName(query, limit: limit);
  } catch (error) {
    // エラーを再スローしてAsyncValue.guardでハンドリング
    rethrow;
  }
}
