import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/features/account/1_models/profile.dart';
import 'package:myapp/features/account/2_repository/profile_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseProfileRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirebaseProfileRepository(fakeFirestore);
  });

  group('FirebaseProfileRepository', () {
    final testProfile = AccountProfile(
      uid: 'test-uid',
      displayName: 'Test User',
      avatarUrl: 'https://example.com/avatar.jpg',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    // テスト用のプロフィールを事前に作成するヘルパー関数
    Future<void> createTestProfile(AccountProfile profile) async {
      await fakeFirestore
          .collection('account_profiles')
          .doc(profile.uid)
          .set(profile.toJson());
    }

    group('getProfileById', () {
      test('プロフィールIDでプロフィールを取得できる', () async {
        await createTestProfile(testProfile);

        final profile = await repository.getProfileById('test-uid');

        expect(profile, isNotNull);
        expect(profile!.uid, 'test-uid');
        expect(profile.displayName, 'Test User');
        expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
      });

      test('存在しないプロフィールIDの場合はnullを返す', () async {
        final profile = await repository.getProfileById('non-existent');

        expect(profile, isNull);
      });
    });

    group('updateProfile', () {
      test('プロフィールを更新できる', () async {
        await createTestProfile(testProfile);

        final updatedProfile = testProfile.copyWith(
          displayName: 'Updated User',
          avatarUrl: 'https://example.com/new-avatar.jpg',
        );

        await repository.updateProfile(updatedProfile);

        // プロフィールが更新されていることを確認
        final profileDoc = await fakeFirestore
            .collection('account_profiles')
            .doc('test-uid')
            .get();
        final profile = AccountProfile.fromJson(profileDoc.data()!);

        expect(profile.displayName, 'Updated User');
        expect(profile.avatarUrl, 'https://example.com/new-avatar.jpg');
        // 更新日時が自動的に設定されることを確認
        expect(profile.updatedAt.isAfter(DateTime(2024, 1, 1)), isTrue);
      });

      test('存在しないプロフィールを更新するとエラーになる', () async {
        expect(
          () => repository.updateProfile(testProfile),
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

    group('watchProfile', () {
      test('プロフィールの変更を監視できる', () async {
        await createTestProfile(testProfile);

        final stream = repository.watchProfile('test-uid');

        expectLater(
          stream,
          emitsInOrder([
            predicate<AccountProfile?>((profile) {
              expect(profile, isNotNull);
              expect(profile!.uid, 'test-uid');
              expect(profile.displayName, 'Test User');
              return true;
            }),
            predicate<AccountProfile?>((profile) {
              expect(profile, isNotNull);
              expect(profile!.displayName, 'Updated User');
              return true;
            }),
          ]),
        );

        // 少し待ってからプロフィールを更新
        await Future.delayed(const Duration(milliseconds: 100));
        await fakeFirestore.collection('account_profiles').doc('test-uid').set(
              testProfile.copyWith(displayName: 'Updated User').toJson(),
            );
      });

      test('存在しないプロフィールの監視ではnullを返す', () async {
        final stream = repository.watchProfile('non-existent');

        expectLater(
          stream,
          emits(isNull),
        );
      });
    });

    group('searchByDisplayName', () {
      test('表示名で検索できる', () async {
        // 複数のプロフィールを作成
        final profiles = [
          testProfile.copyWith(uid: 'user1', displayName: 'Alice'),
          testProfile.copyWith(uid: 'user2', displayName: 'Bob'),
          testProfile.copyWith(uid: 'user3', displayName: 'Alice Smith'),
          testProfile.copyWith(uid: 'user4', displayName: 'Charlie'),
        ];

        for (final profile in profiles) {
          await createTestProfile(profile);
        }

        // "Alice"で検索
        final results = await repository.searchByDisplayName('Alice');

        expect(results.length, 2);
        expect(results.map((p) => p.displayName).toList(),
            containsAll(['Alice', 'Alice Smith']));
      });

      test('空のクエリでは空のリストを返す', () async {
        final results = await repository.searchByDisplayName('');

        expect(results, isEmpty);
      });

      test('マッチするプロフィールがない場合は空のリストを返す', () async {
        await createTestProfile(testProfile);

        final results = await repository.searchByDisplayName('NonExistent');

        expect(results, isEmpty);
      });

      test('制限数を指定できる', () async {
        // 多数のプロフィールを作成
        for (int i = 0; i < 30; i++) {
          await createTestProfile(
            testProfile.copyWith(
              uid: 'user$i',
              displayName: 'User$i',
            ),
          );
        }

        final results = await repository.searchByDisplayName('User', limit: 10);

        expect(results.length, 10);
      });
    });

    group('getProfilesByIds', () {
      test('複数のIDからプロフィールを一括取得できる', () async {
        // 複数のプロフィールを作成
        final profiles = [
          testProfile.copyWith(uid: 'user1', displayName: 'User 1'),
          testProfile.copyWith(uid: 'user2', displayName: 'User 2'),
          testProfile.copyWith(uid: 'user3', displayName: 'User 3'),
        ];

        for (final profile in profiles) {
          await createTestProfile(profile);
        }

        final results = await repository.getProfilesByIds([
          'user1',
          'user2',
          'user3',
        ]);

        expect(results.length, 3);
        expect(
          results.map((p) => p.uid).toSet(),
          {'user1', 'user2', 'user3'},
        );
      });

      test('存在しないIDは結果に含まれない', () async {
        await createTestProfile(testProfile);

        final results = await repository.getProfilesByIds([
          'test-uid',
          'non-existent1',
          'non-existent2',
        ]);

        expect(results.length, 1);
        expect(results.first.uid, 'test-uid');
      });

      test('空のリストを渡すと空のリストを返す', () async {
        final results = await repository.getProfilesByIds([]);

        expect(results, isEmpty);
      });

      test('10件以上のIDも正しく処理できる', () async {
        // 15件のプロフィールを作成
        for (int i = 0; i < 15; i++) {
          await createTestProfile(
            testProfile.copyWith(
              uid: 'user$i',
              displayName: 'User $i',
            ),
          );
        }

        final ids = List.generate(15, (i) => 'user$i');
        final results = await repository.getProfilesByIds(ids);

        expect(results.length, 15);
        expect(
          results.map((p) => p.uid).toSet(),
          ids.toSet(),
        );
      });
    });

    group('uploadAvatar', () {
      test('アバターアップロードは未実装エラーを返す', () async {
        expect(
          () => repository.uploadAvatar('test-uid', '/path/to/image.jpg'),
          throwsA(
            isA<AppException>().having(
              (e) => e.code,
              'code',
              AppErrorCode.unknown,
            ).having(
              (e) => e.message,
              'message',
              contains('未実装'),
            ),
          ),
        );
      });
    });

    group('Firestoreのクエリ制限', () {
      test('whereIn句の10件制限を考慮したバッチ処理', () async {
        // 25件のプロフィールを作成
        for (int i = 0; i < 25; i++) {
          await createTestProfile(
            testProfile.copyWith(
              uid: 'batch-user$i',
              displayName: 'Batch User $i',
            ),
          );
        }

        final ids = List.generate(25, (i) => 'batch-user$i');
        final results = await repository.getProfilesByIds(ids);

        // 3つのバッチ（10件、10件、5件）で処理されることを確認
        expect(results.length, 25);
        expect(
          results.map((p) => p.uid).toSet(),
          ids.toSet(),
        );
      });
    });
  });
}