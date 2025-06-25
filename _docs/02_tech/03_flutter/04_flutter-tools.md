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

| ツール | 用途 |
|--------|------|
| **flutter_test** | 単体・Widget テスト |
| **mocktail** | モック生成 |
| **custom_lint** | カスタムLintルール |
| **riverpod_lint** | Riverpod専用Lint |

テストツールの詳細な使用方法については[Flutterテスト実装ガイド](./07_test-implementation.md)を参照してください。

## Makefileコマンド

基本的なmakeコマンドについては[開発フロー](../02_development/01_development-flow.md#makeコマンドリファレンス)を参照してください。

### Flutter固有のコマンド

```bash
# Widgetbook（UIカタログ）
make book       # Widgetbook起動

# Maestro E2Eテスト
make e2e        # Maestroテスト実行

# Flutter固有のクリーンアップ
make clean      # Flutterビルドキャッシュクリア
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

プロジェクトでは以下のツールを活用：

- **Flutter DevTools**: パフォーマンス分析とWidgetツリー検査
- **Riverpod DevTools**: Providerの状態監視
- **Talker**: `app/lib/common/logger/`で設定済みのログシステム

## パフォーマンス最適化

### プロジェクトでの最適化方針

- **flutter_gen**: `lib/_gen/assets/`に型安全なアセット参照を生成
- **遅延ロード**: プレミアム機能など、必要時のみロードする機能で使用

## CI/CD統合

- **GitHub Actions**: `.github/workflows/`でFlutter CIを設定
- **Pre-commit フック**: コミット前の自動フォーマットと解析

## トラブルシューティング

一般的な問題解決についてはFlutter公式ドキュメントを参照してください。

プロジェクト固有の問題：

- **コード生成エラー**: `make gen`で解決
- **Riverpodの使用方法**: [Riverpod実装パターン](./02_riverpod-patterns.md)を参照
