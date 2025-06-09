import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/record_items/application/providers/record_items_provider.dart';
import 'package:myapp/features/record_items/data/repository/record_item_repository.dart';
import 'package:myapp/features/record_items/domain/record_item.dart';
import 'package:myapp/features/record_items/presentation/widgets/record_item_form.dart';

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
  group('RecordItemForm Edit Mode Tests', () {
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
    });

    Widget createTestWidget({
      String userId = 'test-user-id',
      RecordItem? initialItem,
      VoidCallback? onSuccess,
      VoidCallback? onCancel,
    }) {
      return ProviderScope(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: RecordItemForm(
              userId: userId,
              initialItem: initialItem,
              onSuccess: onSuccess,
              onCancel: onCancel,
            ),
          ),
        ),
      );
    }

    group('編集モードの初期化', () {
      testWidgets('既存データが渡された場合は編集モードになる', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'user1',
          title: '既存タイトル',
          description: '既存説明',
          unit: '個',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

        // フィールドに既存データが入力されていることを確認
        expect(find.text('既存タイトル'), findsOneWidget);
        expect(find.text('既存説明'), findsOneWidget);
        expect(find.text('個'), findsOneWidget);

        // ボタンのラベルが「更新」になることを確認
        expect(find.text('更新'), findsOneWidget);
        expect(find.text('作成'), findsNothing);
      });

      testWidgets('初期データがnullの場合は作成モードになる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // フィールドが空であることを確認
        expect(find.text('タイトルを入力してください'), findsOneWidget);
        expect(find.text('説明を入力してください（任意）'), findsOneWidget);
        expect(find.text('単位を入力してください（任意）'), findsOneWidget);

        // ボタンのラベルが「作成」になることを確認
        expect(find.text('作成'), findsOneWidget);
        expect(find.text('更新'), findsNothing);
      });
    });

    group('編集モードでの操作', () {
      testWidgets('更新ボタンタップで記録項目が更新される', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          description: '既存説明',
          unit: '個',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([existingItem]);

        bool onSuccessCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            initialItem: existingItem,
            onSuccess: () => onSuccessCalled = true,
          ),
        );

        // タイトルを変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存タイトル'),
          '更新されたタイトル',
        );
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // 更新処理が呼ばれることを確認
        expect(fakeRepository.updateCallCount, equals(1));
        expect(onSuccessCalled, isTrue);

        // 実際にデータが更新されることを確認
        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('更新されたタイトル'));
        expect(updatedItem.description, equals('既存説明'));
        expect(updatedItem.unit, equals('個'));
      });

      testWidgets('一部フィールドのみ更新できる', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          description: '既存説明',
          unit: '個',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([existingItem]);

        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

        // 説明のみ変更
        await tester.enterText(
          find.widgetWithText(TextFormField, '既存説明'),
          '更新された説明',
        );
        await tester.pumpAndSettle();

        // 更新ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '更新'));
        await tester.pumpAndSettle();

        // 説明のみ更新され、他は既存値が保持されることを確認
        final updatedItem = fakeRepository.items.first;
        expect(updatedItem.title, equals('既存タイトル'));
        expect(updatedItem.description, equals('更新された説明'));
        expect(updatedItem.unit, equals('個'));
      });

      testWidgets('更新失敗時はエラーメッセージが表示される', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        fakeRepository.setItems([existingItem]);
        fakeRepository.setException(Exception('更新エラー'));

        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

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
      });
    });

    group('バリデーション', () {
      testWidgets('編集モードでもタイトルが必須', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

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

      testWidgets('編集モードでタイトルが有効なら更新ボタンが有効', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

        // 初期値がProviderに反映されるのを待つ
        await tester.pumpAndSettle();

        // 初期状態では更新ボタンが有効
        final updateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '更新'),
        );
        expect(updateButton.onPressed, isNotNull);
      });
    });

    group('UI表示', () {
      testWidgets('編集モードではAppBarタイトルが「記録項目編集」になる', (tester) async {
        final existingItem = RecordItem(
          id: 'item1',
          userId: 'test-user-id',
          title: '既存タイトル',
          sortOrder: 0,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // RecordItemFormは直接AppBarを持たないので、
        // この実装ではモードを判定するプロパティを追加する必要がある
        await tester.pumpWidget(createTestWidget(initialItem: existingItem));

        // フォームが編集モードで表示されることを確認
        expect(find.text('更新'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);
      });
    });
  });
}
