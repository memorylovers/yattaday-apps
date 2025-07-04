import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/account/1_models/account.dart';

void main() {
  group('Account', () {
    final testDate = DateTime(2024, 1, 1);
    final updatedDate = DateTime(2024, 1, 2);

    test('正しく作成できる', () {
      final account = Account(
        uid: 'test-uid',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(account.uid, 'test-uid');
      expect(account.createdAt, testDate);
      expect(account.updatedAt, testDate);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'uid': 'test-uid',
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-02T00:00:00.000',
        };

        final account = Account.fromJson(json);

        expect(account.uid, 'test-uid');
        expect(account.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(account.updatedAt, DateTime.parse('2024-01-02T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final account = Account(
          uid: 'test-uid',
          createdAt: testDate,
          updatedAt: updatedDate,
        );

        final json = account.toJson();

        expect(json['uid'], 'test-uid');
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['updatedAt'], '2024-01-02T00:00:00.000');
      });

      test('日時のミリ秒も正しく保持される', () {
        final dateWithMillis = DateTime(2024, 1, 1, 12, 30, 45, 123);
        final account = Account(
          uid: 'test-uid',
          createdAt: dateWithMillis,
          updatedAt: dateWithMillis,
        );

        final json = account.toJson();
        final restored = Account.fromJson(json);

        expect(restored.createdAt.millisecondsSinceEpoch, 
               dateWithMillis.millisecondsSinceEpoch);
        expect(restored.updatedAt.millisecondsSinceEpoch, 
               dateWithMillis.millisecondsSinceEpoch);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = Account(
          uid: 'test-uid',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          updatedAt: updatedDate,
        );

        expect(updated.uid, 'test-uid');
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, updatedDate);
      });

      test('UIDを変更できる', () {
        final original = Account(
          uid: 'test-uid',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          uid: 'new-uid',
        );

        expect(updated.uid, 'new-uid');
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, testDate);
      });
    });

    group('equality', () {
      test('同じ値を持つインスタンスは等しい', () {
        final account1 = Account(
          uid: 'test-uid',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final account2 = Account(
          uid: 'test-uid',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(account1, account2);
        expect(account1.hashCode, account2.hashCode);
      });

      test('異なる値を持つインスタンスは等しくない', () {
        final account1 = Account(
          uid: 'test-uid-1',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final account2 = Account(
          uid: 'test-uid-2',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(account1, isNot(account2));
      });
    });
  });
}