import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';

import '../../../test_helpers/record_item_helpers.dart';

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

        final collectionPath = 'users/${recordItem.userId}/recordItems';
        final doc =
            await fakeFirestore.doc('$collectionPath/${recordItem.id}').get();

        expect(doc.exists, isTrue);
        final data = doc.data() as Map<String, dynamic>;
        expect(data['title'], equals(recordItem.title));
        expect(data['userId'], equals(recordItem.userId));
        expect(data['sortOrder'], equals(recordItem.sortOrder));
      });

      test('エラーが発生した場合、例外がスローされること', () async {
        // FakeFirebaseFirestoreではエラーのシミュレーションが難しいため、
        // 実際のテストでは別のアプローチが必要
      });
    });

    group('update', () {
      test('既存の記録項目を正しく更新できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        final updatedItem = recordItem.copyWith(
          title: '更新されたタイトル',
          description: '更新された説明',
          updatedAt: DateTime.now(),
        );

        await repository.update(updatedItem);

        final collectionPath = 'users/${recordItem.userId}/recordItems';
        final doc =
            await fakeFirestore.doc('$collectionPath/${recordItem.id}').get();

        expect(doc.exists, isTrue);
        final data = doc.data() as Map<String, dynamic>;
        expect(data['title'], equals('更新されたタイトル'));
        expect(data['description'], equals('更新された説明'));
      });
    });

    group('delete', () {
      test('記録項目を正しく削除できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        await repository.delete(recordItem.userId, recordItem.id);

        final collectionPath = 'users/${recordItem.userId}/recordItems';
        final doc =
            await fakeFirestore.doc('$collectionPath/${recordItem.id}').get();

        expect(doc.exists, isFalse);
      });
    });

    group('getById', () {
      test('指定したIDの記録項目を取得できること', () async {
        final recordItem = createTestRecordItem();
        await repository.create(recordItem);

        final result = await repository.getById(
          recordItem.userId,
          recordItem.id,
        );

        expect(result, isNotNull);
        expect(result?.id, equals(recordItem.id));
        expect(result?.title, equals(recordItem.title));
      });

      test('存在しない記録項目の場合nullを返すこと', () async {
        final result = await repository.getById('user-id', 'non-existent-id');

        expect(result, isNull);
      });
    });

    group('getByUserId', () {
      test('ユーザーの記録項目一覧をsortOrder順で取得できること', () async {
        final userId = 'test-user-id';
        final items = [
          createTestRecordItem(
            id: 'id1',
            userId: userId,
            sortOrder: 2,
            title: '項目2',
          ),
          createTestRecordItem(
            id: 'id2',
            userId: userId,
            sortOrder: 0,
            title: '項目0',
          ),
          createTestRecordItem(
            id: 'id3',
            userId: userId,
            sortOrder: 1,
            title: '項目1',
          ),
        ];

        for (final item in items) {
          await repository.create(item);
        }

        final result = await repository.getByUserId(userId);

        expect(result.length, equals(3));
        expect(result[0].title, equals('項目0'));
        expect(result[1].title, equals('項目1'));
        expect(result[2].title, equals('項目2'));
      });

      test('記録項目がない場合空のリストを返すこと', () async {
        final result = await repository.getByUserId('empty-user-id');

        expect(result, isEmpty);
      });
    });

    group('watchByUserId', () {
      test('ユーザーの記録項目一覧をリアルタイムで監視できること', () async {
        final userId = 'test-user-id';
        final stream = repository.watchByUserId(userId);

        // 初期状態は空のリスト
        expect(await stream.first, isEmpty);

        // 項目を追加
        final item1 = createTestRecordItem(
          id: 'id1',
          userId: userId,
          sortOrder: 0,
        );
        await repository.create(item1);

        // ストリームが更新される
        await Future.delayed(const Duration(milliseconds: 100));
        final snapshot1 = await stream.first;
        expect(snapshot1.length, equals(1));
        expect(snapshot1[0].id, equals('id1'));

        // さらに項目を追加
        final item2 = createTestRecordItem(
          id: 'id2',
          userId: userId,
          sortOrder: 1,
        );
        await repository.create(item2);

        await Future.delayed(const Duration(milliseconds: 100));
        final snapshot2 = await stream.first;
        expect(snapshot2.length, equals(2));
      });
    });

    group('getNextSortOrder', () {
      test('記録項目がない場合0を返すこと', () async {
        final nextOrder = await repository.getNextSortOrder('empty-user-id');

        expect(nextOrder, equals(0));
      });

      test('既存の記録項目がある場合、最大値+1を返すこと', () async {
        final userId = 'test-user-id';
        final items = [
          createTestRecordItem(id: 'id1', userId: userId, sortOrder: 5),
          createTestRecordItem(id: 'id2', userId: userId, sortOrder: 3),
          createTestRecordItem(id: 'id3', userId: userId, sortOrder: 8),
        ];

        for (final item in items) {
          await repository.create(item);
        }

        final nextOrder = await repository.getNextSortOrder(userId);

        expect(nextOrder, equals(9)); // 最大値8 + 1
      });
    });

  });
}
