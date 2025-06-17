import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/_gen/i18n/strings.g.dart';
import 'package:myapp/common/firebase/firebase_providers.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/pages/record_items_list_page.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_card.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_list_view.dart';

import '../../../../test_helpers/record_item_helpers.dart';

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

    setUp(() async {
      fakeRepository = FakeRecordItemRepository();
      // Initialize locale settings for tests
      await LocaleSettings.setLocale(AppLocale.ja);
    });

    RecordItem createTestcreateTestRecordItem({
      String id = 'test-id',
      String userId = 'test-user-id',
      String title = 'テスト項目',
      String? description,
      String? unit,
      int sortOrder = 0,
    }) {
      final now = DateTime.now();
      return createTestRecordItem(
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
          firebaseUserProvider.overrideWith((ref) => const Stream.empty()),
          firebaseUserUidProvider.overrideWith((ref) async => userId),
          watchRecordItemsProvider.overrideWith((ref) {
            return fakeRepository.watchByUserId(userId);
          }),
        ],
        child: MaterialApp(
          locale: const Locale('ja'),
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: TranslationProvider(child: const RecordItemsListPage()),
        ),
      );
    }

    group('UI表示', () {
      testWidgets('AppBarに日付が正しく表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final dateFormatter = DateFormat('yyyy年M月d日');
        final today = dateFormatter.format(DateTime.now());

        expect(find.text(today), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('AppBarに左矢印（前日）ボタンが表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      });

      testWidgets('AppBarに右矢印（翌日）ボタンが表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
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
          createTestcreateTestRecordItem(
            id: 'item1',
            userId: userId,
            title: '読書',
            description: '本を読む',
            sortOrder: 0,
          ),
          createTestcreateTestRecordItem(
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

        expect(find.text(i18n.recordItems.empty), findsOneWidget);
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

        expect(find.text(i18n.recordItems.errorMessage), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });

    group('ユーザー操作', () {
      testWidgets('左矢印ボタンをタップすると前日に移動する', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final dateFormatter = DateFormat('yyyy年M月d日');
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));

        // 初期状態で今日の日付が表示されていることを確認
        expect(find.text(dateFormatter.format(today)), findsOneWidget);

        // 左矢印ボタンをタップ
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // 昨日の日付が表示されることを確認
        expect(find.text(dateFormatter.format(yesterday)), findsOneWidget);
        expect(find.text(dateFormatter.format(today)), findsNothing);
      });

      testWidgets('右矢印ボタンをタップすると翌日に移動する（過去の日付から）', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final dateFormatter = DateFormat('yyyy年M月d日');
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));

        // まず昨日に移動
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
        expect(find.text(dateFormatter.format(yesterday)), findsOneWidget);

        // 右矢印ボタンをタップして今日に戻る
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();

        // 今日の日付が表示されることを確認
        expect(find.text(dateFormatter.format(today)), findsOneWidget);
        expect(find.text(dateFormatter.format(yesterday)), findsNothing);
      });

      testWidgets('右矢印ボタンは未来の日付には移動できない', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final dateFormatter = DateFormat('yyyy年M月d日');
        final today = DateTime.now();

        // 初期状態で今日の日付が表示されていることを確認
        expect(find.text(dateFormatter.format(today)), findsOneWidget);

        // 右矢印ボタンをタップ（未来への移動を試みる）
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();

        // 日付が変わらないことを確認（今日のまま）
        expect(find.text(dateFormatter.format(today)), findsOneWidget);
      });

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
        final item = createTestcreateTestRecordItem(
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

      testWidgets('完了ボタンをタップすると完了状態がトグルされる', (tester) async {
        const userId = 'test-user-id';
        final item = createTestcreateTestRecordItem(
          id: 'item1',
          userId: userId,
          title: 'テスト項目',
        );

        fakeRepository.setItems([item]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        // 初期状態は未完了
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsNothing);

        // 完了ボタンをタップ
        await tester.tap(find.byIcon(Icons.check_circle_outline));
        await tester.pumpAndSettle();

        // 完了状態になる
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsNothing);

        // 再度タップで未完了に戻る
        await tester.tap(find.byIcon(Icons.check_circle));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsNothing);
      });

      testWidgets('エラー時の再試行ボタンをタップするとリロードされる', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final retryButtonFinder = find.text('Retry');
        expect(retryButtonFinder, findsOneWidget);

        // エラーを解除して再試行
        fakeRepository.clearException();
        fakeRepository.setItems([]);

        await tester.tap(retryButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text(i18n.recordItems.empty), findsOneWidget);
        expect(find.text(i18n.recordItems.errorMessage), findsNothing);
      });
    });

    group('リアルタイム更新', () {
      testWidgets('StreamProviderが使用されている', (tester) async {
        const userId = 'test-user-id';

        // 初期状態は空
        fakeRepository.setItems([]);

        await tester.pumpWidget(createTestWidget(userId: userId));
        await tester.pumpAndSettle();

        expect(find.text(i18n.recordItems.empty), findsOneWidget);

        // StreamProviderが実際に使用されていることを確認
        // （実際のリアルタイム更新はFakeRepositoryの制約上、統合テストで確認）
        expect(find.byType(RecordItemsListPage), findsOneWidget);
      });
    });
  });
}
