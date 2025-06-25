# Riverpod実装パターン

## 概要

本プロジェクトでは、Riverpod v2 + riverpod_generatorを使用した型安全な状態管理を実装しています。

## 基本的な使い方

### Provider の種類と使い分け

| Provider | 用途 | 例 |
|----------|------|-----|
| `@riverpod` | 単純な値や関数 | 設定値、ユーティリティ |
| `@riverpod` + `Stream/Future` | 非同期データ | API呼び出し、リアルタイムデータ |
| `@riverpod` + `class` | 状態を持つロジック | Store、ViewModel |

### 基本的なProvider

```dart
// 単純な値
@riverpod
String appVersion(Ref ref) => '1.0.0';

// 計算された値
@riverpod
int totalItems(Ref ref) {
  final items = ref.watch(itemListProvider);
  return items.length;
}

// 依存関係を持つProvider
@riverpod
UserProfile currentUser(Ref ref) {
  final userId = ref.watch(authUserIdProvider);
  return ref.watch(userProfileProvider(userId));
}
```

## 非同期処理パターン

### StreamProvider（リアルタイムデータ）

```dart
@riverpod
Stream<List<RecordItem>> recordItemList(Ref ref) async* {
  final uid = await ref.watch(authUidProvider.future);
  if (uid == null) {
    yield [];
    return;
  }
  
  yield* recordItemRepository.watchByUserId(uid);
}

// 使用側
class RecordListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(recordItemListProvider);
    
    return itemsAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => RecordItemCard(items[index]),
      ),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

### FutureProvider（一度きりのデータ取得）

```dart
@riverpod
Future<UserStats> userStats(Ref ref, String userId) async {
  final repository = ref.read(statsRepositoryProvider);
  return repository.getUserStats(userId);
}

// キャッシュの無効化
ref.invalidate(userStatsProvider);
```

## StateNotifierProvider（状態管理）

### Store層の実装

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

@riverpod
class AuthStore extends _$AuthStore {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final user = await _authRepository.signIn(email, password);
      state = AuthState.authenticated(user);
    } on AppException catch (e) {
      state = AuthState.error(e.message);
    }
  }
  
  void signOut() {
    _authRepository.signOut();
    state = const AuthState.unauthenticated();
  }
}
```

### ViewModel層の実装

```dart
@freezed
class RecordListState with _$RecordListState {
  const factory RecordListState({
    @Default([]) List<RecordItem> items,
    @Default(false) bool isLoading,
    @Default(null) AppException? error,
    @Default('') String searchQuery,
  }) = _RecordListState;
}

@riverpod
class RecordListViewModel extends _$RecordListViewModel {
  @override
  RecordListState build() {
    // Storeの変更を監視
    ref.listen(recordItemStoreProvider, (previous, next) {
      _updateItems();
    });
    
    return const RecordListState();
  }
  
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _filterItems();
  }
  
  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await ref.read(recordItemStoreProvider.notifier).deleteItem(itemId);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
```

## 依存関係の管理

### ref.watch vs ref.read

```dart
@riverpod
class ExampleViewModel extends _$ExampleViewModel {
  @override
  ExampleState build() {
    // ✅ build内ではwatchを使用（リアクティブ）
    final authState = ref.watch(authStateProvider);
    
    return ExampleState(isAuthenticated: authState is Authenticated);
  }
  
  Future<void> someAction() async {
    // ✅ メソッド内ではreadを使用（一度きり）
    final repository = ref.read(exampleRepositoryProvider);
    await repository.doSomething();
  }
}
```

### select による最適化

```dart
@riverpod
class CartSummary extends _$CartSummary {
  @override
  CartSummaryState build() {
    // カート内のアイテム数のみを監視
    final itemCount = ref.watch(
      cartStoreProvider.select((cart) => cart.items.length),
    );
    
    // 合計金額のみを監視
    final totalPrice = ref.watch(
      cartStoreProvider.select((cart) => cart.totalPrice),
    );
    
    return CartSummaryState(
      itemCount: itemCount,
      totalPrice: totalPrice,
    );
  }
}
```

