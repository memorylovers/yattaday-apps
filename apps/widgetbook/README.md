# Widgetbook

UIカタログとコンポーネントのプレビュー環境です。

## ディレクトリ構成

```
widgetbook/lib/
├── pages/           # アプリケーションのページ一覧
│   ├── login_page.dart
│   ├── payment_page.dart
│   ├── record_items_*.dart
│   └── settings_page.dart
├── components/      # 共通UIコンポーネント
│   ├── buttons/
│   └── dialog/
└── features/        # 機能ごとのウィジェット
    ├── authentication/
    ├── record_items/
    └── startup/
```

### pages/
アプリケーション内の全ページを集約。ページ単位でのUIテストやプレビューが可能。

### components/
アプリ全体で再利用される共通コンポーネント。ボタン、ダイアログ、カードなど。

### features/
各機能（feature）固有のウィジェット。ページ以外の機能固有コンポーネントを配置。

## 使い方

```bash
# Widgetbookを起動
cd widgetbook
fvm flutter run -d macos  # または chrome, ios など
```

## 新しいコンポーネントの追加

1. 適切なディレクトリにWidgetファイルを作成
2. `@widgetbook.UseCase` アノテーションを追加
3. `make gen` でコード生成を実行

## ベストプラクティス

- 最低3つのUseCase（Default、Loading、Error）を作成
- 実際のデータに近いサンプルデータを使用
- インタラクティブな要素にはコールバックを実装
- Proveriderのオーバーライドでさまざまな状態を再現