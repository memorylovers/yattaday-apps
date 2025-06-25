# Widgetbook統合ガイド

## 概要

本プロジェクトでは、UI層（Component/Page）のビジュアルテストとして、Widgetbookを活用しています。  
`make book`コマンドで起動し、UIコンポーネントの各種状態を確認できます。

## Widgetbookの役割

1. **UIカタログ**: すべてのコンポーネントとページを一覧で確認
2. **UIのユニットテスト**: Page/ComponentのUIはUIカタログツールで実施

## プロジェクト構造

```
widgetbook/
├── lib/
│   ├── components/                # 共通コンポーネント
│   │   └── buttons/
│   │       └── primary_button.dart
│   ├── features/                  # 機能別コンポーネント
│   │   └── record_item/
│   │       └── record_item_card.dart
│   └── pages/                     # ページカタログ
│       ├── record_list_page.dart
│       └── settings_page.dart
├── main.dart                      # エントリーポイント
└── pubspec.yaml
```

## 基本的な実装

### UseCase の作成

```dart
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook/widgetbook.dart';

// デフォルトのUseCase（必須）
@UseCase(name: 'Default', type: RecordItemCard)
Widget buildRecordItemCardDefaultUseCase(BuildContext context) {
  return RecordItemCard(
    item: RecordItem(
      id: '1',
      title: 'サンプルタスク',
      unit: '回',
      description: '毎日の運動記録',
      icon: '🏃',
    ),
    onTap: () => context.showSnackbar('タップされました'),
  );
}

// ローディング状態
@UseCase(name: 'Loading', type: RecordItemCard)
Widget buildRecordItemCardLoadingUseCase(BuildContext context) {
  return const RecordItemCard(
    isLoading: true,
  );
}

// エラー状態
@UseCase(name: 'Error', type: RecordItemCard)
Widget buildRecordItemCardErrorUseCase(BuildContext context) {
  return RecordItemCard(
    item: mockItem,
    error: AppException(
      code: AppErrorCode.networkError,
      message: 'ネットワークエラー',
    ),
  );
}

// 長いテキストの場合
@UseCase(name: 'Long Text', type: RecordItemCard)
Widget buildRecordItemCardLongTextUseCase(BuildContext context) {
  return RecordItemCard(
    item: RecordItem(
      id: '2',
      title: 'とても長いタイトルが設定されている場合の表示確認用サンプル',
      unit: '回',
      description: 'とても長い説明文が入力されている場合のレイアウト確認。'
          '複数行にわたる説明文がどのように表示されるかを確認します。',
    ),
  );
}
```

### ページのUseCase

```dart
// ViewModelのモックを作成
class MockRecordListViewModel extends StateNotifier<RecordListState> {
  MockRecordListViewModel({RecordListState? initialState})
      : super(initialState ?? const RecordListState());
  
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
  
  void setItems(List<RecordItem> items) {
    state = state.copyWith(items: items);
  }
}

// デフォルトのページ表示
@UseCase(name: 'Default', type: RecordListPage)
Widget buildRecordListPageDefaultUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordListViewModelProvider.overrideWith((ref) {
        return MockRecordListViewModel(
          initialState: RecordListState(
            items: List.generate(
              10,
              (i) => RecordItem(
                id: '$i',
                title: 'タスク ${i + 1}',
                unit: '回',
              ),
            ),
          ),
        );
      }),
    ],
    child: const RecordListPage(),
  );
}

// 空状態
@UseCase(name: 'Empty', type: RecordListPage)
Widget buildRecordListPageEmptyUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordListViewModelProvider.overrideWith((ref) {
        return MockRecordListViewModel(
          initialState: const RecordListState(items: []),
        );
      }),
    ],
    child: const RecordListPage(),
  );
}
```

## Knobs（インタラクティブなプロパティ）

```dart
@UseCase(name: 'Interactive', type: CustomButton)
Widget buildCustomButtonInteractiveUseCase(BuildContext context) {
  return CustomButton(
    // テキスト入力
    text: context.knobs.string(
      label: 'Button Text',
      initialValue: 'Click me',
    ),
    // 有効/無効の切り替え
    enabled: context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    ),
    // 色の選択
    color: context.knobs.color(
      label: 'Color',
      initialValue: Colors.blue,
    ),
    // サイズの選択
    size: context.knobs.list(
      label: 'Size',
      options: ButtonSize.values,
      initialOption: ButtonSize.medium,
    ),
    // 数値入力
    padding: EdgeInsets.all(
      context.knobs.double.slider(
        label: 'Padding',
        initialValue: 16,
        min: 0,
        max: 32,
      ),
    ),
  );
}
```

