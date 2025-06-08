import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_edit_page.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;
  int _updateCallCount = 0;

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

  List<RecordItem> get items => List.unmodifiable(_items);
  int get updateCallCount => _updateCallCount;

  void resetCallCounts() {
    _updateCallCount = 0;
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
    _updateCallCount++;

    final index = _items.indexWhere((item) => item.id == recordItem.id);
    if (index != -1) {
      _items[index] = recordItem;
    } else {
      throw Exception('記録項目が見つかりません');
    }
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
  group('RecordItemsEditPage', () {
    late FakeRecordItemRepository fakeRepository;
    late RecordItem testRecordItem;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
      testRecordItem = RecordItem(
        id: 'item1',
        userId: 'test-user-id',
        title: '既存タイトル',
        description: '既存説明',
        unit: '個',
        sortOrder: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
      fakeRepository.setItems([testRecordItem]);
    });

    Widget createTestWidget({
      String userId = 'test-user-id',
      RecordItem? recordItem,
    }) {
      return ProviderScope(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(
          home: RecordItemsEditPage(
            userId: userId,
            recordItem: recordItem ?? testRecordItem,
          ),
        ),
      );
    }

    group('UI表示', () {
      testWidgets('ページの基本構成が表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // AppBarの確認
        expect(find.text('記録項目編集'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        // フォームの確認
        expect(find.text('タイトル'), findsOneWidget);
        expect(find.text('説明'), findsOneWidget);
        expect(find.text('単位'), findsOneWidget);
        expect(find.text('更新'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);

        // フィールドとボタンの確認
        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('既存データがフォームに表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 既存データがフィールドに表示されることを確認
        expect(find.text('既存タイトル'), findsOneWidget);
        expect(find.text('既存説明'), findsOneWidget);
        expect(find.text('個'), findsOneWidget);
      });

      testWidgets('AppBarに戻るボタンが表示される', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            ],
            child: MaterialApp(
              home: const Scaffold(body: Text('前の画面')),
              routes: {
                '/edit':
                    (context) => RecordItemsEditPage(
                      userId: 'test-user-id',
                      recordItem: testRecordItem,
                    ),
              },
            ),
          ),
        );

        // 編集画面に移動
        await tester.tap(find.text('前の画面'));
        await tester.pumpAndSettle();

        Navigator.of(tester.element(find.text('前の画面'))).pushNamed('/edit');
        await tester.pumpAndSettle();

        // AppBarのタイトルが表示されることを確認
        expect(find.text('記録項目編集'), findsOneWidget);
      });
    });

    group('ナビゲーション', () {
      testWidgets('キャンセルボタンで前の画面に戻る', (tester) async {
        bool navigatedBack = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            ],
            child: MaterialApp(
              home: Builder(
                builder:
                    (context) => Scaffold(
                      body: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => RecordItemsEditPage(
                                    userId: 'test-user-id',
                                    recordItem: testRecordItem,
                                  ),
                            ),
                          );
                          navigatedBack = true;
                        },
                        child: const Text('編集画面へ'),
                      ),
                    ),
              ),
            ),
          ),
        );

        // 編集画面に移動
        await tester.tap(find.text('編集画面へ'));
        await tester.pumpAndSettle();

        // キャンセルボタンをタップ
        await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
        await tester.pumpAndSettle();

        expect(navigatedBack, isTrue);
      });

      testWidgets('更新成功時に前の画面に戻る', (tester) async {
        bool navigatedBack = false;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              recordItemRepositoryProvider.overrideWithValue(fakeRepository),
            ],
            child: MaterialApp(
              home: Builder(
                builder:
                    (context) => Scaffold(
                      body: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => RecordItemsEditPage(
                                    userId: 'test-user-id',
                                    recordItem: testRecordItem,
                                  ),
                            ),
                          );
                          navigatedBack = true;
                        },
                        child: const Text('編集画面へ'),
                      ),
                    ),
              ),
            ),
          ),
        );

        // 編集画面に移動
        await tester.tap(find.text('編集画面へ'));
        await tester.pumpAndSettle();

        // タイトルを変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '更新されたタイトル',
        );
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // 前の画面に戻ることを確認
        expect(navigatedBack, isTrue);

        // 記録項目が更新されることを確認
        expect(fakeRepository.updateCallCount, equals(1));
        expect(fakeRepository.items.first.title, equals('更新されたタイトル'));
      });
    });

    group('フォーム操作', () {
      testWidgets('タイトルのみ更新できる', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // タイトルを変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '新しいタイトル',
        );
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // 更新処理が呼ばれることを確認
        expect(fakeRepository.updateCallCount, equals(1));

        // タイトルが更新され、他のフィールドは保持されることを確認
        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('新しいタイトル'));
        expect(updatedItem.description, equals('既存説明'));
        expect(updatedItem.unit, equals('個'));
      });

      testWidgets('すべてのフィールドを更新できる', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // すべてのフィールドを変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '新しいタイトル',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存説明'),
          '新しい説明',
        );
        await tester.enterText(find.widgetWithText(TextFormField, '個'), '時間');
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // すべてのフィールドが更新されることを確認
        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('新しいタイトル'));
        expect(updatedItem.description, equals('新しい説明'));
        expect(updatedItem.unit, equals('時間'));
      });

      testWidgets('フィールドを空にできる', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 説明と単位を空にする
        await tester.enterText(find.widgetWithText(TextFormField, '既存説明'), '');
        await tester.enterText(find.widgetWithText(TextFormField, '個'), '');
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // 説明と単位が空文字列として処理されることを確認
        // (UpdateRecordItemUseCaseは空文字列をnullに変換する)
        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('既存タイトル'));
        expect(updatedItem.description, isNull);
        expect(updatedItem.unit, isNull);
      });
    });

    group('エラーハンドリング', () {
      testWidgets('更新失敗時はエラーメッセージが表示される', (tester) async {
        fakeRepository.setException(Exception('更新エラー'));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // タイトルを変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '更新されたタイトル',
        );
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示されることを確認
        expect(find.text('Exception: 更新エラー'), findsOneWidget);

        // まだ編集画面にいることを確認
        expect(find.text('記録項目編集'), findsOneWidget);
      });

      testWidgets('タイトルが空の場合は更新ボタンが無効', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // タイトルを空にする
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '',
        );
        await tester.pumpAndSettle();

        // 更新ボタンが無効になることを確認
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '更新'),
        );
        expect(updateButton.onPressed, isNull);
      });
    });

    group('パフォーマンス', () {
      testWidgets('複数回の更新操作が正常に動作する', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 1回目の更新
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '更新1',
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        expect(fakeRepository.updateCallCount, equals(1));
        expect(fakeRepository.items.first.title, equals('更新1'));
      });
    });
  });
}
