import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/common/providers/firebase_providers.dart';
import 'package:myapp/features/account/1_models/account.dart';
import 'package:myapp/features/account/1_models/profile.dart';
import 'package:myapp/features/account/2_repository/profile_repository.dart';
import 'package:myapp/features/account/3_store/account_store.dart';
import 'package:myapp/features/account/3_store/profile_store.dart';

import '../../../../test_helpers/fixtures/test_data_builders.dart';

/// AccountStore用のフェイク実装
class FakeAccountStoreNotifier extends AccountStore {
  Account? _account;

  void setAccount(Account? account) {
    _account = account;
  }

  @override
  Future<Account?> build() async {
    return _account;
  }
}

void main() {
  group('ProfileStore', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;
    late FakeAccountStoreNotifier fakeAccountStore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      fakeAccountStore = FakeAccountStoreNotifier();

      container = ProviderContainer(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
          accountStoreProvider.overrideWith(() => fakeAccountStore),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('アカウントが存在しない場合はnullを返す', () async {
        fakeAccountStore.setAccount(null);

        final profile = await container.read(profileStoreProvider.future);

        expect(profile, isNull);
      });

      test('アカウントが存在する場合、プロフィールを取得する', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        final profile = createTestAccountProfile(
          uid: uid,
          displayName: 'Test User',
        );

        // アカウントとプロフィールを事前に作成
        fakeAccountStore.setAccount(account);
        await fakeFirestore
            .collection('profiles')
            .doc(uid)
            .set(profile.toJson());

        final result = await container.read(profileStoreProvider.future);

        expect(result, isNotNull);
        expect(result!.uid, equals(uid));
        expect(result.displayName, equals('Test User'));
      });

      test('プロフィールが存在しない場合はnullを返す', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        fakeAccountStore.setAccount(account);

        // プロフィールは作成しない

        final result = await container.read(profileStoreProvider.future);

        expect(result, isNull);
      });
    });

    group('updateProfile', () {
      test('表示名を更新できる', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        final profile = createTestAccountProfile(
          uid: uid,
          displayName: 'Old Name',
        );

        fakeAccountStore.setAccount(account);
        await fakeFirestore
            .collection('profiles')
            .doc(uid)
            .set(profile.toJson());

        final notifier = container.read(profileStoreProvider.notifier);
        // 初期読み込みを待つ
        await container.read(profileStoreProvider.future);

        // 表示名を更新
        await notifier.updateProfile(displayName: 'New Name');

        // Firestoreから更新されたデータを確認
        final doc = await fakeFirestore.collection('profiles').doc(uid).get();
        final updatedData = doc.data() as Map<String, dynamic>;
        expect(updatedData['displayName'], equals('New Name'));
      });

      test('アバターURLを更新できる', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        final profile = createTestAccountProfile(
          uid: uid,
          avatarUrl: 'old-url',
        );

        fakeAccountStore.setAccount(account);
        await fakeFirestore
            .collection('profiles')
            .doc(uid)
            .set(profile.toJson());

        final notifier = container.read(profileStoreProvider.notifier);
        // 初期読み込みを待つ
        await container.read(profileStoreProvider.future);

        // アバターURLを更新
        await notifier.updateProfile(avatarUrl: 'new-url');

        // Firestoreから更新されたデータを確認
        final doc = await fakeFirestore.collection('profiles').doc(uid).get();
        final updatedData = doc.data() as Map<String, dynamic>;
        expect(updatedData['avatarUrl'], equals('new-url'));
      });

      test('プロフィールが存在しない場合は例外をスロー', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        fakeAccountStore.setAccount(account);

        // プロフィールは作成しない

        final notifier = container.read(profileStoreProvider.notifier);
        // 初期読み込みを待つ
        await container.read(profileStoreProvider.future);

        // 更新を試みる
        expect(
          () => notifier.updateProfile(displayName: 'New Name'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('profileRepositoryProvider', () {
      test('FirebaseProfileRepositoryが正しく作成される', () {
        final repository = container.read(profileRepositoryProvider);

        expect(repository, isNotNull);
        expect(repository, isA<FirebaseProfileRepository>());
      });
    });

    group('myAccountProfileProvider', () {
      test('profileStoreProviderの値を返す', () async {
        const uid = 'test-user-id';
        final account = createTestAccount(uid: uid);
        final profile = createTestAccountProfile(uid: uid);

        fakeAccountStore.setAccount(account);
        await fakeFirestore
            .collection('profiles')
            .doc(uid)
            .set(profile.toJson());

        final profileFromStore = await container.read(profileStoreProvider.future);
        final profileFromMyAccount = await container.read(myAccountProfileProvider.future);

        expect(profileFromMyAccount, equals(profileFromStore));
      });
    });

    group('accountProfileProvider', () {
      test('指定したユーザーのプロフィールを取得できる', () async {
        const uid = 'other-user-id';
        final profile = createTestAccountProfile(
          uid: uid,
          displayName: 'Other User',
        );

        await fakeFirestore
            .collection('profiles')
            .doc(uid)
            .set(profile.toJson());

        final result = await container.read(accountProfileProvider(uid).future);

        expect(result, isNotNull);
        expect(result!.uid, equals(uid));
        expect(result.displayName, equals('Other User'));
      });

      test('空のUIDの場合はnullを返す', () async {
        final result = await container.read(accountProfileProvider('').future);

        expect(result, isNull);
      });

      test('存在しないユーザーの場合はnullを返す', () async {
        final result = await container.read(accountProfileProvider('non-existent').future);

        expect(result, isNull);
      });
    });

    group('searchAccountProfilesProvider', () {
      test('表示名で検索できる', () async {
        // テストデータを作成
        final profiles = [
          createTestAccountProfile(uid: '1', displayName: 'Alice Johnson'),
          createTestAccountProfile(uid: '2', displayName: 'Bob Alice'),
          createTestAccountProfile(uid: '3', displayName: 'Charlie Brown'),
        ];

        for (final profile in profiles) {
          await fakeFirestore
              .collection('profiles')
              .doc(profile.uid)
              .set(profile.toJson());
        }

        // "Alice"で検索
        final results = await container.read(
          searchAccountProfilesProvider('Alice').future,
        );

        expect(results.length, equals(2));
        expect(results.map((p) => p.uid), containsAll(['1', '2']));
      });

      test('検索結果の件数を制限できる', () async {
        // 多数のプロフィールを作成
        for (int i = 0; i < 30; i++) {
          final profile = createTestAccountProfile(
            uid: 'user-$i',
            displayName: 'Test User $i',
          );
          await fakeFirestore
              .collection('profiles')
              .doc(profile.uid)
              .set(profile.toJson());
        }

        // デフォルトの制限（20件）
        final defaultResults = await container.read(
          searchAccountProfilesProvider('Test').future,
        );
        expect(defaultResults.length, equals(20));

        // カスタム制限（10件）
        final limitedResults = await container.read(
          searchAccountProfilesProvider('Test', limit: 10).future,
        );
        expect(limitedResults.length, equals(10));
      });

      test('一致するプロフィールがない場合は空のリストを返す', () async {
        final results = await container.read(
          searchAccountProfilesProvider('NonExistent').future,
        );

        expect(results, isEmpty);
      });
    });
  });
}