## 開発フロー

### 1. コンポーネント/ページ作成

メインアプリで実装：

```bash
# app/lib/features/record_item/6_component/record_item_card.dart
```

### 2. Widgetbook UseCase作成

対応するUseCaseを作成：

```bash
# widgetbook/lib/features/record_item/record_item_card.dart
```

### 3. コード生成

```bash
cd widgetbook
dart run build_runner build
```

### 4. 確認

```bash
make book
# ブラウザが自動的に開く
```

## テストデータの管理

### モックデータファクトリ

```dart
// widgetbook/lib/mocks/record_item_mocks.dart
class RecordItemMocks {
  static RecordItem simple() => RecordItem(
    id: '1',
    title: 'シンプルなアイテム',
    unit: '回',
  );
  
  static RecordItem withIcon() => RecordItem(
    id: '2',
    title: 'アイコン付き',
    unit: '個',
    icon: '📝',
  );
  
  static RecordItem completed() => RecordItem(
    id: '3',
    title: '完了済み',
    unit: '回',
    completedAt: DateTime.now(),
  );
  
  static List<RecordItem> list(int count) => List.generate(
    count,
    (i) => RecordItem(
      id: '$i',
      title: 'アイテム ${i + 1}',
      unit: '回',
    ),
  );
}
```

### ViewModelモックヘルパー

```dart
// widgetbook/lib/mocks/view_model_mocks.dart
extension ViewModelMockHelpers on WidgetRef {
  T mockViewModel<T>(T Function() factory) {
    return factory();
  }
}

// 使用例
final viewModel = ref.mockViewModel(() => MockRecordListViewModel());
```

## ディレクトリ別の実装方針

### components/（共通コンポーネント）

- 汎用的なプロパティを網羅
- 各種サイズ、色、状態を確認
- エッジケースを含める

```dart
@UseCase(name: 'All Variants', type: PrimaryButton)
Widget buildPrimaryButtonAllVariants(BuildContext context) {
  return Column(
    children: [
      PrimaryButton(text: 'Default'),
      PrimaryButton(text: 'Disabled', enabled: false),
      PrimaryButton(text: 'Loading', isLoading: true),
      PrimaryButton(text: 'With Icon', icon: Icons.add),
    ],
  );
}
```

### features/（機能別コンポーネント）

- 実際のユースケースに近いデータ
- ビジネスロジックの動作確認
- エラー処理の確認

### pages/（ページ）

- 全体的なレイアウト確認
- 状態遷移の確認
- レスポンシブデザインの確認

## ベストプラクティス

1. **最低限Default UseCaseを作成**
   - すべてのコンポーネント/ページに必須
   - 最も一般的な使用例を表現

2. **状態バリエーションを網羅**
   - Default（通常）
   - Loading（読み込み中）
   - Error（エラー）
   - Empty（空）
   - Disabled（無効）

3. **エッジケースを含める**
   - 長いテキスト
   - 大量のデータ
   - 極端に小さい/大きいサイズ

4. **モックは最小限に**
   - UIの確認に必要な部分のみモック
   - ビジネスロジックは含めない

5. **命名規則を統一**
   - UseCase関数: `build<ComponentName><State>UseCase`
   - モック: `Mock<OriginalName>`

## トラブルシューティング

### UseCaseが表示されない

```bash
# 1. コード生成を実行
cd widgetbook && dart run build_runner build

# 2. main.directories.g.dartを確認
cat lib/main.directories.g.dart

# 3. キャッシュクリア
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### ProviderScopeエラー

```dart
// ❌ 悪い例
@UseCase(name: 'Test', type: MyPage)
Widget buildMyPageUseCase(BuildContext context) {
  return const MyPage(); // ProviderScopeがない
}

// ✅ 良い例
@UseCase(name: 'Test', type: MyPage)
Widget buildMyPageUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [...],
    child: const MyPage(),
  );
}
```

### Hot Reloadが効かない

```bash
# Widgetbookを再起動
make book
```