## ライフサイクル管理

### 自動破棄とキープアライブ

```dart
// デフォルト：使用されなくなったら自動破棄
@riverpod
Future<Data> temporaryData(Ref ref) async {
  return fetchData();
}

// 明示的にキープアライブ
@Riverpod(keepAlive: true)
Future<Config> appConfig(Ref ref) async {
  return loadConfig();
}

// 条件付きキープアライブ
@riverpod
Future<UserData> userData(Ref ref) async {
  // 認証中のみキープアライブ
  final isAuthenticated = ref.watch(authStateProvider) is Authenticated;
  if (isAuthenticated) {
    ref.keepAlive();
  }
  
  return fetchUserData();
}
```

### リソースのクリーンアップ

```dart
@riverpod
class WebSocketConnection extends _$WebSocketConnection {
  @override
  Stream<Message> build() {
    final channel = WebSocketChannel.connect(wsUrl);
    
    // クリーンアップ処理を登録
    ref.onDispose(() {
      channel.sink.close();
    });
    
    return channel.stream.map((data) => Message.fromJson(data));
  }
}
```

## テストパターン

### Provider のモック

```dart
class MockAuthStore extends _$AuthStore with Mock {
  @override
  AuthState build() => const AuthState.authenticated(testUser);
  
  @override
  Future<void> signIn(String email, String password) async {
    // モックの実装
  }
}

// テストでの使用
test('should display user name when authenticated', () {
  final container = ProviderContainer(
    overrides: [
      authStoreProvider.overrideWith(() => MockAuthStore()),
    ],
  );
  
  final authState = container.read(authStoreProvider);
  expect(authState, isA<Authenticated>());
});
```

### ProviderContainer でのテスト

```dart
test('RecordListViewModel should filter items', () async {
  final container = ProviderContainer(
    overrides: [
      recordItemListProvider.overrideWith(
        () => Stream.value(testRecordItems),
      ),
    ],
  );
  
  final viewModel = container.read(recordListViewModelProvider.notifier);
  viewModel.setSearchQuery('test');
  
  await container.pump();
  
  final state = container.read(recordListViewModelProvider);
  expect(state.items.length, equals(2));
});
```

## パフォーマンス最適化

### 1. 不必要な再ビルドの回避

```dart
// ❌ 悪い例：全体を監視
final cart = ref.watch(cartProvider);
return Text('Items: ${cart.items.length}');

// ✅ 良い例：必要な部分のみ監視
final itemCount = ref.watch(
  cartProvider.select((cart) => cart.items.length),
);
return Text('Items: $itemCount');
```

### 2. 高価な計算の最適化

```dart
@riverpod
Future<ExpensiveResult> expensiveComputation(Ref ref) async {
  // 自動的にキャッシュされる
  return await heavyCalculation();
}

// 必要に応じて手動でキャッシュを無効化
ref.invalidate(expensiveComputationProvider);
```

### 3. デバウンス処理

```dart
@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounceTimer;
  
  @override
  SearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    
    return const SearchState();
  }
  
  void updateSearchQuery(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }
}
```

## ベストプラクティス

1. **Provider の責務を明確に**
   - 1つのProviderは1つの責務のみ
   - 複雑なロジックはStore/ViewModelに分離

2. **適切なProvider の選択**
   - 状態なし → `@riverpod`関数
   - 状態あり → `@riverpod`クラス
   - 非同期 → `Future`/`Stream`を返す

3. **依存関係の最小化**
   - 必要な値のみを`select`で取得
   - 循環参照を避ける

4. **テスタビリティの確保**
   - DIを活用してモック可能に
   - ProviderContainerでテスト

5. **メモリリークの防止**
   - StreamSubscriptionは必ずdispose
   - 不要なキープアライブは避ける