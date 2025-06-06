# Flutter プロジェクト構造アーキテクチャ

## 概要

このドキュメントは、[CodeWithAndrea](https://codewithandrea.com/articles/flutter-project-structure/)で推奨されているFlutterプロジェクト構造アーキテクチャをまとめたものです。

## 基本原則

### 1. アーキテクチャベースの構造

- プロジェクト構造はアプリアーキテクチャに基づいて設計する
- UIスクリーンではなく、機能要件に基づいてフィーチャーを定義する
- ドメインレイヤーを中心にコードを整理する

### 2. フィーチャーファースト・アプローチ

- フィーチャーは「ユーザーが特定のタスクを完了するのを助ける機能要件」として定義
- UIから逆算してフィーチャーファースト・アプローチを適用しない

## 推奨プロジェクト構造

```
‣ lib
  ‣ src
    ‣ features
      ‣ feature1
        ‣ presentation      # UI層（ウィジェット、ページ、コントローラ）
        ‣ application       # アプリケーション層（ユースケース、ビジネスロジック）
        ‣ domain           # ドメイン層（モデル、エンティティ）
        ‣ data             # データ層（Repository実装、DTO、データソース）
      ‣ feature2
        ‣ presentation
        ‣ application
        ‣ domain
        ‣ data
    ‣ common_widgets       # 共通ウィジェット
    ‣ constants           # 定数
    ‣ exceptions          # 例外処理
    ‣ routing            # ルーティング
    ‣ utils              # ユーティリティ
```

## 各レイヤーの責務と命名規則

### Presentation層

**責務:**

- ウィジェット、ページ、UI コントローラ
- ユーザーインターフェースの表示とユーザー操作の処理

**命名規則:**

- **ページ**: `feature_name_page.dart`
- **ウィジェット**: `feature_name_widget.dart`
- **コントローラー/プロバイダー**: `feature_name_controller.dart` または `feature_name_provider.dart`
- **フォーム**: `feature_name_form.dart`

### Application層

**責務:**

- ユースケース、ビジネスロジック
- プレゼンテーション層とドメイン層の橋渡し
- 状態管理（Riverpod、BLoC等）

**命名規則:**

- **ユースケース**: `feature_name_usecase.dart`
- **サービス**: `feature_name_service.dart`
- **プロバイダー**: `feature_name_providers.dart`
- **状態管理**: `feature_name_state.dart`

### Domain層

**責務:**

- エンティティ、モデル
- ビジネスルールとドメインロジック
- 他の層に依存しない純粋なDartコード

**命名規則:**

- **エンティティ**: `feature_name.dart`
- **バリューオブジェクト**: `feature_name_vo.dart`
- **リポジトリインターフェース**: `feature_name_repository.dart`
- **ドメインサービス**: `feature_name_domain_service.dart`

### Data層

**責務:**

- Repository実装、DTO、データソース
- 外部データアクセス（API、データベース等）
- ドメイン層のインターフェースを実装

**命名規則:**

- **リポジトリ実装**: `feature_name_repository_impl.dart` または `firebase_feature_name_repository.dart`
- **データソース**: `feature_name_data_source.dart`
- **DTO/モデル**: `feature_name_dto.dart` または `feature_name_model.dart`
- **マッパー**: `feature_name_mapper.dart`

## ベストプラクティス

### 1. ドメインファースト設計

- まずドメインモデルとビジネスロジックを特定する
- 関連するモデル/フィーチャーのフォルダを作成する
- レイヤーサブフォルダを含める

### 2. 共通コードの管理

- 真に共有されるコードのみトップレベルフォルダに配置
- フィーチャー固有のコードはそのフィーチャー内に保持

### 3. テスト構造

- `test`フォルダ内で`lib`フォルダ構造をミラーリングする
- 各レイヤーに対応するテストを作成

### 4. スケーラビリティ

- フィーチャー間の明確な境界を維持
- レイヤー間の依存関係を適切に管理
- アプリの成長に応じて構造を維持

## 実装時の注意点

### フィーチャーの特定方法

1. 機能要件から開始（UIではない）
2. ユーザーが完了したいタスクを特定
3. そのタスクに必要なドメインモデルを定義
4. 関連する機能をグループ化

### 依存関係の管理

- 内側のレイヤーは外側のレイヤーに依存しない
- ドメイン層は最も独立性を保つ
- データ層はドメイン層のインターフェースを実装

### ファイル命名規則

- snake_caseを使用
- レイヤーを明確に示すファイル名
- 生成ファイルには適切な接尾辞（`.g.dart`、`.freezed.dart`）

## 共通命名規則

### 共通命名パターン

- **定数**: `constants.dart` または `feature_name_constants.dart`
- **例外**: `feature_name_exception.dart`
- **ユーティリティ**: `feature_name_utils.dart`
- **テスト**: `feature_name_test.dart`

### 接尾辞の使用例

- **Freezed**: `user.freezed.dart`
- **JSON Serializable**: `user.g.dart`
- **Riverpod Generator**: `user_providers.g.dart`
- **Go Router Builder**: `app_router.g.dart`

この構造により、保守性、テスタビリティ、スケーラビリティの高いFlutterアプリケーションを構築できます。
