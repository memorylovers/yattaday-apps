# Flutter レイヤードアーキテクチャ実装ガイド

## 概要

このドキュメントは、[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)をFlutterプロジェクトで実装する際の具体的なガイドラインを提供します。

## ディレクトリ構成

本プロジェクトでは、Feature-Firstアプローチと番号付きディレクトリを採用しています。

```
app/lib/
├── features/
│   └── <feature_name>/
│       ├── 1_models/         # モデル、エンティティ、ドメインロジック
│       ├── 2_repository/     # データアクセス層（CQRS）
│       ├── 3_store/          # グローバル状態管理
│       ├── 4_flow/           # 複数画面間の一時的な状態管理
│       ├── 5_view_model/     # 画面固有の状態管理
│       ├── 6_component/      # UIコンポーネント
│       └── 7_page/           # UI ページ
├── services/                 # 外部ライブラリのラッパー
├── common/                   # 共通ユーティリティ
└── components/               # アプリ全体で使用する共通コンポーネント

```

### ディレクトリ番号の意図

番号付けにより以下のメリットが得られます：

1. **視覚的な依存関係**: エクスプローラーで見た際に依存の流れが明確
2. **学習効率**: 新規開発者がアーキテクチャを理解しやすい
3. **一貫性**: プロジェクト全体で統一された構造

## 各層の実装詳細

### 1_models

```dart
// record_item.dart
@freezed
class RecordItem with _$RecordItem {
  const factory RecordItem({
    required String id,
    required String title,
    required String unit,
    String? description,
    DateTime? createdAt,
  }) = _RecordItem;

  const RecordItem._();

  // ビジネスロジックの例
  bool get isValid => title.isNotEmpty && unit.isNotEmpty;
  
  // 計算ロジックの例
  int calculateStreak(List<DateTime> completedDates) {
    // ストリーク計算ロジック
  }
}
```

### 2_repository

Repository層は以下の構成で実装します：

```
2_repository/
├── dto/
│   └── <name>_param.dart        # 引数パラメタのDTO
├── <name>_query_repository.dart  # 参照用（読み取り専用）
└── <name>_command_repository.dart # 更新用（作成・更新・削除）
```

#### CQRSパターンの実装

```dart
// record_item_query_repository.dart
class RecordItemQueryRepository {
  final FirestoreService _firestoreService;
  
  RecordItemQueryRepository(this._firestoreService);
  
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return _firestoreService
        .collection('recordItems')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(_convertToRecordItems);
  }
}

// record_item_command_repository.dart
class RecordItemCommandRepository {
  final FirestoreService _firestoreService;
  
  RecordItemCommandRepository(this._firestoreService);
  
  Future<void> createIfNotExists(RecordItem item) async {
    final exists = await _checkExists(item.id);
    if (!exists) {
      await _firestoreService
          .collection('recordItems')
          .doc(item.id)
          .set(item.toJson());
    }
  }
}
```

### 3_store

Riverpodを使用したグローバル状態管理：

```dart
@riverpod
class RecordItemStore extends _$RecordItemStore {
  @override
  RecordItemState build() {
    _initialize();
    return const RecordItemState.loading();
  }

  void _initialize() {
    final userId = ref.watch(authStoreProvider).userId;
    if (userId != null) {
      ref.listen(
        _recordItemQueryRepository.watchByUserId(userId),
        (previous, next) {
          state = RecordItemState.data(next);
        },
      );
    }
  }

  Future<void> createItem(RecordItem item) async {
    try {
      await _recordItemCommandRepository.createIfNotExists(item);
    } catch (e) {
      state = RecordItemState.error(e.toString());
    }
  }
}
```

### 4_flow

複数画面にまたがる状態管理：

```dart
@riverpod
class RecordCreationFlow extends _$RecordCreationFlow {
  @override
  RecordCreationState build() => RecordCreationState.initial();

  void startFlow() {
    state = state.copyWith(currentStep: CreationStep.selectType);
  }

  void nextStep() {
    state = state.copyWith(
      currentStep: _getNextStep(state.currentStep),
    );
  }

  void complete() {
    // フロー完了処理
    ref.invalidateSelf(); // 状態クリア
  }
}
```

### 5_view_model

画面固有の状態管理：

```dart
@riverpod
class RecordListViewModel extends _$RecordListViewModel {
  @override
  RecordListState build() {
    final items = ref.watch(recordItemStoreProvider);
    return RecordListState(
      items: items,
      filter: RecordFilter.all,
    );
  }

  void setFilter(RecordFilter filter) {
    state = state.copyWith(filter: filter);
  }

  List<RecordItem> get filteredItems {
    return state.items.where((item) {
      switch (state.filter) {
        case RecordFilter.active:
          return item.isActive;
        case RecordFilter.completed:
          return item.isCompleted;
        case RecordFilter.all:
          return true;
      }
    }).toList();
  }
}
```

### 6_component

再利用可能なUIコンポーネント：

```dart
class RecordItemCard extends StatelessWidget {
  final RecordItem item;
  final VoidCallback? onTap;

  const RecordItemCard({
    required this.item,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.title),
        subtitle: Text('${item.value} ${item.unit}'),
        onTap: onTap,
      ),
    );
  }
}
```

### 7_page

画面の実装：

```dart
class RecordListPage extends ConsumerWidget {
  const RecordListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(recordListViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録一覧'),
        actions: [
          PopupMenuButton<RecordFilter>(
            onSelected: (filter) {
              ref.read(recordListViewModelProvider.notifier).setFilter(filter);
            },
            itemBuilder: (context) => [
              // フィルターメニュー
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: viewModel.filteredItems.length,
        itemBuilder: (context, index) {
          final item = viewModel.filteredItems[index];
          return RecordItemCard(
            item: item,
            onTap: () => _navigateToDetail(context, item),
          );
        },
      ),
    );
  }
}
```

## Feature間の参照ルール

- 別featureからは`3_store`のみ参照可能
- 他の層は参照禁止

例：

```dart
// features/dashboard/5_view_model/dashboard_view_model.dart
class DashboardViewModel extends _$DashboardViewModel {
  @override
  DashboardState build() {
    // 他featureのstoreを参照（OK）
    final recordItems = ref.watch(recordItemStoreProvider);
    final userProfile = ref.watch(userStoreProvider);
    
    return DashboardState(
      recordItems: recordItems,
      userProfile: userProfile,
    );
  }
}
```

## テスト構造

テストファイルも同じ構造を保ちます：

```
test/features/<feature_name>/
├── 1_models/
├── 2_repository/
├── 3_store/
├── 4_flow/
├── 5_view_model/
├── 6_component/
└── 7_page/
```

## まとめ

この番号付きディレクトリ構造により、レイヤードアーキテクチャの依存関係が視覚的に明確になり、開発者がアーキテクチャを理解しやすくなります。
