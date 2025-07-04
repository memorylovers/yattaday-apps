import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/1_models/record_item_statistics.dart';

void main() {
  group('RecordItemStatistics', () {
    final firstDate = DateTime(2023, 12, 1);
    final lastDate = DateTime(2024, 1, 15);

    test('正しく作成できる', () {
      final stats = RecordItemStatistics(
        totalCount: 100,
        currentStreak: 5,
        longestStreak: 20,
        firstRecordDate: firstDate,
        lastRecordDate: lastDate,
        thisMonthCount: 15,
        thisWeekCount: 7,
      );

      expect(stats.totalCount, 100);
      expect(stats.currentStreak, 5);
      expect(stats.longestStreak, 20);
      expect(stats.firstRecordDate, firstDate);
      expect(stats.lastRecordDate, lastDate);
      expect(stats.thisMonthCount, 15);
      expect(stats.thisWeekCount, 7);
    });

    test('日付はnull可能', () {
      final stats = RecordItemStatistics(
        totalCount: 0,
        currentStreak: 0,
        longestStreak: 0,
        firstRecordDate: null,
        lastRecordDate: null,
        thisMonthCount: 0,
        thisWeekCount: 0,
      );

      expect(stats.firstRecordDate, isNull);
      expect(stats.lastRecordDate, isNull);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'totalCount': 100,
          'currentStreak': 5,
          'longestStreak': 20,
          'firstRecordDate': '2023-12-01T00:00:00.000',
          'lastRecordDate': '2024-01-15T00:00:00.000',
          'thisMonthCount': 15,
          'thisWeekCount': 7,
        };

        final stats = RecordItemStatistics.fromJson(json);

        expect(stats.totalCount, 100);
        expect(stats.currentStreak, 5);
        expect(stats.longestStreak, 20);
        expect(
          stats.firstRecordDate,
          DateTime.parse('2023-12-01T00:00:00.000'),
        );
        expect(stats.lastRecordDate, DateTime.parse('2024-01-15T00:00:00.000'));
        expect(stats.thisMonthCount, 15);
        expect(stats.thisWeekCount, 7);
      });

      test('JSONに正しく変換できる', () {
        final stats = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 5,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        final json = stats.toJson();

        expect(json['totalCount'], 100);
        expect(json['currentStreak'], 5);
        expect(json['longestStreak'], 20);
        expect(json['firstRecordDate'], '2023-12-01T00:00:00.000');
        expect(json['lastRecordDate'], '2024-01-15T00:00:00.000');
        expect(json['thisMonthCount'], 15);
        expect(json['thisWeekCount'], 7);
      });

      test('日付がnullのJSONから正しく変換できる', () {
        final json = {
          'totalCount': 0,
          'currentStreak': 0,
          'longestStreak': 0,
          // firstRecordDateとlastRecordDateは未定義
          'thisMonthCount': 0,
          'thisWeekCount': 0,
        };

        final stats = RecordItemStatistics.fromJson(json);

        expect(stats.totalCount, 0);
        expect(stats.currentStreak, 0);
        expect(stats.longestStreak, 0);
        expect(stats.firstRecordDate, isNull);
        expect(stats.lastRecordDate, isNull);
        expect(stats.thisMonthCount, 0);
        expect(stats.thisWeekCount, 0);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 5,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        final updated = original.copyWith(
          totalCount: 101,
          currentStreak: 6,
          thisWeekCount: 8,
        );

        expect(updated.totalCount, 101);
        expect(updated.currentStreak, 6);
        expect(updated.longestStreak, 20); // 変更なし
        expect(updated.firstRecordDate, firstDate); // 変更なし
        expect(updated.lastRecordDate, lastDate); // 変更なし
        expect(updated.thisMonthCount, 15); // 変更なし
        expect(updated.thisWeekCount, 8);
      });

      test('日付をnullに更新できる', () {
        final original = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 5,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        final updated = original.copyWith(
          firstRecordDate: null,
          lastRecordDate: null,
        );

        expect(updated.firstRecordDate, isNull);
        expect(updated.lastRecordDate, isNull);
      });
    });

    group('統計値の整合性', () {
      test('現在の連続記録は最長連続記録を超えない', () {
        final stats = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 20,
          longestStreak: 20, // 同じ値は許容
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        expect(stats.currentStreak <= stats.longestStreak, isTrue);
      });

      test('週の記録回数は月の記録回数を超えない', () {
        final stats = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 5,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        expect(stats.thisWeekCount <= stats.thisMonthCount, isTrue);
      });

      test('月の記録回数は合計記録回数を超えない', () {
        final stats = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 5,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        expect(stats.thisMonthCount <= stats.totalCount, isTrue);
      });
    });

    group('初期状態', () {
      test('記録がない場合の初期状態', () {
        final stats = RecordItemStatistics(
          totalCount: 0,
          currentStreak: 0,
          longestStreak: 0,
          firstRecordDate: null,
          lastRecordDate: null,
          thisMonthCount: 0,
          thisWeekCount: 0,
        );

        expect(stats.totalCount, 0);
        expect(stats.currentStreak, 0);
        expect(stats.longestStreak, 0);
        expect(stats.firstRecordDate, isNull);
        expect(stats.lastRecordDate, isNull);
        expect(stats.thisMonthCount, 0);
        expect(stats.thisWeekCount, 0);
      });

      test('最初の記録後の状態', () {
        final now = DateTime.now();
        final stats = RecordItemStatistics(
          totalCount: 1,
          currentStreak: 1,
          longestStreak: 1,
          firstRecordDate: now,
          lastRecordDate: now,
          thisMonthCount: 1,
          thisWeekCount: 1,
        );

        expect(stats.totalCount, 1);
        expect(stats.currentStreak, 1);
        expect(stats.longestStreak, 1);
        expect(stats.firstRecordDate, now);
        expect(stats.lastRecordDate, now);
        expect(stats.thisMonthCount, 1);
        expect(stats.thisWeekCount, 1);
      });
    });

    group('統計情報の更新パターン', () {
      test('連続記録が途切れた場合', () {
        final original = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 10,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: DateTime(2024, 1, 10),
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        // 連続記録がリセットされる
        final updated = original.copyWith(
          currentStreak: 0,
          lastRecordDate: DateTime(2024, 1, 15), // 5日後
        );

        expect(updated.currentStreak, 0);
        expect(updated.longestStreak, 20); // 最長記録は変わらない
      });

      test('新記録達成時', () {
        final original = RecordItemStatistics(
          totalCount: 100,
          currentStreak: 20,
          longestStreak: 20,
          firstRecordDate: firstDate,
          lastRecordDate: lastDate,
          thisMonthCount: 15,
          thisWeekCount: 7,
        );

        // 新記録達成
        final updated = original.copyWith(
          totalCount: 101,
          currentStreak: 21,
          longestStreak: 21, // 最長記録も更新
        );

        expect(updated.currentStreak, 21);
        expect(updated.longestStreak, 21);
      });
    });
  });
}
