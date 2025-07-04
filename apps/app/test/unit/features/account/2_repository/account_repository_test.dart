import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/features/account/1_models/account.dart';
import 'package:myapp/features/account/1_models/profile.dart';
import 'package:myapp/features/account/1_models/user_settings.dart';
import 'package:myapp/features/account/2_repository/account_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseAccountRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirebaseAccountRepository(fakeFirestore);
  });

  group('FirebaseAccountRepository', () {
    final testAccount = Account(
      uid: 'test-uid',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final testProfile = AccountProfile(
      uid: 'test-uid',
      displayName: 'Test User',
      avatarUrl: 'https://example.com/avatar.jpg',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('registerAccount', () {
      test('アカウントとプロフィールを同時に登録できる', () async {
        await repository.registerAccount(testAccount, testProfile);

        // アカウントが作成されていることを確認
        final accountDoc = await fakeFirestore
            .collection('accounts')
            .doc('test-uid')
            .get();
        expect(accountDoc.exists, isTrue);
        expect(accountDoc.data(), isNotNull);

        // プロフィールが作成されていることを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        expect(profileDoc.exists, isTrue);
        expect(profileDoc.data(), isNotNull);

        // ユーザー設定が作成されていることを確認
        final settingsDoc = await fakeFirestore
            .collection('user_settings')
            .doc('test-uid')
            .get();
        expect(settingsDoc.exists, isTrue);
        expect(settingsDoc.data(), isNotNull);
      });

      test('既存のアカウントに対して登録するとエラーになる', () async {
        // 先にアカウントを作成
        await repository.registerAccount(testAccount, testProfile);

        // 同じアカウントを再度登録しようとする
        expect(
          () => repository.registerAccount(testAccount, testProfile),
          throwsA(
            isA<AppException>().having(
              (e) => e.code,
              'code',
              AppErrorCode.concurrentUpdate,
            ),
          ),
        );
      });
    });

    group('updateAccountWithProfile', () {
      test('アカウントとプロフィールを同時に更新できる', () async {
        // 先にアカウントを作成
        await repository.registerAccount(testAccount, testProfile);

        // 更新用のデータ
        final updatedAccount = testAccount.copyWith(
          updatedAt: DateTime(2024, 1, 2),
        );
        final updatedProfile = testProfile.copyWith(
          displayName: 'Updated User',
          updatedAt: DateTime(2024, 1, 2),
        );

        await repository.updateAccountWithProfile(
          updatedAccount,
          updatedProfile,
        );

        // アカウントが更新されていることを確認
        final accountDoc = await fakeFirestore
            .collection('accounts')
            .doc('test-uid')
            .get();
        final account = Account.fromJson(accountDoc.data()!);
        expect(account.updatedAt, DateTime(2024, 1, 2));

        // プロフィールが更新されていることを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        final profile = AccountProfile.fromJson(profileDoc.data()!);
        expect(profile.displayName, 'Updated User');
      });

      test('存在しないアカウントを更新するとエラーになる', () async {
        expect(
          () => repository.updateAccountWithProfile(testAccount, testProfile),
          throwsA(
            isA<AppException>().having(
              (e) => e.code,
              'code',
              AppErrorCode.notFound,
            ),
          ),
        );
      });
    });

    group('getAccountById', () {
      test('アカウントIDでアカウントを取得できる', () async {
        await repository.registerAccount(testAccount, testProfile);

        final account = await repository.getAccountById('test-uid');

        expect(account, isNotNull);
        expect(account!.uid, 'test-uid');
        expect(account.createdAt, DateTime(2024, 1, 1));
      });

      test('存在しないアカウントIDの場合はnullを返す', () async {
        final account = await repository.getAccountById('non-existent');

        expect(account, isNull);
      });
    });

    group('watchAccount', () {
      test('アカウントの変更を監視できる', () async {
        await repository.registerAccount(testAccount, testProfile);

        final stream = repository.watchAccount('test-uid');

        expectLater(
          stream,
          emitsInOrder([
            predicate<Account?>((account) {
              expect(account, isNotNull);
              expect(account!.uid, 'test-uid');
              return true;
            }),
            predicate<Account?>((account) {
              expect(account, isNotNull);
              expect(account!.updatedAt, DateTime(2024, 1, 2));
              return true;
            }),
          ]),
        );

        // 少し待ってからアカウントを更新
        await Future.delayed(const Duration(milliseconds: 100));
        await fakeFirestore.collection('accounts').doc('test-uid').set(
              testAccount.copyWith(updatedAt: DateTime(2024, 1, 2)).toJson(),
            );
      });

      test('存在しないアカウントの監視ではnullを返す', () async {
        final stream = repository.watchAccount('non-existent');

        expectLater(
          stream,
          emits(isNull),
        );
      });
    });

    group('updateUserSettings', () {
      test('ユーザー設定を更新できる', () async {
        await repository.registerAccount(testAccount, testProfile);

        final settings = UserSettings(
          userId: 'test-uid',
          locale: 'en',
          notificationsEnabled: false,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 2),
        );

        await repository.updateUserSettings('test-uid', settings);

        final settingsDoc = await fakeFirestore
            .collection('user_settings')
            .doc('test-uid')
            .get();
        final savedSettings = UserSettings.fromJson(settingsDoc.data()!);

        expect(savedSettings.locale, 'en');
        expect(savedSettings.notificationsEnabled, false);
      });
    });

    group('exists', () {
      test('存在するアカウントに対してtrueを返す', () async {
        await repository.registerAccount(testAccount, testProfile);

        final exists = await repository.exists('test-uid');

        expect(exists, isTrue);
      });

      test('存在しないアカウントに対してfalseを返す', () async {
        final exists = await repository.exists('non-existent');

        expect(exists, isFalse);
      });
    });

    group('deleteAccount', () {
      test('アカウントと関連データを削除できる', () async {
        await repository.registerAccount(testAccount, testProfile);

        await repository.deleteAccount('test-uid');

        // アカウントが削除されていることを確認
        final accountDoc = await fakeFirestore
            .collection('accounts')
            .doc('test-uid')
            .get();
        expect(accountDoc.exists, isFalse);

        // プロフィールが削除されていることを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        expect(profileDoc.exists, isFalse);

        // ユーザー設定が削除されていることを確認
        final settingsDoc = await fakeFirestore
            .collection('user_settings')
            .doc('test-uid')
            .get();
        expect(settingsDoc.exists, isFalse);
      });

      test('存在しないアカウントを削除するとエラーになる', () async {
        expect(
          () => repository.deleteAccount('non-existent'),
          throwsA(
            isA<AppException>().having(
              (e) => e.code,
              'code',
              AppErrorCode.notFound,
            ),
          ),
        );
      });
    });

    group('createAccountIfNotExists', () {
      test('アカウントが存在しない場合は新規作成する', () async {
        final account = await repository.createAccountIfNotExists(
          'new-uid',
          displayName: 'New User',
        );

        expect(account.uid, 'new-uid');

        // アカウントが作成されていることを確認
        final accountDoc = await fakeFirestore
            .collection('accounts')
            .doc('new-uid')
            .get();
        expect(accountDoc.exists, isTrue);

        // プロフィールが作成されていることを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('new-uid')
            .get();
        final profile = AccountProfile.fromJson(profileDoc.data()!);
        expect(profile.displayName, 'New User');
      });

      test('アカウントが存在する場合は既存のアカウントを返す', () async {
        // 先にアカウントを作成
        await repository.registerAccount(testAccount, testProfile);

        final account = await repository.createAccountIfNotExists(
          'test-uid',
          displayName: 'Should Not Update',
        );

        expect(account.uid, 'test-uid');
        expect(account.createdAt, DateTime(2024, 1, 1));

        // プロフィールが更新されていないことを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        final profile = AccountProfile.fromJson(profileDoc.data()!);
        expect(profile.displayName, 'Test User'); // 元のまま
      });
    });

    group('トランザクション処理', () {
      test('registerAccountのトランザクションが正しく動作する', () async {
        // トランザクション中にエラーが発生した場合、全ての操作がロールバックされることを確認
        // FakeFirebaseFirestoreではトランザクションのロールバックを完全に再現できないため、
        // ここでは正常系のみテスト
        await repository.registerAccount(testAccount, testProfile);

        // 全てのデータが作成されていることを確認
        final accountExists = await repository.exists('test-uid');
        expect(accountExists, isTrue);

        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        expect(profileDoc.exists, isTrue);

        final settingsDoc = await fakeFirestore
            .collection('user_settings')
            .doc('test-uid')
            .get();
        expect(settingsDoc.exists, isTrue);
      });
    });
  });
}