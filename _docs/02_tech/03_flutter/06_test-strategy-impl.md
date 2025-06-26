# Flutterテスト実装ガイド

## 概要

このドキュメントは、[テスト戦略](../02_development/02_test-strategy.md)で定義された方針をFlutterプロジェクトで具体的に実装する方法を示します。各層のテスト実装パターンと、Flutter固有のツール・ライブラリの使用方法を解説します。

## テストファイルの構造

テストファイルは`lib/`の構造をミラーリングします：

```
test/
├── features/<feature_name>/
│   ├── 1_models/
│   ├── 2_repository/
│   ├── 3_store/
│   ├── 4_flow/
│   ├── 5_view_model/
│   ├── 6_component/
│   └── 7_page/
└── services/

e2e/
└── maestro/
    └── flows/
```

## 層別テスト実装

### Models層のテスト（カバレッジ目標: 100%）

Freezedで生成されたモデルとビジネスロジックのテスト：

```dart
// test/features/record/1_models/record_item_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecordItem', () {
    test('isValid returns true when title and unit are not empty', () {
      final item = RecordItem(
        id: '1',
        title: 'Test',
        unit: 'times',
      );
      
      expect(item.isValid, isTrue);
    });
    
    test('calculateStreak returns correct streak count', () {
      final item = RecordItem(id: '1', title: 'Test', unit: 'times');
      final dates = [
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 2),
        DateTime(2024, 1, 3),
      ];
      
      expect(item.calculateStreak(dates), equals(3));
    });
  });
}
```

### Repository層のテスト（カバレッジ目標: 90%）

#### fake_cloud_firestoreを使用したFirestoreテスト

```dart
// test/features/record/2_repository/record_item_repository_test.dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late RecordItemQueryRepository queryRepo;
  late RecordItemCommandRepository commandRepo;
  
  setUp(() {
    firestore = FakeFirebaseFirestore();
    queryRepo = RecordItemQueryRepository(firestore);
    commandRepo = RecordItemCommandRepository(firestore);
  });
  
  group('RecordItemQueryRepository', () {
    test('watchByUserId returns stream of items', () async {
      // Arrange
      final userId = 'test-user';
      final item = RecordItem(
        id: '1',
        userId: userId,
        title: 'Test Item',
        unit: 'times',
      );
      
      // Act
      await commandRepo.create(item);
      
      // Assert
      final stream = queryRepo.watchByUserId(userId);
      await expectLater(
        stream,
        emits(contains(
          predicate<RecordItem>((i) => i.id == '1' && i.title == 'Test Item'),
        )),
      );
    });
  });
}
```

### Store層のテスト（カバレッジ目標: 80%）

#### Riverpod Providerのテスト

```dart
// test/features/record/3_store/record_item_store_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Mock実装
class MockRecordItemRepository extends RecordItemQueryRepository {
  @override
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return Stream.value([
      RecordItem(id: '1', userId: userId, title: 'Test', unit: 'times'),
    ]);
  }
}

void main() {
  test('recordItemListProvider provides items for authenticated user', () async {
    final container = ProviderContainer(
      overrides: [
        // Repository をモックでオーバーライド
        recordItemQueryRepositoryProvider.overrideWithValue(
          MockRecordItemRepository(),
        ),
        // 認証状態をモック
        authUidProvider.overrideWith(() => Future.value('test-user')),
      ],
    );
    
    // Provider の値を取得
    final items = await container.read(recordItemListProvider.future);
    
    expect(items.length, equals(1));
    expect(items.first.title, equals('Test'));
  });
}
```

### Flow層のテスト（複雑な場合のみ）

マルチステップフローの状態遷移テスト：

```dart
// test/features/onboarding/4_flow/onboarding_flow_test.dart
test('OnboardingFlow completes all steps', () async {
  final container = ProviderContainer();
  final flow = container.read(onboardingFlowProvider.notifier);
  
  // 初期状態
  expect(container.read(onboardingFlowProvider).currentStep, equals(0));
  
  // ステップを進める
  flow.nextStep();
  expect(container.read(onboardingFlowProvider).currentStep, equals(1));
  
  // 完了
  flow.complete();
  expect(container.read(onboardingFlowProvider).isCompleted, isTrue);
});
```

