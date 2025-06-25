# Flutter レイヤードアーキテクチャ実装ガイド

## 概要

このドキュメントは、[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)で定義された概念をFlutterプロジェクトで具体的に実装する方法を示します。アーキテクチャの基本概念や設計原則については、上記リンクを参照してください。

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

各層の責務と設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)を参照してください。

### 1_models - Flutter実装

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

### 2_repository - Flutter実装

Repository層のCQRSパターンについては[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#repository-データアクセス層)を参照してください。

```
2_repository/
├── dto/
│   └── <name>_param.dart        # 引数パラメタのDTO
├── <name>_query_repository.dart  # 参照用（読み取り専用）
└── <name>_command_repository.dart # 更新用（作成・更新・削除）
```

#### Flutter/Dartでの実装例

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

### 3_store - Flutter実装

Store層の設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#store-グローバル状態管理層)および[Store実装パターンガイド](../01_architecture/05_store-implementation-guide.md)を参照してください。

#### Riverpodを使用した実装例

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

### 4_flow - Flutter実装

Flow層の設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#flow-フロー状態管理層)を参照してください。

#### Riverpodを使用した実装例

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

### 5_view_model - Flutter実装

ViewModel層の設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#viewmodel-画面状態管理層)を参照してください。

#### Riverpodを使用した実装例

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

### 6_component - Flutter実装

Component層の設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#component-uiコンポーネント層)を参照してください。

#### Flutter Widgetの実装例

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

### 7_page - Flutter実装

Page層の設計原則については[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#page-画面層)を参照してください。

#### ConsumerWidgetを使用した実装例

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

## Feature間の参照ルール - Flutter実装

Feature間の参照ルールについては[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md#機能間の参照)を参照してください。

### Flutter/Dartでの実装例

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

本ドキュメントでは、[レイヤードアーキテクチャ](../01_architecture/02_layered-architecture.md)で定義された設計原則をFlutter/Dartで実装する具体的な方法を示しました。各層の責務や依存関係の詳細については、アーキテクチャドキュメントを参照してください。
