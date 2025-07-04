import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';

void main() {
  group('AuthType', () {
    test('enumの値が正しく定義されている', () {
      expect(AuthType.values, [
        AuthType.google,
        AuthType.apple,
        AuthType.anonymous,
      ]);
    });

    test('各enumの値が正しい', () {
      expect(AuthType.google.name, 'google');
      expect(AuthType.apple.name, 'apple');
      expect(AuthType.anonymous.name, 'anonymous');
    });
  });

  group('authTypeFromProviderId', () {
    test('Googleプロバイダーを正しく変換する', () {
      final result = authTypeFromProviderId('google.com');
      expect(result, AuthType.google);
    });

    test('Appleプロバイダーを正しく変換する', () {
      final result = authTypeFromProviderId('apple.com');
      expect(result, AuthType.apple);
    });

    test('未知のプロバイダーの場合nullを返す', () {
      final result = authTypeFromProviderId('facebook.com');
      expect(result, isNull);
    });

    test('空文字列の場合nullを返す', () {
      final result = authTypeFromProviderId('');
      expect(result, isNull);
    });

    test('匿名認証のプロバイダーIDは変換できない', () {
      // Firebase Authでは匿名認証にプロバイダーIDがないため
      final result = authTypeFromProviderId('anonymous');
      expect(result, isNull);
    });
  });
}