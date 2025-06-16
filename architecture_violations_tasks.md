# Features配下のアーキテクチャ違反箇所の調査結果

調査日: 2025/6/16

## 違反内容の概要

新しいアーキテクチャルールに基づく違反箇所：

- presentationのpage/widgetから直接applicationを参照している箇所が多数存在
- 本来はview_modelを経由してapplicationレイヤーにアクセスすべき

## 違反箇所のタスク一覧

### 1. **_authentication Feature**

#### ✅ settings_page.dart

- **違反内容**: pageから`authStoreProvider`を直接参照
- **該当行**: 174行目でサインアウト処理を実行
- **修正方法**:
  - [x] SettingsViewModelを作成
  - [x] サインアウト処理をViewModelに移行
  - [x] pageはViewModelのメソッドを呼び出すように変更

### 2. **record_items Feature**

#### ✅ record_items_list_page.dart

- **違反内容**: pageから`watchRecordItemsProvider`を直接参照
- **該当行**: 19行目で記録項目をリアルタイム監視
- **修正方法**:
  - [x] RecordItemsListViewModelを作成
  - [x] 記録項目の監視処理をViewModelに移行
  - [x] pageはViewModelの状態を監視するように変更

#### ❌ record_items_detail_page.dart

- **違反内容**: pageから複数のapplication providerを直接参照
- **参照しているProvider一覧**:
  - `recordItemByIdProvider` (26行目)
  - `recordItemStatisticsProvider` (30行目)
  - `watchTodayRecordExistsProvider` (38行目)
  - `authUidProvider` (180, 224, 239行目)
  - `recordItemCrudProvider` (182, 194行目)
  - `deleteRecordItemHistoryUseCaseProvider` (226行目)
  - `createRecordItemHistoryUseCaseProvider` (241行目)
  - `recordedDatesProvider` (256行目)
- **修正方法**:
  - [ ] RecordItemDetailViewModelを作成
  - [ ] すべての状態管理とビジネスロジックをViewModelに移行
  - [ ] pageはViewModelのメソッドと状態のみを使用

#### ❌ record_item_calendar.dart (widget)

- **違反内容**: widgetから`recordedDatesProvider`を直接参照
- **該当行**: 24行目
- **修正方法**:
  - [ ] 親ページのViewModelから必要なデータを引数で受け取る
  - [ ] widgetを純粋なUIコンポーネントに変更

#### ❌ record_item_form.dart (widget)

- **違反内容**: widgetから`recordItemFormProvider`を直接参照
- **該当行**: 複数箇所
- **修正方法**:
  - [ ] 親ページのViewModelから必要なデータとコールバックを引数で受け取る
  - [ ] widgetを純粋なUIコンポーネントに変更

#### ❌ record_item_form_with_semantics.dart (widget)

- **違反内容**: widgetから`recordItemFormProvider`を直接参照
- **該当行**: 複数箇所
- **修正方法**:
  - [ ] 親ページのViewModelから必要なデータとコールバックを引数で受け取る
  - [ ] widgetを純粋なUIコンポーネントに変更

### 3. **Feature間の依存関係の整理**

#### ⚠️ authUidProviderの共有問題

- **問題**: 複数のfeatureから_authenticationのproviderを参照
- **影響範囲**:
  - record_items feature
  - daily_records feature
- **修正方法**:
  - [ ] Option 1: 共通のauth状態をcommonレイヤーに移動
  - [ ] Option 2: 各featureで必要な認証情報を引数として受け取る設計に変更

### 4. **不要なApplicationレイヤーの確認**

#### ⚠️ record_item_form_provider

- **確認事項**:
  - [ ] 複数のview_modelから参照されているか確認
  - [ ] 単一のview_modelからのみ参照の場合は、view_model内に統合を検討

### 5. **テストファイルの修正**

以下のテストファイルも同様の修正が必要：

- [ ] test/features/_authentication/presentation/settings_page_test.dart
- [ ] test/features/record_items/presentation/pages/record_items_list_page_test.dart
- [ ] test/features/record_items/presentation/pages/record_items_detail_page_test.dart
- [ ] test/features/record_items/presentation/widgets/record_item_calendar_test.dart
- [ ] test/features/record_items/presentation/widgets/record_item_form_test.dart

## 実装優先順位

1. **高優先度**: 最も多くのproviderを直接参照している`record_items_detail_page.dart`
2. **中優先度**: `record_items_list_page.dart`と`settings_page.dart`
3. **低優先度**: widget層の修正（calendar, form関連）

## 期待される修正後の構造

```
features/feature_name/
├── presentation/
│   ├── pages/        # ❌ applicationを参照しない
│   ├── widgets/      # ❌ applicationを参照しない
│   └── view_models/  # ✅ applicationを参照可能
├── application/      # 複数のview_modelから参照される場合のみ存在
├── domain/
└── data/
```

## 補足

- view_modelは対応するpageと1:1の関係を持つ
- widgetは純粋なUIコンポーネントとして、必要なデータは引数で受け取る
- applicationレイヤーは本当に複数のview_modelで共有される状態のみを管理する
