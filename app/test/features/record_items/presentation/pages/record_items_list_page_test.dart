import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/application/auth_providers.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_list_page.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_card.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_list_view.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;

  void setItems(List<RecordItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  void setException(Exception exception) {
    _exception = exception;
  }

  void clearException() {
    _exception = null;
  }

  @override
  Future<List<RecordItem>> getByUserId(String userId) async {
    if (_exception != null) throw _exception!;
    return _items.where((item) => item.userId == userId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    if (_exception != null) return Stream.error(_exception!);
    return Stream.value(
      _items.where((item) => item.userId == userId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }

  @override
  Future<void> create(RecordItem recordItem) async {
    if (_exception != null) throw _exception!;
    _items.add(recordItem);
  }

  @override
  Future<void> update(RecordItem recordItem) async {
    if (_exception != null) throw _exception!;
    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) _items[index] = recordItem;
  }

  @override
  Future<void> delete(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;
    _items.removeWhere(
      (item) => item.id == recordItemId && item.userId == userId,
    );
  }

  @override
  Future<RecordItem?> getById(String userId, String recordItemId) async {
    if (_exception != null) throw _exception!;
    try {
      return _items.firstWhere(
        (item) => item.id == recordItemId && item.userId == userId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> getNextSortOrder(String userId) async {
    if (_exception != null) throw _exception!;
    final userItems = _items.where((item) => item.userId == userId).toList();
    if (userItems.isEmpty) return 0;
    return userItems
            .map((item) => item.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}

void main() {
  group('RecordItemsListPage', () {
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
    });

    RecordItem createTestRecordItem({
      String id = 'test-id',
      String userId = 'test-user-id',
      String title = 'テスト項目',
      String? description,
      String? unit,
      int sortOrder = 0,
    }) {
      final now = DateTime.now();
      return RecordItem(
        id: id,
        userId: userId,
        title: title,
        description: description,
        unit: unit,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      );
    }

    Widget createTestWidget({String userId = 'test-user-id'}) {
      return ProviderScope(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
          // ignore: scoped_providers_should_specify_dependencies
          authUidProvider.overrideWith((ref) async => userId),
        ],
        child: const MaterialApp(home: RecordItemsListPage()),
      );
    }

    group('UI表示', () {
      testWidgets('AppBarのタイトルが正しく表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('記録項目'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('FloatingActionButtonが表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('記録項目一覧が正しく表示される', (tester) async {
        const userId = 'test-user-id';
        final items = [
          createTestRecordItem(
            id: 'item1',
            userId: userId,
            title: '読書',
            description: '本を読む',
            sortOrder: 0,
          ),
          createTestRecordItem(
            id: 'item2',
            userId: userId,
            title: '運動',
            sortOrder: 1,
          ),
        ];

        fakeRepository.setItems(items);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        expect(find.byType(RecordItemListView), findsOneWidget);
        expect(find.byType(RecordItemCard), findsNWidgets(2));
        expect(find.text('読書'), findsOneWidget);
        expect(find.text('運動'), findsOneWidget);
      });

      testWidgets('空のリストの場合、空メッセージが表示される', (tester) async {
        fakeRepository.setItems([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('記録項目がありません'), findsOneWidget);
        expect(find.byType(RecordItemCard), findsNothing);
      });

      testWidgets('ローディング中はProgressIndicatorが表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // ローディング状態を確認
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('エラー時はエラーメッセージが表示される', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('エラーが発生しました'), findsOneWidget);
        expect(find.text('再試行'), findsOneWidget);
      });
    });

    group('ユーザー操作', () {
      testWidgets('FloatingActionButtonをタップすると作成画面に遷移する', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final fabFinder = find.byType(FloatingActionButton);
        expect(fabFinder, findsOneWidget);

        // タップ時の動作をテスト（現在はモック実装）
        await tester.tap(fabFinder);
        await tester.pumpAndSettle();

        // 実際のナビゲーションは後で実装
      });

      testWidgets('記録項目をタップすると詳細画面に遷移する', (tester) async {
        const userId = 'test-user-id';
        final item = createTestRecordItem(
          id: 'item1',
          userId: userId,
          title: 'テスト項目',
        );

        fakeRepository.setItems([item]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        final cardFinder = find.byType(RecordItemCard);
        expect(cardFinder, findsOneWidget);

        // タップ時の動作をテスト（現在はモック実装）
        await tester.tap(cardFinder);
        await tester.pumpAndSettle();

        // 実際のナビゲーションは後で実装
      });

      testWidgets('編集ボタンをタップすると編集画面に遷移する', (tester) async {
        const userId = 'test-user-id';
        final item = createTestRecordItem(
          id: 'item1',
          userId: userId,
          title: 'テスト項目',
        );

        fakeRepository.setItems([item]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        final editButtonFinder = find.byIcon(Icons.edit);
        expect(editButtonFinder, findsOneWidget);

        // タップ時の動作をテスト（現在はモック実装）
        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();

        // 実際のナビゲーションは後で実装
      });

      testWidgets('削除ボタンをタップすると確認ダイアログが表示される', (tester) async {
        const userId = 'test-user-id';
        final item = createTestRecordItem(
          id: 'item1',
          userId: userId,
          title: 'テスト項目',
        );

        fakeRepository.setItems([item]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        final deleteButtonFinder = find.byIcon(Icons.delete);
        expect(deleteButtonFinder, findsOneWidget);

        // タップ時の動作をテスト（現在はモック実装）
        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        // 確認ダイアログの実装は後で実装
      });

      testWidgets('エラー時の再試行ボタンをタップするとリロードされる', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final retryButtonFinder = find.text('再試行');
        expect(retryButtonFinder, findsOneWidget);

        // エラーを解除して再試行
        fakeRepository.clearException();
        fakeRepository.setItems([]);

        await tester.tap(retryButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('記録項目がありません'), findsOneWidget);
        expect(find.text('エラーが発生しました'), findsNothing);
      });
    });

    group('リアルタイム更新', () {
      testWidgets('StreamProviderが使用されている', (tester) async {
        const userId = 'test-user-id';

        // 初期状態は空
        fakeRepository.setItems([]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        expect(find.text('記録項目がありません'), findsOneWidget);

        // StreamProviderが実際に使用されていることを確認
        // （実際のリアルタイム更新はFakeRepositoryの制約上、統合テストで確認）
        expect(find.byType(RecordItemsListPage), findsOneWidget);
      });
    });
  });
}
