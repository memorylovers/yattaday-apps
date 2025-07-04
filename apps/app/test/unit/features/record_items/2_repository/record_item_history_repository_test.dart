import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/features/record_items/1_models/record_item_history.dart';
import 'package:myapp/features/record_items/2_repository/record_item_history_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseRecordItemHistoryRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirebaseRecordItemHistoryRepository(fakeFirestore);
  });

  group('FirebaseRecordItemHistoryRepository', () {
    final testHistory = RecordItemHistory(
      id: '2024-01-01',
      userId: 'test-user',
      date: '2024-01-01',
      recordItemId: 'record-item-1',
      note: 'テストメモ',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    // テスト用の履歴を事前に作成するヘルパー関数
    Future<void> createTestHistory(RecordItemHistory history) async {
      await fakeFirestore
          .collection('users')
          .doc(history.userId)
          .collection('recordItems')
          .doc(history.recordItemId)
          .collection('histories')
          .doc(history.date)
          .set(history.toJson());
    }

    group('create', () {
      test('記録を作成できる', () async {
        await repository.create(testHistory);

        // 作成されたことを確認
        final doc =
            await fakeFirestore
                .collection('users')
                .doc('test-user')
                .collection('recordItems')
                .doc('record-item-1')
                .collection('histories')
                .doc('2024-01-01')
                .get();

        expect(doc.exists, isTrue);
        final data = RecordItemHistory.fromJson(doc.data()!);
        expect(data.userId, 'test-user');
        expect(data.recordItemId, 'record-item-1');
        expect(data.date, '2024-01-01');
        expect(data.note, 'テストメモ');
      });

      test('同じ日付の記録が既に存在する場合はエラーになる', () async {
        await createTestHistory(testHistory);

        expect(
          () => repository.create(testHistory),
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

    group('update', () {
      test('記録を更新できる', () async {
        await createTestHistory(testHistory);

        final updatedHistory = testHistory.copyWith(
          note: '更新後のメモ',
          updatedAt: DateTime(2024, 1, 2),
        );

        await repository.update(updatedHistory);

        // 更新されたことを確認
        final doc =
            await fakeFirestore
                .collection('users')
                .doc('test-user')
                .collection('recordItems')
                .doc('record-item-1')
                .collection('histories')
                .doc('2024-01-01')
                .get();

        final data = RecordItemHistory.fromJson(doc.data()!);
        expect(data.note, '更新後のメモ');
        expect(data.updatedAt, DateTime(2024, 1, 2));
      });

      test('存在しない記録を更新しようとするとエラーになる', () async {
        expect(
          () => repository.update(testHistory),
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

    group('delete', () {
      test('記録を削除できる', () async {
        await createTestHistory(testHistory);

        await repository.delete(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          historyId: '2024-01-01',
        );

        // 削除されたことを確認
        final doc =
            await fakeFirestore
                .collection('users')
                .doc('test-user')
                .collection('recordItems')
                .doc('record-item-1')
                .collection('histories')
                .doc('2024-01-01')
                .get();

        expect(doc.exists, isFalse);
      });

      test('存在しない記録を削除しようとするとエラーになる', () async {
        expect(
          () => repository.delete(
            userId: 'test-user',
            recordItemId: 'record-item-1',
            historyId: '2024-01-01',
          ),
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

    group('getById', () {
      test('IDで記録を取得できる', () async {
        await createTestHistory(testHistory);

        final result = await repository.getById(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          historyId: '2024-01-01',
        );

        expect(result, isNotNull);
        expect(result!.date, '2024-01-01');
        expect(result.note, 'テストメモ');
      });

      test('存在しない記録の場合はnullを返す', () async {
        final result = await repository.getById(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          historyId: 'non-existent',
        );

        expect(result, isNull);
      });
    });

    group('getByDate', () {
      test('日付で記録を取得できる', () async {
        await createTestHistory(testHistory);

        final result = await repository.getByDate(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          date: '2024-01-01',
        );

        expect(result, isNotNull);
        expect(result!.date, '2024-01-01');
        expect(result.note, 'テストメモ');
      });

      test('存在しない日付の場合はnullを返す', () async {
        final result = await repository.getByDate(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          date: '2024-01-02',
        );

        expect(result, isNull);
      });
    });

    group('getByDateRange', () {
      test('指定期間の記録を取得できる', () async {
        // 複数の記録を作成
        final histories = [
          testHistory.copyWith(date: '2024-01-01', id: '2024-01-01'),
          testHistory.copyWith(date: '2024-01-05', id: '2024-01-05'),
          testHistory.copyWith(date: '2024-01-10', id: '2024-01-10'),
          testHistory.copyWith(date: '2024-01-15', id: '2024-01-15'),
        ];

        for (final history in histories) {
          await createTestHistory(history);
        }

        final results = await repository.getByDateRange(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          startDate: DateTime(2024, 1, 5),
          endDate: DateTime(2024, 1, 10),
        );

        expect(results.length, 2);
        expect(results.map((h) => h.date).toList(), [
          '2024-01-10',
          '2024-01-05',
        ]);
      });

      test('日付の降順で返される', () async {
        final histories = [
          testHistory.copyWith(date: '2024-01-01', id: '2024-01-01'),
          testHistory.copyWith(date: '2024-01-03', id: '2024-01-03'),
          testHistory.copyWith(date: '2024-01-02', id: '2024-01-02'),
        ];

        for (final history in histories) {
          await createTestHistory(history);
        }

        final results = await repository.getByDateRange(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(results.map((h) => h.date).toList(), [
          '2024-01-03',
          '2024-01-02',
          '2024-01-01',
        ]);
      });

      test('記録がない期間の場合は空のリストを返す', () async {
        final results = await repository.getByDateRange(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 28),
        );

        expect(results, isEmpty);
      });
    });

    group('watchByDateRange', () {
      test('指定期間の記録の変更を監視できる', () async {
        // 初期データ作成
        await createTestHistory(testHistory);

        final stream = repository.watchByDateRange(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expectLater(
          stream,
          emitsInOrder([
            // 初期状態
            predicate<List<RecordItemHistory>>((histories) {
              expect(histories.length, 1);
              expect(histories.first.date, '2024-01-01');
              return true;
            }),
            // 新しい記録が追加された後
            predicate<List<RecordItemHistory>>((histories) {
              expect(histories.length, 2);
              expect(histories.map((h) => h.date).toList(), [
                '2024-01-05',
                '2024-01-01',
              ]);
              return true;
            }),
          ]),
        );

        // 少し待ってから新しい記録を追加
        await Future.delayed(const Duration(milliseconds: 100));
        await createTestHistory(
          testHistory.copyWith(date: '2024-01-05', id: '2024-01-05'),
        );
      });
    });

    group('getAll', () {
      test('全ての記録を取得できる', () async {
        final histories = [
          testHistory.copyWith(date: '2024-01-01', id: '2024-01-01'),
          testHistory.copyWith(date: '2024-01-15', id: '2024-01-15'),
          testHistory.copyWith(date: '2024-02-01', id: '2024-02-01'),
        ];

        for (final history in histories) {
          await createTestHistory(history);
        }

        final results = await repository.getAll(
          userId: 'test-user',
          recordItemId: 'record-item-1',
        );

        expect(results.length, 3);
        // 日付の降順で返される
        expect(results.map((h) => h.date).toList(), [
          '2024-02-01',
          '2024-01-15',
          '2024-01-01',
        ]);
      });

      test('記録がない場合は空のリストを返す', () async {
        final results = await repository.getAll(
          userId: 'test-user',
          recordItemId: 'record-item-1',
        );

        expect(results, isEmpty);
      });
    });

    group('getRecordedDates', () {
      test('記録が存在する日付のリストを取得できる', () async {
        final histories = [
          testHistory.copyWith(date: '2024-01-01', id: '2024-01-01'),
          testHistory.copyWith(date: '2024-01-05', id: '2024-01-05'),
          testHistory.copyWith(date: '2024-01-10', id: '2024-01-10'),
        ];

        for (final history in histories) {
          await createTestHistory(history);
        }

        final dates = await repository.getRecordedDates(
          userId: 'test-user',
          recordItemId: 'record-item-1',
        );

        expect(dates.length, 3);
        expect(dates.toSet(), {'2024-01-01', '2024-01-05', '2024-01-10'});
      });

      test('記録がない場合は空のリストを返す', () async {
        final dates = await repository.getRecordedDates(
          userId: 'test-user',
          recordItemId: 'record-item-1',
        );

        expect(dates, isEmpty);
      });
    });

    group('日付フォーマット', () {
      test('DateTimeが正しくyyyy-MM-dd形式に変換される', () async {
        // 1桁の月日もゼロパディングされることを確認
        final history = testHistory.copyWith(
          date: '2024-02-05',
          id: '2024-02-05',
        );
        await createTestHistory(history);

        final results = await repository.getByDateRange(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          startDate: DateTime(2024, 2, 1),
          endDate: DateTime(2024, 2, 10),
        );

        expect(results.length, 1);
        expect(results.first.date, '2024-02-05');
      });
    });

    group('ネストされたコレクション構造', () {
      test('正しいパスに保存される', () async {
        await repository.create(testHistory);

        // 正しいパスに保存されていることを確認
        final doc =
            await fakeFirestore
                .doc(
                  'users/test-user/recordItems/record-item-1/histories/2024-01-01',
                )
                .get();

        expect(doc.exists, isTrue);
      });

      test('異なるユーザー・記録項目の履歴は独立して管理される', () async {
        // ユーザー1の記録
        await repository.create(testHistory);

        // ユーザー2の記録
        final user2History = testHistory.copyWith(userId: 'test-user-2');
        await repository.create(user2History);

        // それぞれ独立して取得できることを確認
        final user1Result = await repository.getByDate(
          userId: 'test-user',
          recordItemId: 'record-item-1',
          date: '2024-01-01',
        );
        final user2Result = await repository.getByDate(
          userId: 'test-user-2',
          recordItemId: 'record-item-1',
          date: '2024-01-01',
        );

        expect(user1Result, isNotNull);
        expect(user2Result, isNotNull);
        expect(user1Result!.userId, 'test-user');
        expect(user2Result!.userId, 'test-user-2');
      });
    });
  });
}
