import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/account/1_models/profile.dart';

void main() {
  group('AccountProfile', () {
    final testDate = DateTime(2024, 1, 1);
    final updatedDate = DateTime(2024, 1, 2);

    test('正しく作成できる', () {
      final profile = AccountProfile(
        uid: 'test-uid',
        displayName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(profile.uid, 'test-uid');
      expect(profile.displayName, 'Test User');
      expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
      expect(profile.createdAt, testDate);
      expect(profile.updatedAt, testDate);
    });

    test('デフォルト値が正しく設定される', () {
      final profile = AccountProfile(
        uid: 'test-uid',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(profile.uid, 'test-uid');
      expect(profile.displayName, ''); // デフォルト値
      expect(profile.avatarUrl, isNull);
      expect(profile.createdAt, testDate);
      expect(profile.updatedAt, testDate);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'uid': 'test-uid',
          'displayName': 'Test User',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-02T00:00:00.000',
        };

        final profile = AccountProfile.fromJson(json);

        expect(profile.uid, 'test-uid');
        expect(profile.displayName, 'Test User');
        expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
        expect(profile.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(profile.updatedAt, DateTime.parse('2024-01-02T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final profile = AccountProfile(
          uid: 'test-uid',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: testDate,
          updatedAt: updatedDate,
        );

        final json = profile.toJson();

        expect(json['uid'], 'test-uid');
        expect(json['displayName'], 'Test User');
        expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['updatedAt'], '2024-01-02T00:00:00.000');
      });

      test('null値を含むJSONから正しく変換できる', () {
        final json = {
          'uid': 'test-uid',
          'displayName': '',
          // avatarUrlは未定義
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-01T00:00:00.000',
        };

        final profile = AccountProfile.fromJson(json);

        expect(profile.uid, 'test-uid');
        expect(profile.displayName, '');
        expect(profile.avatarUrl, isNull);
        expect(profile.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(profile.updatedAt, DateTime.parse('2024-01-01T00:00:00.000'));
      });

      test('空の表示名でも正しく処理される', () {
        final profile = AccountProfile(
          uid: 'test-uid',
          displayName: '',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final json = profile.toJson();
        final restored = AccountProfile.fromJson(json);

        expect(restored.displayName, '');
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = AccountProfile(
          uid: 'test-uid',
          displayName: 'Original Name',
          avatarUrl: 'https://example.com/old.jpg',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          displayName: 'Updated Name',
          updatedAt: updatedDate,
        );

        expect(updated.uid, 'test-uid');
        expect(updated.displayName, 'Updated Name');
        expect(updated.avatarUrl, 'https://example.com/old.jpg');
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, updatedDate);
      });

      test('avatarUrlをnullに更新できる', () {
        final original = AccountProfile(
          uid: 'test-uid',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          avatarUrl: null,
        );

        expect(updated.avatarUrl, isNull);
      });
    });

    group('プロフィールの更新シナリオ', () {
      test('新規ユーザーのプロフィール作成', () {
        final newProfile = AccountProfile(
          uid: 'new-user-id',
          displayName: '', // 初期状態では空
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(newProfile.displayName, '');
        expect(newProfile.avatarUrl, isNull);
      });

      test('プロフィール情報の段階的な更新', () {
        final initial = AccountProfile(
          uid: 'user-id',
          createdAt: testDate,
          updatedAt: testDate,
        );

        // 名前を設定
        final withName = initial.copyWith(
          displayName: 'John Doe',
          updatedAt: DateTime.now(),
        );

        // アバターを設定
        final withAvatar = withName.copyWith(
          avatarUrl: 'https://example.com/john.jpg',
          updatedAt: DateTime.now(),
        );

        expect(withAvatar.displayName, 'John Doe');
        expect(withAvatar.avatarUrl, 'https://example.com/john.jpg');
      });
    });
  });
}