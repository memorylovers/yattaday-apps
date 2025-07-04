import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/common/providers/firebase_providers.dart';
import 'package:myapp/features/record_items/3_store/record_items_store.dart';

import '../../../../test_helpers/fixtures/record_item_helpers.dart';

void main() {
  group('RecordItemsStore', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      // Fake Firestoreを作成
      fakeFirestore = FakeFirebaseFirestore();
      
      // ProviderContainerを作成し、FirebaseプロバイダーをオーバーライドDFree
      container = ProviderContainer(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('recordItemRepositoryProvider', () {
      test('FirebaseRecordItemRepositoryが正しく作成される', () {
        final repository = container.read(recordItemRepositoryProvider);
        expect(repository, isNotNull);
      });
    });

    group('recordItemHistoryRepositoryProvider', () {
      test('FirebaseRecordItemHistoryRepositoryが正しく作成される', () {
        final repository = container.read(recordItemHistoryRepositoryProvider);
        expect(repository, isNotNull);
      });
    });

    group('recordItemsProvider', () {
      test('指定したユーザーの記録項目一覧を取得できる', () async {
        // テストデータを準備
        final items = [
          createTestRecordItem(id: 'id1', userId: 'test-user-id', sortOrder: 0),
          createTestRecordItem(id: 'id2', userId: 'test-user-id', sortOrder: 1),
          createTestRecordItem(id: 'id3', userId: 'other-user-id', sortOrder: 0),
        ];
        
        // Firestoreにデータを追加
        for (final item in items) {
          await fakeFirestore
              .collection('users')
              .doc(item.userId)
              .collection('recordItems')
              .doc(item.id)
              .set(item.toJson());
        }
        
        // プロバイダーを実行
        final result = await container.read(
          recordItemsProvider('test-user-id').future,
        );
        
        // 検証
        expect(result.length, 2);
        expect(result[0].id, 'id1');
        expect(result[1].id, 'id2');
      });

      test('記録項目がない場合は空のリストを返す', () async {
        final result = await container.read(
          recordItemsProvider('empty-user-id').future,
        );
        
        expect(result, isEmpty);
      });
    });

    group('リファクタリングの効果', () {
      test('Firestoreインスタンスを差し替えてテストできることを確認', () {
        // これは概念的なテストです
        // firebaseFirestoreProviderをオーバーライドすることで、
        // 本番環境のFirestoreではなくFakeFirestoreを使用してテストできます
        
        // リファクタリング前は FirebaseFirestore.instance が
        // ハードコーディングされていたため、このようなテストは不可能でした
        
        expect(container.read(firebaseFirestoreProvider), same(fakeFirestore));
      });
    });
  });
}