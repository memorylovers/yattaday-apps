# Flutter関連ツール

## 開発ツール一覧

### パッケージ管理・ビルド

| ツール | 用途 | コマンド |
|--------|------|----------|
| **Melos** | Monorepo管理 | `melos bootstrap` |
| **build_runner** | コード生成 | `dart run build_runner build` |
| **flutter_gen** | アセット生成 | `fluttergen` |
| **slang** | 多言語ファイル生成 | `dart run slang` |

### 状態管理・DI

| ツール | 用途 | 説明 |
|--------|------|------|
| **Riverpod** | 状態管理 | Provider v2の後継 |
| **riverpod_generator** | Providerコード生成 | アノテーションベース |
| **hooks_riverpod** | Flutter Hooks統合 | useStateなどのHooks |

### データモデル・シリアライズ

| ツール | 用途 | 説明 |
|--------|------|------|
| **freezed** | Immutableクラス | データクラス生成 |
| **json_serializable** | JSON変換 | toJson/fromJson生成 |
| **json_annotation** | JSONアノテーション | フィールドマッピング |

### ルーティング

| ツール | 用途 | 説明 |
|--------|------|------|
| **go_router** | 宣言的ルーティング | Navigator 2.0対応 |
| **go_router_builder** | タイプセーフルート | コード生成でルート定義 |

### テスト・品質管理

| ツール | 用途 | 説明 |
|--------|------|------|
| **flutter_test** | 単体・Widget テスト | 標準テストフレームワーク |
| **mocktail** | モック生成 | Mockitoの代替 |
| **custom_lint** | カスタムLintルール | プロジェクト固有のルール |
| **riverpod_lint** | Riverpod専用Lint | Riverpodのベストプラクティス |

## Makefileコマンド

プロジェクトルートで使用可能なコマンド：

```bash
# 初期セットアップ
make            # 依存関係のインストール

# 開発コマンド
make run        # アプリ実行（開発環境）
make book       # Widgetbook起動
make gen        # コード生成
make format     # コードフォーマット
make lint       # 静的解析
make test       # テスト実行

# 計画・ドキュメント
make plan-new name=<名前>  # 新規計画ドキュメント作成
make claude-read          # CLAUDE.mdの内容確認

# E2Eテスト
make e2e        # Maestroテスト実行

# その他
make clean      # ビルドキャッシュクリア
make upgrade    # 依存関係の更新
```

## コード生成

### 1. build_runner

```bash
# 単一パッケージで実行
cd app
dart run build_runner build

# 変更監視モード
dart run build_runner watch

# コンフリクト解決
dart run build_runner build --delete-conflicting-outputs
```

### 2. 生成されるファイル

| パターン | 生成元 | 内容 |
|----------|--------|------|
| `*.freezed.dart` | freezed | Immutableクラス |
| `*.g.dart` | json_serializable | JSON変換 |
| `*.g.dart` | riverpod_generator | Provider |
| `*.gr.dart` | go_router_builder | ルート定義 |

### 3. 生成タイミング

- 新規モデル作成時
- Providerアノテーション追加時
- ルート定義変更時
- アセット追加時

## 静的解析とLint

### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.gr.dart"
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_empty_else
    - avoid_relative_lib_imports
    - avoid_types_as_parameter_names
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - close_sinks
    - directives_ordering
    - empty_statements
    - hash_and_equals
    - no_duplicate_case_values
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_single_quotes
    - sort_constructors_first
    - unnecessary_const
    - unnecessary_new
    - use_key_in_widget_constructors

custom_lint:
  rules:
    - riverpod_provider_name_should_end_with_provider
    - riverpod_avoid_manual_providers_as_generated_provider_dependency
```

### カスタムLintルール

```dart
// analysis_options.yaml でカスタムルールを有効化
custom_lint:
  rules:
    # ファイル名とクラス名の一致
    - file_name_matches_class_name
    
    # 未使用のProvider警告
    - unused_provider
    
    # 非推奨パターンの検出
    - avoid_ref_read_in_build
```

## デバッグツール

### Flutter Inspector

```dart
// デバッグ情報の表示
void main() {
  // Widget境界線を表示
  debugPaintSizeEnabled = true;
  
  // パフォーマンスオーバーレイ
  debugShowPerformanceOverlay = true;
  
  runApp(const MyApp());
}
```

### Riverpod DevTools

```dart
// ProviderScopeにオブザーバーを追加
void main() {
  runApp(
    ProviderScope(
      observers: [
        // Riverpodのログ出力
        const ProviderLogger(),
      ],
      child: const MyApp(),
    ),
  );
}

// カスタムオブザーバー
class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('${provider.name ?? provider.runtimeType}: $newValue');
  }
}
```

### Talker（ロギング）

```dart
// グローバルロガー
final talker = Talker();

// 使用例
talker.info('情報メッセージ');
talker.warning('警告メッセージ');
talker.error('エラーメッセージ', error, stackTrace);

// Flutterバインディング
TalkerFlutter.init();

// UIでログ表示
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TalkerScreen(talker: talker),
  ),
);
```

## パフォーマンス最適化

### flutter_gen（アセット最適化）

```yaml
# pubspec.yaml
flutter_gen:
  output: lib/_gen/assets/
  integrations:
    flutter_svg: true
    flare_flutter: false
    rive: false

  assets:
    enabled: true
    outputs:
      class_name: Assets
      
  fonts:
    enabled: true
```

使用例：
```dart
// 型安全なアセット参照
Image.asset(Assets.images.logo);
Icon(Assets.icons.home);
```

### コード分割（Deferred Loading）

```dart
// 遅延ロードするライブラリ
import 'package:app/features/premium/premium_feature.dart' deferred as premium;

// 必要時にロード
Future<void> loadPremiumFeature() async {
  await premium.loadLibrary();
  premium.showPremiumScreen();
}
```

## CI/CD統合

### GitHub Actions

```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk
```

### pre-commit hooks

```bash
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-format
        name: Flutter Format
        entry: flutter format .
        language: system
        pass_filenames: false
      
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
```

## トラブルシューティング

### よくある問題と解決策

#### 1. コード生成エラー

```bash
# キャッシュクリア
flutter clean
dart run build_runner clean

# 再生成
dart run build_runner build --delete-conflicting-outputs
```

#### 2. 依存関係の競合

```bash
# pubspec.lockを削除
rm pubspec.lock

# 依存関係を再解決
flutter pub get

# または dependency_overrides を使用
dependency_overrides:
  package_name: ^version
```

#### 3. Riverpodの循環参照

```dart
// ❌ 悪い例
final aProvider = Provider((ref) => ref.watch(bProvider));
final bProvider = Provider((ref) => ref.watch(aProvider));

// ✅ 良い例：遅延初期化
final aProvider = Provider((ref) {
  return AService(() => ref.read(bProvider));
});
```

#### 4. メモリリーク

```dart
// StreamSubscriptionは必ずdispose
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) {});
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```