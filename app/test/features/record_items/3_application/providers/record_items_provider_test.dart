import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/services/firebase/auth_service.dart';
import 'package:myapp/features/record_items/3_application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';

import '../../../../test_helpers/fake_record_item_repository.dart';
import '../../../../test_helpers/record_item_helpers.dart';

void main() {
  group('RecordItemsProvider', () {
    late ProviderContainer container;
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      container = ProviderContainer(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('recordItemsProvider', () {
      test('ユーザーの記録項目一覧を正常に取得できる', () async {
        // Arrange
        const userId = 'user123';
        final expectedItems = [
          createTestRecordItem(
            id: 'item1',
            userId: userId,
            title: '読書',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          createTestRecordItem(
            id: 'item2',
            userId: userId,
            title: '運動',
            sortOrder: 1,
            createdAt: DateTime(2024, 1, 2),
            updatedAt: DateTime(2024, 1, 2),
          ),
        ];

        fakeRepository.setItems(expectedItems);

        // Act
        final result = await container.read(recordItemsProvider(userId).future);

        // Assert
        expect(result, equals(expectedItems));
      });

      test('空のリストを正常に取得できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Act
        final result = await container.read(recordItemsProvider(userId).future);

        // Assert
        expect(result, isEmpty);
      });

      test('異なるユーザーIDでフィルタリングされる', () async {
        // Arrange
        const userId1 = 'user1';
        const userId2 = 'user2';
        final allItems = [
          createTestRecordItem(
            id: 'item1',
            userId: userId1,
            title: 'ユーザー1の項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          createTestRecordItem(
            id: 'item2',
            userId: userId2,
            title: 'ユーザー2の項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 2),
            updatedAt: DateTime(2024, 1, 2),
          ),
        ];

        fakeRepository.setItems(allItems);

        // Act
        final result1 = await container.read(
          recordItemsProvider(userId1).future,
        );
        final result2 = await container.read(
          recordItemsProvider(userId2).future,
        );

        // Assert
        expect(result1.length, equals(1));
        expect(result1[0].title, equals('ユーザー1の項目'));
        expect(result2.length, equals(1));
        expect(result2[0].title, equals('ユーザー2の項目'));
      });

      test('エラーが発生した場合例外がスローされる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () async => await container.read(recordItemsProvider(userId).future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('watchRecordItemsProvider', () {
      test('記録項目一覧の変更をリアルタイムで監視できる', () async {
        // Arrange
        const userId = 'user123';
        final initialItems = [
          createTestRecordItem(
            id: 'item1',
            userId: userId,
            title: '初期項目',
            sortOrder: 0,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        fakeRepository.setItems(initialItems);

        // Firebase関連のプロバイダーをオーバーライド
        container = ProviderContainer(
          overrides: [
            recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
            firebaseUserUidProvider.overrideWith((ref) async => userId),
          ],
        );

        // Act
        final result = await container.read(watchRecordItemsProvider.future);

        // Assert
        expect(result, equals(initialItems));
      });

      test('空のリストのStreamを監視できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setItems(<RecordItem>[]);

        // Firebase関連のプロバイダーをオーバーライド
        container = ProviderContainer(
          overrides: [
            recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
            firebaseUserUidProvider.overrideWith((ref) async => userId),
          ],
        );

        // Act
        final result = await container.read(watchRecordItemsProvider.future);

        // Assert
        expect(result, isEmpty);
      });

      test('エラーStreamを正しく処理できる', () async {
        // Arrange
        const userId = 'user123';
        fakeRepository.setException(Exception('Network error'));

        // Firebase関連のプロバイダーをオーバーライド
        container = ProviderContainer(
          overrides: [
            recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
            firebaseUserUidProvider.overrideWith((ref) async => userId),
          ],
        );

        // Act & Assert
        expect(
          () async => await container.read(watchRecordItemsProvider.future),
          throwsA(isA<Exception>()),
        );
      });

      test('未認証の場合は空のリストを返す', () async {
        // Arrange
        // Firebase関連のプロバイダーがnullを返すようにオーバーライド
        container = ProviderContainer(
          overrides: [
            recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
            firebaseUserUidProvider.overrideWith((ref) async => null),
          ],
        );

        // Act
        final result = await container.read(watchRecordItemsProvider.future);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
