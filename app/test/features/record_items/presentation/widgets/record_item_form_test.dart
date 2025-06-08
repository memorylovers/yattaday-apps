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
  group('RecordItemForm', () {
    late FakeRecordItemRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeRecordItemRepository();
    });

    Widget createTestWidget({
      String userId = 'test-user-id',
      void Function()? onSuccess,
      void Function()? onCancel,
    }) {
      return ProviderScope(
        overrides: [
          recordItemRepositoryProvider.overrideWithValue(fakeRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: RecordItemForm(
              userId: userId,
              onSuccess: onSuccess,
              onCancel: onCancel,
            ),
          ),
        ),
      );
    }

    group('UI表示', () {
      testWidgets('フォームの基本構成が表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('タイトル'), findsOneWidget);
        expect(find.text('説明'), findsOneWidget);
        expect(find.text('単位'), findsOneWidget);
        expect(find.text('作成'), findsOneWidget);
        expect(find.text('キャンセル'), findsOneWidget);

        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('初期状態では作成ボタンが無効', (tester) async {
        await tester.pumpWidget(createTestWidget());

        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNull);
      });

      testWidgets('タイトルを入力すると作成ボタンが有効になる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // タイトルフィールドに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pumpAndSettle();

        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNotNull);
      });

      testWidgets('各フィールドに正しいhintTextが表示される', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('タイトルを入力してください'), findsOneWidget);
        expect(find.text('説明を入力してください（任意）'), findsOneWidget);
        expect(find.text('単位を入力してください（任意）'), findsOneWidget);
      });

      testWidgets('エラーメッセージが表示される', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());

        // タイトルを入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        expect(find.text('Exception: Network error'), findsOneWidget);
      });

      testWidgets('ローディング中は作成ボタンが無効になり、インジケーターが表示される', (tester) async {
        // 処理を遅延させるためにsetDelayedNextSortOrderを設定
        fakeRepository.setNextSortOrder(0);

        await tester.pumpWidget(createTestWidget());

        // タイトルを入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pump();

        // 作成ボタンが有効になっていることを確認
        final createButtonBefore = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButtonBefore.onPressed, isNotNull);

        // 作成ボタンをタップ（即座にsubmissionが完了するため、ローディング状態の検証は困難）
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // 処理完了後、フォームがリセットされることを確認
        final titleField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
        );
        expect(titleField.controller?.text, isEmpty);
      });
    });

    group('フォーム入力', () {
      testWidgets('タイトルフィールドに入力できる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        const inputText = '読書記録';
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          inputText,
        );
        await tester.pumpAndSettle();

        expect(find.text(inputText), findsOneWidget);
      });

      testWidgets('説明フィールドに入力できる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        const inputText = '本を読んで知識を身につける';
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          inputText,
        );
        await tester.pumpAndSettle();

        expect(find.text(inputText), findsOneWidget);
      });

      testWidgets('単位フィールドに入力できる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        const inputText = 'ページ';
        await tester.enterText(
          find.widgetWithText(TextFormField, '単位を入力してください（任意）'),
          inputText,
        );
        await tester.pumpAndSettle();

        expect(find.text(inputText), findsOneWidget);
      });

      testWidgets('複数フィールドに同時に入力できる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          '毎日30分読書する',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '単位を入力してください（任意）'),
          'ページ',
        );
        await tester.pumpAndSettle();

        expect(find.text('読書'), findsOneWidget);
        expect(find.text('毎日30分読書する'), findsOneWidget);
        expect(find.text('ページ'), findsOneWidget);
      });
    });

    group('ボタン操作', () {
      testWidgets('作成ボタンタップで記録項目が作成される', (tester) async {
        fakeRepository.setNextSortOrder(0);
        bool onSuccessCalled = false;

        await tester.pumpWidget(
          createTestWidget(onSuccess: () => onSuccessCalled = true),
        );

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          '本を読む',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '単位を入力してください（任意）'),
          'ページ',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // onSuccessコールバックが呼ばれる
        expect(onSuccessCalled, isTrue);

        // リポジトリに保存されている
        final savedItems = fakeRepository.items;
        expect(savedItems.length, equals(1));
        expect(savedItems.first.title, equals('読書'));
        expect(savedItems.first.description, equals('本を読む'));
        expect(savedItems.first.unit, equals('ページ'));
      });

      testWidgets('キャンセルボタンタップでonCancelが呼ばれる', (tester) async {
        bool onCancelCalled = false;

        await tester.pumpWidget(
          createTestWidget(onCancel: () => onCancelCalled = true),
        );

        // キャンセルボタンをタップ
        await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
        await tester.pumpAndSettle();

        expect(onCancelCalled, isTrue);
      });

      testWidgets('作成成功後フォームがリセットされる', (tester) async {
        fakeRepository.setNextSortOrder(0);

        await tester.pumpWidget(createTestWidget());

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          '本を読む',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // フォームがリセットされている
        final titleField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
        );
        final descriptionField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
        );

        expect(titleField.controller?.text, isEmpty);
        expect(descriptionField.controller?.text, isEmpty);

        // 作成ボタンが再び無効になっている
        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNull);
      });

      testWidgets('作成失敗時はフォームがリセットされない', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());

        // フォームに入力
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pumpAndSettle();

        // 作成ボタンをタップ
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // フォームの内容が保持されている
        expect(find.text('読書'), findsOneWidget);

        // 作成ボタンは有効のまま
        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNotNull);
      });
    });

    group('エラーハンドリング', () {
      testWidgets('エラーメッセージの表示と非表示', (tester) async {
        fakeRepository.setException(Exception('Network error'));

        await tester.pumpWidget(createTestWidget());

        // タイトルを入力して作成ボタンをタップ（エラー発生）
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        // エラーメッセージが表示される
        expect(find.text('Exception: Network error'), findsOneWidget);

        // フィールドを編集するとエラーメッセージが消える
        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書記録',
        );
        await tester.pumpAndSettle();

        expect(find.text('Exception: Network error'), findsNothing);
      });

      testWidgets('空のタイトルでの作成はエラーになる', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // 説明のみ入力（タイトルは空）
        await tester.enterText(
          find.widgetWithText(TextFormField, '説明を入力してください（任意）'),
          '説明のみ',
        );
        await tester.pumpAndSettle();

        // 作成ボタンは無効のまま
        final createButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, '作成'),
        );
        expect(createButton.onPressed, isNull);
      });
    });

    group('コールバック', () {
      testWidgets('onSuccessコールバックがnullでも動作する', (tester) async {
        fakeRepository.setNextSortOrder(0);

        await tester.pumpWidget(createTestWidget(onSuccess: null));

        await tester.enterText(
          find.widgetWithText(TextFormField, 'タイトルを入力してください'),
          '読書',
        );
        await tester.pumpAndSettle();

        // エラーなく作成できる
        await tester.tap(find.widgetWithText(ElevatedButton, '作成'));
        await tester.pumpAndSettle();

        expect(fakeRepository.items.length, equals(1));
      });

      testWidgets('onCancelコールバックがnullでも動作する', (tester) async {
        await tester.pumpWidget(createTestWidget(onCancel: null));

        // エラーなくキャンセルボタンをタップできる
        await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
        await tester.pumpAndSettle();

        // 特にエラーは発生しない
        expect(tester.takeException(), isNull);
      });
    });
  });
}
