# CLAUDE.md(widgetbook)

このファイルは、このリポジトリの`widgetbook/`配下のコードを扱う際の  
Claude Code (claude.ai/code) への指針を提供する

## **重要事項**

- メインアプリ(`../app/`)のすべてPage・Componentに対応するUIカタログを作成
- ViewModelについては、Mockを作成する
- 最低限Default UseCaseを作成する
- UseCase追加・変更した際は、必ず`make gen`でコードを生成する
- UseCaseの`path`パラメータは、`lib/`以下のディレクトリ構造と**必ず一致**させること
- Widgetbookの詳細な使い方は[公式ドキュメント](https://docs.widgetbook.io/)を参照

## 概要

Widgetbookは、FlutterアプリケーションのUIコンポーネントカタログです。以下の目的で使用します：

1. **UIカタログ**: すべてのコンポーネントとページを一覧で確認
2. **開発時のUIテスト**: 実際のデータなしにUIの動作を確認

## 起動方法

```bash
# ルートディレクトリから実行
make book

# コード生成後に起動する場合
make gen && make book
```

起動後、Chromeブラウザで自動的に開きます。

## ディレクトリ構造

```
widgetbook/
└── lib/
    ├── components/                   # 共通UIコンポーネント
    │   └── buttons/                  # pathパラメータ: 'components/buttons'
    │       └── primary_button.dart
    ├── features/                     # 機能別コンポーネント
    │   └── record_item/              # pathパラメータ: 'features/record_item'
    │       └── record_item_card.dart
    └── pages/                        # 各機能のページ（フラット構造）
        ├── record_list_page.dart     # pathパラメータ: 'pages'
        └── settings_page.dart        # pathパラメータ: 'pages'
```

### メインアプリとの対応関係

| Widgetbook | メインアプリ (app/) | 説明 |
|------------|-------------------|------|
| `lib/components/` | `lib/components/` | 共通UIコンポーネント |
| `lib/features/<name>/` | `lib/features/<name>/5_component/` | 機能固有のコンポーネント |
| `lib/pages/` | `lib/features/<name>/6_page/` | 機能固有のページ |

### ディレクトリの使い分け

- **components/**: アプリ全体で再利用される汎用コンポーネント
  - メインアプリの`app/lib/components/`に対応
  - 例: ボタン、ローディング、ダイアログなど

- **features/**: 特定の機能に紐づくコンポーネント
  - メインアプリの`app/lib/features/<feature_name>/5_component/`に対応
  - ページ以外のUI部品を配置

- **pages/**: 各機能のページ
  - メインアプリの`app/lib/features/<feature_name>/6_page/`に対応
  - ルーティングで遷移する画面単位のウィジェット

## ViewModelモック実装のガイドライン

WidgetbookではViewModelのモックを作成し、ProviderScopeで差し替えて使用します。

### 基本的な実装方法

1. **ViewModelのモックを作成**

   ```dart
   class MockRecordListViewModel extends StateNotifier<RecordListState> {
     MockRecordListViewModel() : super(/* 表示したい状態 */);
   }
   ```

2. **ProviderScopeでモックに差し替え**

   ```dart
   ProviderScope(
     overrides: [
       recordListViewModelProvider.overrideWith(
         (ref) => MockRecordListViewModel(),
       ),
     ],
     child: const RecordListPage(),
   )
   ```

詳細は[Riverpodのテストドキュメント](https://riverpod.dev/ja/docs/essentials/testing)を参照してください。

## 開発フローとの連携

メインアプリの開発フローは[app/CLAUDE.md](../app/CLAUDE.md)を参照してください。

### Widgetbook固有の注意点

- Page/Component作成後は必ず対応するUseCaseを作成（最低限Default）
- `make gen`実行後、`lib/main.directories.g.dart`に自動登録されているか確認

## ベストプラクティス

### 1. UseCase作成のガイドライン

各コンポーネント/ページには：

- **Default**: 必須（基本的な状態を表示）
- **Loading**: 任意（データ読み込み中の状態がある場合）
- **Error**: 任意（エラー状態がある場合）
- **Empty**: 任意（空状態がある場合）

### 2. データ設計のガイドライン

- モックデータは現実的な内容にする
- 日本語・英語の両方を含める（i18nテスト用）
- エッジケース（長いテキスト、特殊文字など）も考慮

### 3. 命名規則

- UseCase関数名: `build<ComponentName><State>UseCase`
- モッククラス名: `Mock<OriginalClassName>`
- ファイル名: メインアプリと同じ名前を使用
