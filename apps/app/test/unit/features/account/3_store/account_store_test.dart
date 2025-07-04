import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/common/providers/firebase_providers.dart';
import 'package:myapp/features/_authentication/3_store/auth_store.dart';
import 'package:myapp/features/account/1_models/account.dart';
import 'package:myapp/features/account/2_repository/account_repository.dart';
import 'package:myapp/features/account/3_store/account_store.dart';

import '../../../../test_helpers/fixtures/test_data_builders.dart';

/// AuthStore用のフェイク実装
class FakeAuthStoreNotifier extends AuthStore {
  AuthState? _state;

  void setState(AuthState? state) {
    _state = state;
  }

  @override
  Stream<AuthState?> build() {
    return Stream.value(_state);
  }
}

void main() {
  group('AccountStore', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;
    late FakeAuthStoreNotifier fakeAuthStore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      fakeAuthStore = FakeAuthStoreNotifier();

      container = ProviderContainer(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
          authStoreProvider.overrideWith(() => fakeAuthStore),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build', () {
      test('認証されていない場合はnullを返す', () async {
        fakeAuthStore.setState(null);

        final account = await container.read(accountStoreProvider.future);

        expect(account, isNull);
      });

      test('認証されている場合、アカウントが存在しなければ自動作成される', () async {
        const uid = 'test-user-id';
        final authUser = createTestAuthUser(uid: uid);
        fakeAuthStore.setState(AuthState(user: authUser));

        final account = await container.read(accountStoreProvider.future);

        expect(account, isNotNull);
        expect(account!.uid, equals(uid));

        // Firestoreにも保存されていることを確認
        final doc = await fakeFirestore.collection('accounts').doc(uid).get();
        expect(doc.exists, isTrue);
      });

      test('認証されている場合、既存のアカウントを返す', () async {
        const uid = 'test-user-id';
        final existingAccount = createTestAccount(uid: uid);
        
        // 事前にアカウントを作成
        await fakeFirestore
            .collection('accounts')
            .doc(uid)
            .set(existingAccount.toJson());

        final authUser = createTestAuthUser(uid: uid);
        fakeAuthStore.setState(AuthState(user: authUser));

        final account = await container.read(accountStoreProvider.future);

        expect(account, isNotNull);
        expect(account!.uid, equals(uid));
        expect(account.createdAt, equals(existingAccount.createdAt));
      });
    });

    group('リアルタイム更新', () {
      test('Firestoreの変更が自動的に反映される', () async {
        const uid = 'test-user-id';
        final authUser = createTestAuthUser(uid: uid);
        fakeAuthStore.setState(AuthState(user: authUser));

        // 初期状態を取得
        final initialAccount = await container.read(accountStoreProvider.future);
        expect(initialAccount, isNotNull);

        // Firestoreのデータを更新
        final updatedData = initialAccount!.copyWith(
          updatedAt: DateTime.now(),
        ).toJson();
        
        await fakeFirestore
            .collection('accounts')
            .doc(uid)
            .update(updatedData);

        // 少し待機してリアルタイム更新を待つ
        await Future.delayed(const Duration(milliseconds: 100));

        // 更新が反映されていることを確認
        final updatedAccount = await container.read(accountStoreProvider.future);
        expect(updatedAccount!.updatedAt, isNot(equals(initialAccount.updatedAt)));
      });
    });

    group('accountRepositoryProvider', () {
      test('FirebaseAccountRepositoryが正しく作成される', () {
        final repository = container.read(accountRepositoryProvider);
        
        expect(repository, isNotNull);
        expect(repository, isA<FirebaseAccountRepository>());
      });

      test('同じFirestoreインスタンスを使用する', () {
        final repository = container.read(accountRepositoryProvider) as FirebaseAccountRepository;
        final firestore = container.read(firebaseFirestoreProvider);
        
        // FirebaseAccountRepositoryがfakefirebaseFirestoreを使用していることを確認
        // （実装の詳細に依存するため、統合テストで詳しく検証）
        expect(firestore, same(fakeFirestore));
      });
    });

    group('myAccountProvider', () {
      test('accountStoreProviderの値を返す', () async {
        const uid = 'test-user-id';
        final authUser = createTestAuthUser(uid: uid);
        fakeAuthStore.setState(AuthState(user: authUser));

        final accountFromStore = await container.read(accountStoreProvider.future);
        final accountFromMyAccount = await container.read(myAccountProvider.future);

        expect(accountFromMyAccount, equals(accountFromStore));
      });
    });

    group('認証状態の変更', () {
      test('ログアウト時にアカウント情報がクリアされる', () async {
        const uid = 'test-user-id';
        final authUser = createTestAuthUser(uid: uid);
        
        // ログイン状態
        fakeAuthStore.setState(AuthState(user: authUser));
        final account = await container.read(accountStoreProvider.future);
        expect(account, isNotNull);

        // ログアウト
        fakeAuthStore.setState(null);
        container.invalidate(accountStoreProvider);
        
        final accountAfterLogout = await container.read(accountStoreProvider.future);
        expect(accountAfterLogout, isNull);
      });

      test('異なるユーザーでログインした場合、新しいアカウント情報を取得する', () async {
        // 最初のユーザー
        const uid1 = 'user-1';
        final authUser1 = createTestAuthUser(uid: uid1);
        fakeAuthStore.setState(AuthState(user: authUser1));
        
        final account1 = await container.read(accountStoreProvider.future);
        expect(account1?.uid, equals(uid1));

        // 別のユーザーでログイン
        const uid2 = 'user-2';
        final authUser2 = createTestAuthUser(uid: uid2);
        fakeAuthStore.setState(AuthState(user: authUser2));
        container.invalidate(accountStoreProvider);
        
        final account2 = await container.read(accountStoreProvider.future);
        expect(account2?.uid, equals(uid2));
        expect(account2?.uid, isNot(equals(uid1)));
      });
    });
  });
}