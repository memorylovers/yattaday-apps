import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/1_models/record_item_history.dart';

void main() {
  group('RecordItemHistory', () {
    final testDate = DateTime(2024, 1, 1);
    final updatedDate = DateTime(2024, 1, 2);

    test('正しく作成できる', () {
      final history = RecordItemHistory(
        id: 'history-id',
        userId: 'test-user-id',
        date: '2024-01-01',
        recordItemId: 'record-item-id',
        note: 'テストメモ',
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(history.id, 'history-id');
      expect(history.userId, 'test-user-id');
      expect(history.date, '2024-01-01');
      expect(history.recordItemId, 'record-item-id');
      expect(history.note, 'テストメモ');
      expect(history.createdAt, testDate);
      expect(history.updatedAt, testDate);
    });

    test('noteはnull可能', () {
      final history = RecordItemHistory(
        id: 'history-id',
        userId: 'test-user-id',
        date: '2024-01-01',
        recordItemId: 'record-item-id',
        note: null,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(history.note, isNull);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'id': 'history-id',
          'userId': 'test-user-id',
          'date': '2024-01-01',
          'recordItemId': 'record-item-id',
          'note': 'テストメモ',
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-02T00:00:00.000',
        };

        final history = RecordItemHistory.fromJson(json);

        expect(history.id, 'history-id');
        expect(history.userId, 'test-user-id');
        expect(history.date, '2024-01-01');
        expect(history.recordItemId, 'record-item-id');
        expect(history.note, 'テストメモ');
        expect(history.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(history.updatedAt, DateTime.parse('2024-01-02T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final history = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-01-01',
          recordItemId: 'record-item-id',
          note: 'テストメモ',
          createdAt: testDate,
          updatedAt: updatedDate,
        );

        final json = history.toJson();

        expect(json['id'], 'history-id');
        expect(json['userId'], 'test-user-id');
        expect(json['date'], '2024-01-01');
        expect(json['recordItemId'], 'record-item-id');
        expect(json['note'], 'テストメモ');
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['updatedAt'], '2024-01-02T00:00:00.000');
      });

      test('noteがnullのJSONから正しく変換できる', () {
        final json = {
          'id': 'history-id',
          'userId': 'test-user-id',
          'date': '2024-01-01',
          'recordItemId': 'record-item-id',
          // noteは未定義
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-01T00:00:00.000',
        };

        final history = RecordItemHistory.fromJson(json);

        expect(history.note, isNull);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-01-01',
          recordItemId: 'record-item-id',
          note: '元のメモ',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          note: '更新後のメモ',
          updatedAt: updatedDate,
        );

        expect(updated.id, 'history-id');
        expect(updated.userId, 'test-user-id');
        expect(updated.date, '2024-01-01');
        expect(updated.recordItemId, 'record-item-id');
        expect(updated.note, '更新後のメモ');
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, updatedDate);
      });

      test('noteをnullに更新できる', () {
        final original = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-01-01',
          recordItemId: 'record-item-id',
          note: 'メモあり',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(note: null);

        expect(updated.note, isNull);
      });
    });

    group('dateTime extension', () {
      test('date文字列をDateTimeに変換できる', () {
        final history = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-01-15',
          recordItemId: 'record-item-id',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final dateTime = history.dateTime;
        expect(dateTime.year, 2024);
        expect(dateTime.month, 1);
        expect(dateTime.day, 15);
      });

      test('異なる日付形式でも正しく変換できる', () {
        final history = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-12-31',
          recordItemId: 'record-item-id',
          createdAt: testDate,
          updatedAt: testDate,
        );

        final dateTime = history.dateTime;
        expect(dateTime.year, 2024);
        expect(dateTime.month, 12);
        expect(dateTime.day, 31);
      });
    });

    group('日付のバリデーション', () {
      test('有効な日付文字列を保持できる', () {
        final history = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024-02-29', // うるう年
          recordItemId: 'record-item-id',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(history.date, '2024-02-29');
        expect(() => history.dateTime, returnsNormally);
      });

      test('日付文字列は任意の形式で保存される', () {
        // モデル自体はバリデーションしないので、任意の文字列を保存可能
        final history = RecordItemHistory(
          id: 'history-id',
          userId: 'test-user-id',
          date: '2024/01/01', // スラッシュ区切り
          recordItemId: 'record-item-id',
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(history.date, '2024/01/01');
        // DateTime.parseはスラッシュ区切りを受け付けないのでエラーになる
        expect(() => history.dateTime, throwsFormatException);
      });
    });

    group('複数の履歴の管理', () {
      test('同じ日付で複数の記録項目の履歴を作成できる', () {
        final histories = [
          RecordItemHistory(
            id: 'history-1',
            userId: 'user-id',
            date: '2024-01-01',
            recordItemId: 'item-1',
            createdAt: testDate,
            updatedAt: testDate,
          ),
          RecordItemHistory(
            id: 'history-2',
            userId: 'user-id',
            date: '2024-01-01',
            recordItemId: 'item-2',
            createdAt: testDate,
            updatedAt: testDate,
          ),
        ];

        expect(histories[0].date, histories[1].date);
        expect(histories[0].recordItemId, isNot(histories[1].recordItemId));
      });

      test('同じ記録項目で異なる日付の履歴を作成できる', () {
        final histories = [
          RecordItemHistory(
            id: 'history-1',
            userId: 'user-id',
            date: '2024-01-01',
            recordItemId: 'item-1',
            createdAt: testDate,
            updatedAt: testDate,
          ),
          RecordItemHistory(
            id: 'history-2',
            userId: 'user-id',
            date: '2024-01-02',
            recordItemId: 'item-1',
            createdAt: testDate,
            updatedAt: testDate,
          ),
        ];

        expect(histories[0].recordItemId, histories[1].recordItemId);
        expect(histories[0].date, isNot(histories[1].date));
      });
    });
  });
}
