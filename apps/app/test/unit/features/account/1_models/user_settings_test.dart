// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/account/1_models/user_settings.dart';

void main() {
  group('UserSettings', () {
    final testDate = DateTime(2024, 1, 1);
    final updatedDate = DateTime(2024, 1, 2);

    test('正しく作成できる', () {
      final settings = UserSettings(
        userId: 'test-user-id',
        locale: 'ja',
        notificationsEnabled: true,
        notificationTime: '09:00',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(settings.userId, 'test-user-id');
      expect(settings.locale, 'ja');
      expect(settings.notificationsEnabled, true);
      expect(settings.notificationTime, '09:00');
      expect(settings.createdAt, testDate);
      expect(settings.updatedAt, testDate);
    });

    test('通知時刻なしで作成できる', () {
      final settings = UserSettings(
        userId: 'test-user-id',
        locale: 'en',
        notificationsEnabled: false,
        notificationTime: null,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(settings.userId, 'test-user-id');
      expect(settings.locale, 'en');
      expect(settings.notificationsEnabled, false);
      expect(settings.notificationTime, isNull);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'userId': 'test-user-id',
          'locale': 'ja',
          'notificationsEnabled': true,
          'notificationTime': '09:00',
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-02T00:00:00.000',
        };

        final settings = UserSettings.fromJson(json);

        expect(settings.userId, 'test-user-id');
        expect(settings.locale, 'ja');
        expect(settings.notificationsEnabled, true);
        expect(settings.notificationTime, '09:00');
        expect(settings.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(settings.updatedAt, DateTime.parse('2024-01-02T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: updatedDate,
        );

        final json = settings.toJson();

        expect(json['userId'], 'test-user-id');
        expect(json['locale'], 'ja');
        expect(json['notificationsEnabled'], true);
        expect(json['notificationTime'], '09:00');
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['updatedAt'], '2024-01-02T00:00:00.000');
      });

      test('null値を含むJSONから正しく変換できる', () {
        final json = {
          'userId': 'test-user-id',
          'locale': 'en',
          'notificationsEnabled': false,
          // notificationTimeは未定義
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-01T00:00:00.000',
        };

        final settings = UserSettings.fromJson(json);

        expect(settings.userId, 'test-user-id');
        expect(settings.locale, 'en');
        expect(settings.notificationsEnabled, false);
        expect(settings.notificationTime, isNull);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          locale: 'en',
          notificationsEnabled: false,
          updatedAt: updatedDate,
        );

        expect(updated.userId, 'test-user-id');
        expect(updated.locale, 'en');
        expect(updated.notificationsEnabled, false);
        expect(updated.notificationTime, '09:00');
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, updatedDate);
      });

      test('通知時刻をnullに更新できる', () {
        final original = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          notificationTime: null,
        );

        expect(updated.notificationTime, isNull);
      });
    });

    group('notificationTimeOfDay extension', () {
      test('有効な時刻文字列からTimeOfDayに変換できる', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:30',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final timeOfDay = settings.notificationTimeOfDay;
        expect(timeOfDay, isNotNull);
        expect(timeOfDay!.hour, 9);
        expect(timeOfDay.minute, 30);
      });

      test('24時間形式の時刻を正しく処理できる', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '23:59',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final timeOfDay = settings.notificationTimeOfDay;
        expect(timeOfDay, isNotNull);
        expect(timeOfDay!.hour, 23);
        expect(timeOfDay.minute, 59);
      });

      test('nullの場合はnullを返す', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: false,
          notificationTime: null,
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settings.notificationTimeOfDay, isNull);
      });

      test('不正な形式の場合はnullを返す', () {
        final settingsWithInvalidFormat = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '9:30:00', // 秒も含む形式
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settingsWithInvalidFormat.notificationTimeOfDay, isNull);
      });

      test('数値でない文字列の場合は0を返す', () {
        final settingsWithNonNumeric = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: 'aa:bb',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final timeOfDay = settingsWithNonNumeric.notificationTimeOfDay;
        expect(timeOfDay, isNotNull);
        expect(timeOfDay!.hour, 0);
        expect(timeOfDay.minute, 0);
      });

      test('ゼロパディングされた時刻を正しく処理できる', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '08:05',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final timeOfDay = settings.notificationTimeOfDay;
        expect(timeOfDay, isNotNull);
        expect(timeOfDay!.hour, 8);
        expect(timeOfDay.minute, 5);
      });
    });

    group('言語設定のシナリオ', () {
      test('日本語設定', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settings.locale, 'ja');
      });

      test('英語設定', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'en',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settings.locale, 'en');
      });
    });

    group('通知設定のシナリオ', () {
      test('通知有効で時刻設定あり', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: true,
          notificationTime: '09:00',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settings.notificationsEnabled, true);
        expect(settings.notificationTime, isNotNull);
        expect(settings.notificationTimeOfDay, isNotNull);
      });

      test('通知無効の場合は時刻設定がnullでもよい', () {
        final settings = UserSettings(
          userId: 'test-user-id',
          locale: 'ja',
          notificationsEnabled: false,
          notificationTime: null,
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(settings.notificationsEnabled, false);
        expect(settings.notificationTime, isNull);
        expect(settings.notificationTimeOfDay, isNull);
      });
    });
  });
}