### ViewModel層のテスト（複雑なロジックがある場合）

複雑なロジックの判定基準：

- 条件分岐が3つ以上
- 非同期処理の組み合わせ
- エラーハンドリングが必要
- 状態遷移が複雑

```dart
// test/features/record/5_view_model/record_list_view_model_test.dart
test('RecordListViewModel filters items correctly', () async {
  final container = ProviderContainer(
    overrides: [
      recordItemStoreProvider.overrideWith(() => [
        RecordItem(id: '1', title: 'Active', isActive: true),
        RecordItem(id: '2', title: 'Completed', isCompleted: true),
      ]),
    ],
  );
  
  final viewModel = container.read(recordListViewModelProvider.notifier);
  
  // フィルタを適用
  viewModel.setFilter(RecordFilter.active);
  
  final filteredItems = container.read(recordListViewModelProvider).filteredItems;
  expect(filteredItems.length, equals(1));
  expect(filteredItems.first.title, equals('Active'));
});
```

### UI層のテスト（Widgetbook + 選択的なWidgetTest）

UI層は主にWidgetbookでビジュアル確認を行います。詳細は[Widgetbookガイド](./03_widgetbook-guide.md)を参照してください。

重要な相互作用がある場合のみWidgetTestを追加：

```dart
// test/features/record/7_page/record_list_page_test.dart
testWidgets('RecordListPage shows items', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        recordListViewModelProvider.overrideWith(() => RecordListViewModel(
          items: [RecordItem(id: '1', title: 'Test')],
        )),
      ],
      child: MaterialApp(home: RecordListPage()),
    ),
  );
  
  expect(find.text('Test'), findsOneWidget);
});
```

## E2Eテスト

Maestroを使用した重要な業務フローのテスト。詳細は[Flutterツール](./04_flutter-tools.md#e2eテスト)を参照してください。

```yaml
# e2e/maestro/flows/record_creation.yaml
appId: com.example.app
---
- launchApp
- tapOn: "記録を追加"
- inputText: "朝のランニング"
- tapOn: "保存"
- assertVisible: "朝のランニング"
```

## テストユーティリティ

### モックヘルパー

```dart
// test/helpers/mock_providers.dart
class MockProviders {
  static List<Override> get authenticated => [
    authUidProvider.overrideWith(() => Future.value('test-user')),
    authStateProvider.overrideWith(() => AuthState.authenticated(testUser)),
  ];
  
  static List<Override> get unauthenticated => [
    authUidProvider.overrideWith(() => Future.value(null)),
    authStateProvider.overrideWith(() => AuthState.unauthenticated()),
  ];
}
```

### テストデータファクトリー

```dart
// test/helpers/test_data_factory.dart
class TestDataFactory {
  static RecordItem createRecordItem({
    String? id,
    String? title,
    String? unit,
  }) {
    return RecordItem(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title ?? 'Test Item',
      unit: unit ?? 'times',
      createdAt: DateTime.now(),
    );
  }
}
```

## ベストプラクティス

1. **AAA パターンの使用**

   ```dart
   test('description', () {
     // Arrange
     final data = TestDataFactory.createRecordItem();
     
     // Act
     final result = repository.create(data);
     
     // Assert
     expect(result, completes);
   });
   ```

2. **ProviderContainerの適切な破棄**

   ```dart
   late ProviderContainer container;
   
   setUp(() {
     container = ProviderContainer();
   });
   
   tearDown(() {
     container.dispose();
   });
   ```

3. **非同期テストの適切な待機**

   ```dart
   // Streamのテスト
   await expectLater(stream, emits(expected));
   
   // Futureのテスト
   await expectLater(future, completion(expected));
   ```

## 関連ドキュメント

- [テスト戦略](../02_development/02_test-strategy.md) - テストの方針と考え方
- [コーディングスタイル](./05_coding-style.md#tddテスト駆動開発) - TDD開発手法
- [Widgetbookガイド](./03_widgetbook-guide.md) - UIカタログとビジュアルテスト
- [Flutterツール](./04_flutter-tools.md) - テストツールとコマンド
