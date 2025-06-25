# Widgetbook統合ガイド

## 概要

本プロジェクトでは、UI層（6_component/7_page）のビジュアルテストとして[Widgetbook](https://docs.widgetbook.io/)を活用しています。

```bash
make book  # Widgetbook起動（http://localhost:9442）
```

## プロジェクトでの役割

- **UIカタログ**: コンポーネントの各種状態を一覧で確認
- **ビジュアルテスト**: TDDにおけるUI層のテスト手段
- **デザイン確認**: デザイナーとの仕様確認ツール

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

## 実装例

### コンポーネントのUseCase（必須）

```dart
// widgetbook/lib/features/record_item/record_item_card.dart
@UseCase(name: 'Default', type: RecordItemCard)
Widget buildRecordItemCardDefaultUseCase(BuildContext context) {
  return RecordItemCard(
    item: RecordItemMocks.simple(),
    onTap: () => context.showSnackbar('タップされました'),
  );
}
```

### ページのUseCase（ViewModelモック使用）

```dart
// widgetbook/lib/pages/record_list_page.dart
@UseCase(name: 'Default', type: RecordListPage)
Widget buildRecordListPageDefaultUseCase(BuildContext context) {
  return ProviderScope(
    overrides: [
      recordListViewModelProvider.overrideWith((ref) {
        return MockRecordListViewModel(
          initialState: RecordListState(
            items: RecordItemMocks.list(10),
          ),
        );
      }),
    ],
    child: const RecordListPage(),
  );
}
```

詳細な実装方法は[Widgetbook公式ドキュメント](https://docs.widgetbook.io/)を参照してください。

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
make gen
```

### 4. 確認

```bash
make book
# ブラウザが自動的に開く
```

## プロジェクト固有の実装パターン

### モックデータの管理

```dart
// widgetbook/lib/mocks/にfeature毎のモックを配置
widgetbook/lib/mocks/
├── record_item_mocks.dart     # RecordItemのテストデータ
├── user_mocks.dart            # Userのテストデータ
└── view_model_mocks.dart      # ViewModelモックヘルパー
```

### 7層構造との対応

| レイヤー | Widgetbookでの扱い |
|---------|-------------------|
| 6_component | 個別にUseCaseを作成、各種状態を網羅 |
| 7_page | ViewModelをモックして画面全体を確認 |
| 5_view_model | MockViewModelで置き換え |
| 1-4層 | Widgetbookでは扱わない |

## ディレクトリ別の実装方針

### components/（app/lib/components/に対応）

- 共通UIコンポーネントの各種バリエーション
- Default, Loading, Error, Disabled状態を網羅

### features/（app/lib/features/*/6_component/に対応）

- 実際のドメインデータを使用したUseCase
- エッジケース（長いテキスト、大量データ）を含める

### pages/（app/lib/features/*/7_page/に対応）

- ViewModelをモックして画面全体を確認
- 画面遷移やエラー状態の確認

## ベストプラクティス

### 必須要件

- すべてのComponent/Pageに最低限Default UseCaseを作成
- UseCase関数名: `build<ComponentName><State>UseCase`
- モッククラス名: `Mock<OriginalName>`

### 推奨される状態パターン

- Default, Loading, Error, Empty, Disabled
- エッジケース（長いテキスト、境界値）

### ViewModelのモック方針

- UIの確認に必要な最小限の実装
- ビジネスロジックは含めない
- 状態の変更メソッドのみ実装

## プロジェクト固有の注意点

### ProviderScopeの設定

ページのUseCaseではProviderScopeでViewModelをオーバーライドする必要があります。

### コード生成との連携

```bash
# Widgetbookでもコード生成が必要
make gen
```

### make bookコマンド

- ポート9442で起動
- ホットリロード対応
- 自動的にブラウザが開く

## 参考リンク

- [Widgetbook公式ドキュメント](https://docs.widgetbook.io/)
- [UseCaseの書き方](https://docs.widgetbook.io/guides/use-cases)
- [Knobsの使い方](https://docs.widgetbook.io/knobs/overview)
- [トラブルシューティング](https://docs.widgetbook.io/guides/troubleshooting)
