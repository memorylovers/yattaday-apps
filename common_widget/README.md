# common_widget

appとwidgetbookで共有する共通UIコンポーネントとアセットを管理するパッケージです。

## 構成

```
lib/
├── _gen/              # 自動生成コード
│   └── assets/       # flutter_genによるアセット管理
├── components/       # 共通UIコンポーネント
│   └── logo/        # ロゴ関連
└── common_widget.dart  # エクスポートファイル
```

## 使用方法

### 依存関係の追加

```yaml
dependencies:
  common_widget:
    path: ../packages/common_widget
```

### インポート

```dart
import 'package:common_widget/common_widget.dart';
```

## コンポーネント

### AppLogo

アプリケーションのロゴを表示するウィジェット

```dart
// デフォルトサイズ（120x120）
const AppLogo()

// カスタムサイズ
const AppLogo(size: 48)

// 幅と高さを個別に指定
const AppLogo(width: 100, height: 50)

// カラー指定
const AppLogo(color: Colors.blue)
```

## アセット

- `icon.svg` - SVG形式のアイコン
- `icon_circle_512.png` - 円形アイコン（512x512）
- `icon_square_512.png` - 正方形アイコン（512x512）
