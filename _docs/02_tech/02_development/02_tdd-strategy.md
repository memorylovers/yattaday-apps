# TDD戦略

## 軽量化TDD戦略の概要

層によってテスト手法を使い分けることで、効率的な品質保証を実現します。

```
┌─────────────────────────────────────────────┐
│             TDD必須層                        │
│  1_models, 2_repository, 3_store, 4_flow    │
│        （ビジネスロジック中心）                │
├─────────────────────────────────────────────┤
│           柔軟なアプローチ層                   │
│            5_view_model                     │
│      （複雑なロジックがある場合のみ）           │
├─────────────────────────────────────────────┤
│          Widgetbook代替層                    │
│         6_component, 7_page                 │
│         （UI中心・視覚的確認）                 │
└─────────────────────────────────────────────┘
```

## 各層のテスト戦略

### 1_models層（カバレッジ目標: 100%）

**テスト対象:**
- データクラスの生成・変換
- ビジネスロジック
- バリデーション
- 計算処理

**テスト例:**
```dart
group('RecordItem', () {
  test('should create with required fields', () {
    final item = RecordItem(
      id: '123',
      title: 'Test Item',
      unit: '回',
    );
    
    expect(item.id, equals('123'));
    expect(item.title, equals('Test Item'));
    expect(item.unit, equals('回'));
  });
  
  test('should validate correctly', () {
    final validItem = RecordItem(id: '1', title: 'Test', unit: '回');
    final invalidItem = RecordItem(id: '2', title: '', unit: '');
    
    expect(validItem.isValid, isTrue);
    expect(invalidItem.isValid, isFalse);
  });
  
  test('should calculate total correctly', () {
    final item = RecordItem(
      id: '1',
      title: 'Test',
      unit: '回',
      dailyTarget: 5,
    );
    
    expect(item.calculateMonthlyTarget(), equals(150)); // 5 * 30
  });
});
```

### 2_repository層（カバレッジ目標: 90%）

**テスト対象:**
- CRUD操作
- エラーハンドリング
- データ変換
- 複合処理

**テスト例:**
```dart
group('RecordItemRepository', () {
  late FakeFirestoreService fakeService;
  late RecordItemCommandRepository repository;
  
  setUp(() {
    fakeService = FakeFirestoreService();
    repository = RecordItemCommandRepository(fakeService);
  });
  
  test('should create item successfully', () async {
    final item = RecordItem(id: '1', title: 'Test', unit: '回');
    
    await repository.create(item);
    
    expect(fakeService.documents['items/1'], equals(item.toJson()));
  });
  
  test('should handle create error', () async {
    fakeService.shouldThrowError = true;
    final item = RecordItem(id: '1', title: 'Test', unit: '回');
    
    expect(
      () => repository.create(item),
      throwsA(isA<AppException>()),
    );
  });
  
  test('should create if not exists', () async {
    final item = RecordItem(id: '1', title: 'Test', unit: '回');
    
    // 初回作成
    await repository.createIfNotExists(item);
    expect(fakeService.callCount['create'], equals(1));
    
    // 2回目は作成されない
    await repository.createIfNotExists(item);
    expect(fakeService.callCount['create'], equals(1));
  });
});
```

### 3_store層（カバレッジ目標: 90%）

**テスト対象:**
- 状態管理ロジック
- ビジネスルール
- 非同期処理
- エラー状態

**テスト例:**
```dart
group('RecordItemStore', () {
  test('should load items on initialization', () async {
    final container = ProviderContainer(
      overrides: [
        recordItemRepositoryProvider.overrideWithValue(
          FakeRecordItemRepository(initialItems: testItems),
        ),
      ],
    );
    
    final store = container.read(recordItemStoreProvider);
    
    await container.pump();
    
    expect(store.items, equals(testItems));
  });
  
  test('should handle concurrent updates', () async {
    final container = ProviderContainer();
    final store = container.read(recordItemStoreProvider.notifier);
    
    // 同時更新をシミュレート
    final future1 = store.updateItem('1', title: 'Update 1');
    final future2 = store.updateItem('1', title: 'Update 2');
    
    await Future.wait([future1, future2]);
    
    // 最後の更新が反映される
    final item = container.read(recordItemStoreProvider).items.first;
    expect(item.title, equals('Update 2'));
  });
});
```

### 4_flow層（カバレッジ目標: 85%）

**テスト対象:**
- フロー遷移
- 一時的な状態管理
- ステップ検証
- 完了処理

