import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/2_repository/record_item_history_repository.dart';

import '../../../../test_helpers/fixtures/record_item_history_helpers.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseRecordItemHistoryRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirebaseRecordItemHistoryRepository(fakeFirestore);
  });

  group('FirebaseRecordItemHistoryRepository', () {
    final testHistory = createTestRecordItemHistory(
      id: '2024-01-01',
      date: '2024-01-01',
      recordItemId: 'test-item-id',
      userId: 'test-user-id',
      note: 'テストノート',
    );

    group('create', () {
      test('履歴を正しく作成できること', () async {
        await repository.create(testHistory);

        final snapshot =
            await fakeFirestore
                .collection('users')
                .doc(testHistory.userId)
                .collection('recordItems')
                .doc(testHistory.recordItemId)
                .collection('histories')
                .doc(testHistory.date)
                .get();

        expect(snapshot.exists, true);
        expect(snapshot.data()?['date'], testHistory.date);
        expect(snapshot.data()?['recordItemId'], testHistory.recordItemId);
        expect(snapshot.data()?['note'], testHistory.note);
      });
    });

    group('update', () {
      test('履歴を正しく更新できること', () async {
        await repository.create(testHistory);

        final updatedHistory = testHistory.copyWith(note: '更新後のノート');
        await repository.update(updatedHistory);

        final snapshot =
            await fakeFirestore
                .collection('users')
                .doc(testHistory.userId)
                .collection('recordItems')
                .doc(testHistory.recordItemId)
                .collection('histories')
                .doc(testHistory.date)
                .get();

        expect(snapshot.data()?['note'], '更新後のノート');
      });
    });

    group('delete', () {
      test('履歴を正しく削除できること', () async {
        await repository.create(testHistory);

        await repository.delete(
          userId: testHistory.userId,
          recordItemId: testHistory.recordItemId,
          historyId: testHistory.id,
        );

        final snapshot =
            await fakeFirestore
                .collection('users')
                .doc(testHistory.userId)
                .collection('recordItems')
                .doc(testHistory.recordItemId)
                .collection('histories')
                .doc(testHistory.date)
                .get();

        expect(snapshot.exists, false);
      });
    });

    group('getById', () {
      test('IDで履歴を取得できること', () async {
        await repository.create(testHistory);

        final result = await repository.getById(
          userId: testHistory.userId,
          recordItemId: testHistory.recordItemId,
          historyId: testHistory.id,
        );

        expect(result?.id, testHistory.id);
        expect(result?.recordItemId, testHistory.recordItemId);
        expect(result?.note, testHistory.note);
      });

      test('存在しないIDの場合nullを返すこと', () async {
        final result = await repository.getById(
          userId: 'userId',
          recordItemId: 'itemId',
          historyId: 'nonexistent',
        );

        expect(result, isNull);
      });
    });

    group('getByDate', () {
      test('日付で履歴を取得できること', () async {
        await repository.create(testHistory);

        final result = await repository.getByDate(
          userId: testHistory.userId,
          recordItemId: testHistory.recordItemId,
          date: testHistory.date,
        );

        expect(result?.id, testHistory.id);
        expect(result?.recordItemId, testHistory.recordItemId);
        expect(result?.note, testHistory.note);
      });

      test('存在しない日付の場合nullを返すこと', () async {
        final result = await repository.getByDate(
          userId: 'userId',
          recordItemId: 'itemId',
          date: '2099-12-31',
        );

        expect(result, isNull);
      });
    });

    group('getByDateRange', () {
      test('日付範囲で履歴を取得できること', () async {
        final histories = [
          createTestRecordItemHistory(
            id: '2024-01-01',
            date: '2024-01-01',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
          createTestRecordItemHistory(
            id: '2024-01-02',
            date: '2024-01-02',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
          createTestRecordItemHistory(
            id: '2024-01-03',
            date: '2024-01-03',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
          createTestRecordItemHistory(
            id: '2024-01-04',
            date: '2024-01-04',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
        ];

        for (final history in histories) {
          await repository.create(history);
        }

        // 1月2日から1月3日の履歴を取得
        final result = await repository.getByDateRange(
          userId: testHistory.userId,
          recordItemId: 'item1',
          startDate: DateTime(2024, 1, 2),
          endDate: DateTime(2024, 1, 3),
        );

        expect(result.length, 2);
        // 降順（新しい順）で返される
        expect(result[0].date, '2024-01-03');
        expect(result[1].date, '2024-01-02');
      });
    });

    group('watchByDateRange', () {
      test('日付範囲で履歴をリアルタイム監視できること', () async {
        final history = createTestRecordItemHistory(
          id: '2024-01-02',
          date: '2024-01-02',
          recordItemId: 'item1',
          userId: testHistory.userId,
        );

        final stream = repository.watchByDateRange(
          userId: testHistory.userId,
          recordItemId: 'item1',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 3),
        );

        // 初期状態
        expect(await stream.first, isEmpty);

        // 履歴追加
        await repository.create(history);

        final result = await stream.first;
        expect(result.length, 1);
        expect(result.first.id, history.id);
      });
    });

    group('getAll', () {
      test('すべての履歴を取得できること', () async {
        final histories = [
          createTestRecordItemHistory(
            id: '2024-01-01',
            date: '2024-01-01',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
          createTestRecordItemHistory(
            id: '2024-01-02',
            date: '2024-01-02',
            recordItemId: 'item2',
            userId: testHistory.userId,
          ),
          createTestRecordItemHistory(
            id: '2024-01-03',
            date: '2024-01-03',
            recordItemId: 'item1',
            userId: testHistory.userId,
          ),
        ];

        for (final history in histories) {
          await repository.create(history);
        }

        final result = await repository.getAll(
          userId: testHistory.userId,
          recordItemId: 'item1',
        );

        expect(result.length, 2);
        expect(result.every((h) => h.recordItemId == 'item1'), true);
      });
    });
  });
}
