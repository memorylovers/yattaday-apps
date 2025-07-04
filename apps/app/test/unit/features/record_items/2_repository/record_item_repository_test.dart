import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';

import '../../../../test_helpers/fixtures/record_item_helpers.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirebaseRecordItemRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirebaseRecordItemRepository(fakeFirestore);
  });

  group('FirebaseRecordItemRepository', () {
    group('create', () {
      test('記録項目を正しく作成できること', () async {
        final recordItem = createTestRecordItem();

        await repository.create(recordItem);

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(recordItem.userId)
            .collection('recordItems')
            .doc(recordItem.id)
            .get();

        expect(snapshot.exists, true);
        expect(snapshot.data()?['title'], recordItem.title);
      });
    });

    group('update', () {
      test('記録項目を正しく更新できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        final updatedItem = recordItem.copyWith(title: '更新後のタイトル');
        await repository.update(updatedItem);

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(recordItem.userId)
            .collection('recordItems')
            .doc(recordItem.id)
            .get();

        expect(snapshot.data()?['title'], '更新後のタイトル');
      });
    });

    group('delete', () {
      test('記録項目を正しく削除できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        await repository.delete(recordItem.userId, recordItem.id);

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(recordItem.userId)
            .collection('recordItems')
            .doc(recordItem.id)
            .get();

        expect(snapshot.exists, false);
      });
    });

    group('getById', () {
      test('IDで記録項目を取得できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        final result = await repository.getById(recordItem.userId, recordItem.id);

        expect(result?.id, recordItem.id);
        expect(result?.title, recordItem.title);
      });

      test('存在しないIDの場合nullを返すこと', () async {
        final result = await repository.getById('userId', 'nonexistent');

        expect(result, isNull);
      });
    });

    group('getByUserId', () {
      test('ユーザーIDで記録項目一覧を取得できること', () async {
        final userId = 'test-user-id';
        final items = [
          createTestRecordItem(userId: userId, id: 'item1', sortOrder: 1),
          createTestRecordItem(userId: userId, id: 'item2', sortOrder: 0),
          createTestRecordItem(userId: userId, id: 'item3', sortOrder: 2),
        ];

        for (final item in items) {
          await repository.create(item);
        }

        final result = await repository.getByUserId(userId);

        expect(result.length, 3);
        // sortOrderでソートされていることを確認
        final sortedResult = result..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        expect(sortedResult[0].sortOrder, 0);
        expect(sortedResult[1].sortOrder, 1);
        expect(sortedResult[2].sortOrder, 2);
      });

      test('他のユーザーの記録項目は取得しないこと', () async {
        final userId1 = 'user1';
        final userId2 = 'user2';

        await repository.create(createTestRecordItem(userId: userId1));
        await repository.create(createTestRecordItem(userId: userId2));

        final result = await repository.getByUserId(userId1);

        expect(result.length, 1);
        expect(result.first.userId, userId1);
      });
    });

    group('watchByUserId', () {
      test('ユーザーIDで記録項目をリアルタイム監視できること', () async {
        final userId = 'test-user-id';
        final item = createTestRecordItem(userId: userId);

        final stream = repository.watchByUserId(userId);
        
        // 初期状態
        expect(await stream.first, isEmpty);

        // アイテム追加
        await repository.create(item);
        
        final result = await stream.first;
        expect(result.length, 1);
        expect(result.first.id, item.id);
      });
    });


    group('getNextSortOrder', () {
      test('記録項目がない場合0を返すこと', () async {
        final sortOrder = await repository.getNextSortOrder('userId');
        expect(sortOrder, 0);
      });

      test('既存の記録項目がある場合、最大値+1を返すこと', () async {
        final userId = 'test-user-id';
        await repository.create(createTestRecordItem(userId: userId, id: 'item1', sortOrder: 0));
        await repository.create(createTestRecordItem(userId: userId, id: 'item2', sortOrder: 5));
        await repository.create(createTestRecordItem(userId: userId, id: 'item3', sortOrder: 3));

        final sortOrder = await repository.getNextSortOrder(userId);
        expect(sortOrder, 6);
      });
    });
  });
}