**テスト例:**
```dart
group('OnboardingFlow', () {
  test('should progress through steps', () {
    final container = ProviderContainer();
    final flow = container.read(onboardingFlowProvider.notifier);
    
    expect(container.read(onboardingFlowProvider).currentStep, equals(0));
    
    flow.nextStep();
    expect(container.read(onboardingFlowProvider).currentStep, equals(1));
    
    flow.nextStep();
    expect(container.read(onboardingFlowProvider).currentStep, equals(2));
  });
  
  test('should validate before proceeding', () {
    final container = ProviderContainer();
    final flow = container.read(onboardingFlowProvider.notifier);
    
    // 必須項目が未入力
    expect(
      () => flow.nextStep(),
      throwsA(isA<AppException>()),
    );
  });
});
```

### 5_view_model層（複雑なロジックのみ）

**テスト対象:**
- 複雑な画面ロジック
- 状態遷移
- エラーハンドリング
- 非同期処理の組み合わせ

**複雑性の判断基準:**
```dart
// 複雑: 3つ以上の状態を持つ
enum ViewState { initial, loading, searching, results, error }

// 複雑: 複数の非同期処理を組み合わせる
Future<void> complexOperation() async {
  final user = await loadUser();
  final permissions = await checkPermissions(user);
  final data = await fetchData(permissions);
  processData(data);
}

// シンプル: 単純な表示切り替え
void toggleView() {
  isListView = !isListView;
}
```

### 6_component, 7_page層（Widgetbook）

**確認項目:**
- 各種状態での表示
- レスポンシブデザイン
- ダークモード対応
- エラー状態の表示
- ローディング状態

**Widgetbook実装例:**
```dart
@UseCase(name: 'Default', type: RecordItemCard)
Widget buildDefault(BuildContext context) => RecordItemCard(
  item: mockRecordItem,
);

@UseCase(name: 'Loading', type: RecordItemCard)
Widget buildLoading(BuildContext context) => RecordItemCard(
  item: mockRecordItem,
  isLoading: true,
);

@UseCase(name: 'Error', type: RecordItemCard)
Widget buildError(BuildContext context) => RecordItemCard(
  item: mockRecordItem,
  error: AppException(
    code: AppErrorCode.networkError,
    message: 'ネットワークエラー',
  ),
);
```

## テストヘルパーの活用

### Fakeオブジェクト

```dart
// test/test_helpers/fake_record_item_repository.dart
class FakeRecordItemRepository implements RecordItemRepository {
  final List<RecordItem> _items = [];
  int callCount = 0;
  
  @override
  Future<void> create(RecordItem item) async {
    callCount++;
    _items.add(item);
  }
  
  @override
  Stream<List<RecordItem>> watchAll() {
    return Stream.value(_items);
  }
}
```

### テストデータファクトリ

```dart
// test/test_helpers/factories/record_item_factory.dart
class RecordItemFactory {
  static RecordItem create({
    String? id,
    String? title,
    String? unit,
  }) {
    return RecordItem(
      id: id ?? uuid.v4(),
      title: title ?? 'Test Item ${Random().nextInt(100)}',
      unit: unit ?? '回',
      createdAt: DateTime.now(),
    );
  }
  
  static List<RecordItem> createList(int count) {
    return List.generate(count, (_) => create());
  }
}
```

### Providerテストユーティリティ

```dart
// test/test_utils/provider_test_utils.dart
ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith(() => const AuthState.authenticated(testUser)),
      ...overrides,
    ],
  );
  
  addTearDown(container.dispose);
  return container;
}
```

## カバレッジ測定

```bash
# カバレッジレポート生成
cd app && flutter test --coverage

# HTMLレポート生成
cd app && genhtml coverage/lcov.info -o coverage/html

# ブラウザで確認
open coverage/html/index.html
```

## テストのベストプラクティス

1. **Arrange-Act-Assert パターン**
   ```dart
   test('should ...', () {
     // Arrange
     final repository = FakeRepository();
     final store = Store(repository);
     
     // Act
     store.doSomething();
     
     // Assert
     expect(store.state, equals(expectedState));
   });
   ```

2. **1テスト1検証**
   - 各テストは1つの振る舞いのみを検証
   - テスト名は検証内容を明確に表現

3. **テストの独立性**
   - 各テストは他のテストに依存しない
   - setUp/tearDownを適切に使用

4. **モックよりフェイクを優先**
   - 振る舞いが予測可能
   - テストが読みやすい
   - リファクタリングに強い