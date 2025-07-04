import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/features/_authentication/1_models/auth_user.dart';

void main() {
  group('AuthUser', () {
    final testDate = DateTime(2024, 1, 1);
    
    test('正しく作成できる', () {
      final user = AuthUser(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        isAnonymous: false,
        isEmailVerified: true,
        phoneNumber: '+1234567890',
        authTypes: [AuthType.google],
        createdAt: testDate,
        lastSignInAt: testDate,
      );

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.isAnonymous, false);
      expect(user.isEmailVerified, true);
      expect(user.phoneNumber, '+1234567890');
      expect(user.authTypes, [AuthType.google]);
      expect(user.createdAt, testDate);
      expect(user.lastSignInAt, testDate);
    });

    test('デフォルト値が正しく設定される', () {
      final user = AuthUser(uid: 'test-uid');

      expect(user.uid, 'test-uid');
      expect(user.email, isNull);
      expect(user.displayName, isNull);
      expect(user.photoUrl, isNull);
      expect(user.isAnonymous, false);
      expect(user.isEmailVerified, false);
      expect(user.phoneNumber, isNull);
      expect(user.authTypes, []);
      expect(user.createdAt, isNull);
      expect(user.lastSignInAt, isNull);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'uid': 'test-uid',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoUrl': 'https://example.com/photo.jpg',
          'isAnonymous': false,
          'isEmailVerified': true,
          'phoneNumber': '+1234567890',
          'authTypes': ['google', 'apple'],
          'createdAt': '2024-01-01T00:00:00.000',
          'lastSignInAt': '2024-01-01T00:00:00.000',
        };

        final user = AuthUser.fromJson(json);

        expect(user.uid, 'test-uid');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');
        expect(user.photoUrl, 'https://example.com/photo.jpg');
        expect(user.isAnonymous, false);
        expect(user.isEmailVerified, true);
        expect(user.phoneNumber, '+1234567890');
        expect(user.authTypes, [AuthType.google, AuthType.apple]);
        expect(user.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(user.lastSignInAt, DateTime.parse('2024-01-01T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final user = AuthUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          isAnonymous: false,
          isEmailVerified: true,
          phoneNumber: '+1234567890',
          authTypes: [AuthType.google, AuthType.apple],
          createdAt: testDate,
          lastSignInAt: testDate,
        );

        final json = user.toJson();

        expect(json['uid'], 'test-uid');
        expect(json['email'], 'test@example.com');
        expect(json['displayName'], 'Test User');
        expect(json['photoUrl'], 'https://example.com/photo.jpg');
        expect(json['isAnonymous'], false);
        expect(json['isEmailVerified'], true);
        expect(json['phoneNumber'], '+1234567890');
        expect(json['authTypes'], ['google', 'apple']);
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['lastSignInAt'], '2024-01-01T00:00:00.000');
      });

      test('null値を含むJSONから正しく変換できる', () {
        final json = {
          'uid': 'test-uid',
          // その他のフィールドはnullまたは未定義
        };

        final user = AuthUser.fromJson(json);

        expect(user.uid, 'test-uid');
        expect(user.email, isNull);
        expect(user.displayName, isNull);
        expect(user.photoUrl, isNull);
        expect(user.isAnonymous, false);
        expect(user.isEmailVerified, false);
        expect(user.phoneNumber, isNull);
        expect(user.authTypes, []);
        expect(user.createdAt, isNull);
        expect(user.lastSignInAt, isNull);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = AuthUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          isAnonymous: false,
        );

        final updated = original.copyWith(
          email: 'updated@example.com',
          displayName: 'Updated User',
        );

        expect(updated.uid, 'test-uid');
        expect(updated.email, 'updated@example.com');
        expect(updated.displayName, 'Updated User');
        expect(updated.isAnonymous, false);
      });

      test('authTypesを更新できる', () {
        final original = AuthUser(
          uid: 'test-uid',
          authTypes: [AuthType.google],
        );

        final updated = original.copyWith(
          authTypes: [AuthType.google, AuthType.apple],
        );

        expect(updated.authTypes, [AuthType.google, AuthType.apple]);
      });
    });

    group('匿名ユーザー', () {
      test('匿名ユーザーを正しく作成できる', () {
        final anonymousUser = AuthUser(
          uid: 'anonymous-uid',
          isAnonymous: true,
          authTypes: [AuthType.anonymous],
        );

        expect(anonymousUser.isAnonymous, true);
        expect(anonymousUser.authTypes.contains(AuthType.anonymous), true);
        expect(anonymousUser.email, isNull);
        expect(anonymousUser.displayName, isNull);
      });
    });

    group('複数認証プロバイダー', () {
      test('複数の認証プロバイダーを持つユーザーを作成できる', () {
        final multiAuthUser = AuthUser(
          uid: 'multi-auth-uid',
          email: 'multi@example.com',
          authTypes: [AuthType.google, AuthType.apple],
        );

        expect(multiAuthUser.authTypes.length, 2);
        expect(multiAuthUser.authTypes.contains(AuthType.google), true);
        expect(multiAuthUser.authTypes.contains(AuthType.apple), true);
      });
    });
  });
}