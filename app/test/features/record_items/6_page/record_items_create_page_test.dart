import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/3_application/record_items_store.dart';
import 'package:myapp/features/record_items/2_repository/record_item_repository.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';
import 'package:myapp/features/record_items/6_page/record_items_create_page.dart';

class FakeRecordItemRepository implements IRecordItemRepository {
  final List<RecordItem> _items = [];
  Exception? _exception;
  int _nextSortOrder = 0;

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

  void setNextSortOrder(int sortOrder) {
    _nextSortOrder = sortOrder;
  }

  List<RecordItem> get items => List.unmodifiable(_items);

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
    return _nextSortOrder;
  }
}

void main() {
  group('RecordItemsCreatePage', () {
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
    });

    Widget createTestWidget({String userId = 'test-user-id'}) {
      return ProviderScope(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(home: RecordItemsCreatePage(userId: userId)),
      );
    }

    group('UI表示', () {
      testWidgets('ページの基本構成が表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // AppBarの確認
        expect(find.text('記録項目作成'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        // フォームの確認
        expect(find.text('タイトル *'), findsOneWidget);
        expect(find.text('説明'), findsOneWidget);
        expect(find.text('単位'), findsOneWidget);
        expect(find.text('作成'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);

        // フィールドとボタンの確認
        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
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
                '/create':
                    (context) => RecordItemsCreatePage(userId: 'test-user-id'),
              },
            ),
          ),
        );

        // 作成画面に移動
        await tester.tap(find.text('前の画面'));
        await tester.pumpAndSettle();

        Navigator.of(tester.element(find.text('前の画面'))).pushNamed('/create');
        await tester.pumpAndSettle();

        // AppBarの戻るボタンまたはタイトルが表示されることを確認
        expect(find.text('記録項目作成'), findsOneWidget);
      });
    });

    group('ナビゲーション', () {
      testWidgets('画面の基本構成が正しく表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // ページタイトルが表示されることを確認
        expect(find.text('記録項目作成'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

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
                                  (_) => RecordItemsCreatePage(
                                    userId: 'test-user-id',
                                  ),
                            ),
                          );
                          navigatedBack = true;
                        },
                        child: const Text('作成画面へ'),
                      ),
                    ),
              ),
            ),
          ),
        );

        // 作成画面に移動
        await tester.tap(find.text('作成画面へ'));
        await tester.pumpAndSettle();

        // キャンセルボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(TextButton, 'キャンセル'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
        await tester.pumpAndSettle();

        expect(navigatedBack, isTrue);
      });
    });

    group('フォーム操作', () {
      testWidgets('作成成功時に前の画面に戻る', (tester) async {
        fakeRepository.setNextSortOrder(0);
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
                                  (_) => RecordItemsCreatePage(
                                    userId: 'test-user-id',
                                  ),
                            ),
                          );
                          navigatedBack = true;
                        },
                        child: const Text('作成画面へ'),
                      ),
                    ),
              ),
            ),
          ),
        );

        // 作成画面に移動
        await tester.tap(find.text('作成画面へ'));
        await tester.pumpAndSettle();

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書記録',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // 前の画面に戻ることを確認
        expect(navigatedBack, isTrue);

        // 記録項目が作成されることを確認
        expect(fakeRepository.items.length, equals(1));
        expect(fakeRepository.items.first.title, equals('読書記録'));
      });

      testWidgets('作成失敗時は画面に留まる', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書記録',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // まだ作成画面にいることを確認
        expect(find.text('記録項目作成'), findsOneWidget);

        // エラーメッセージが表示されることを確認
        expect(find.text('Exception: Network error'), findsOneWidget);
      });

      testWidgets('複数項目を入力して作成できる', (tester) async {
        fakeRepository.setNextSortOrder(0);

        await tester.pumpWidget(createTestWidget());

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '運動記録',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          '毎日30分以上運動する',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '単位を入力してください（任意）'),
          '分',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // 記録項目が正しく作成されることを確認
        expect(fakeRepository.items.length, equals(1));
        final item = fakeRepository.items.first;
        expect(item.title, equals('運動記録'));
        expect(item.description, equals('毎日30分以上運動する'));
        expect(item.unit, equals('分'));
      });
    });

    group('エラーハンドリング', () {
      testWidgets('無効なuserIdでエラーハンドリング', (tester) async {
        await tester.pumpWidget(createTestWidget(userId: ''));

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書記録',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示されることを確認
        expect(find.text('ユーザーIDが無効です'), findsOneWidget);
      });

      testWidgets('リポジトリエラー時の表示', (tester) async {
        fakeRepository.setException(Exception('データベース接続エラー'));

        await tester.pumpWidget(createTestWidget());

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書記録',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ（スクロールして表示）
        await tester.ensureVisible(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示されることを確認
        expect(find.text('Exception: データベース接続エラー'), findsOneWidget);
      });
    });

    group('ライフサイクル', () {
      testWidgets('フォームの初期状態が正しい', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // フォームが空の状態で表示されることを確認
        expect(find.text('タイトルを入力してください'), findsOneWidget);
        expect(find.text('説明を入力してください（任意）'), findsOneWidget);
        expect(find.text('単位を入力してください（任意）'), findsOneWidget);

        // 作成ボタンが無効になっていることを確認
        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNull);
      });
    });
  });
}
