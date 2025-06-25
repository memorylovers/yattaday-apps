# レイヤードアーキテクチャ

## 概要

責務を明確に分離したレイヤードアーキテクチャを採用し、各層が特定の役割を担い、一方向の依存関係を維持することで、保守性とテスタビリティを向上させています。

## 層の構成

レイヤードアーキテクチャは以下の8つの層から構成されます：

1. **Models**: ビジネスモデル、エンティティ、ドメインロジック
2. **Repository**: データアクセス層（CQRSパターン）
3. **Store**: グローバル状態管理
4. **Flow**: 複数画面間の一時的な状態管理
5. **ViewModel**: 画面固有の状態管理
6. **Component**: UIコンポーネント
7. **Page**: UIページ（画面）
8. **Services**: 外部サービス抽象化

## 共通設計方針

### データ転送オブジェクト（DTO）

各層で複雑なパラメータを扱う場合、DTOを使用します。
DTOは使用する層に配置し、上位層は下位層のDTOを参照可能です。

## 各層の詳細

### Models: ビジネスモデル層

**責務:**

- ドメインモデル、エンティティ、データクラスの定義
- 基本的な計算ロジックやビジネスロジック
- 値の検証、状態判定

**実装例:**

```dart
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

**依存関係:** なし（最内層）（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Repository: データアクセス層

**責務:**

- 外部データソースへのアクセス（API、DB、SharedPreference）
- CQRSパターンによるQuery（読み取り）とCommand（更新）の分離
- データ変換、検証、計算などのデータ中心のビジネスロジック

**実装方針:**

CQRSパターンを採用し、データの読み取りと更新の責任を分離します：

- **Query Repository**: データ取得、検索、集計を担当（`get`, `watch`, `search`, `count`）
- **Command Repository**: 作成、更新、削除を担当（`create`, `update`, `delete`）
- 責務の明確化により、それぞれ独立した最適化が可能
- 複合処理（例：`createIfNotExists`）はCommandRepositoryに配置
- Store層での複数Repository組み合わせは避ける

**データ集約とトランザクション境界:**

- **データ集約の責務**: 複数のドキュメント/テーブルから完全なモデルを構築する責任はRepository層が持つ
- QueryRepositoryが関連データを取得・結合し、完全なドメインモデルとして返す
- 上位層（Store/ViewModel）はデータの物理的な分散を意識しない
- **トランザクション境界の管理**: 関連エンティティの整合性が必要な場合は、Repository層でトランザクションを完結させる
- 複数エンティティの更新が必要な場合、CommandRepository内で一つのトランザクションとして処理

**実装例:**

```dart
// Query Repository - 読み取り専用
class RecordItemQueryRepository {
  final FirestoreService _firestoreService;
  
  RecordItemQueryRepository(this._firestoreService);
  
  // データのリアルタイム監視
  Stream<List<RecordItem>> watchByUserId(String userId) {
    return _firestoreService.watchCollection(
      RecordItem.collectionPath(userId),
    );
  }
  
  // 条件検索
  Future<List<RecordItem>> searchByTitle(String userId, String keyword) async {
    // 検索ロジックの実装
  }
}

// Command Repository - 更新専用
class RecordItemCommandRepository {
  final FirestoreService _firestoreService;
  
  RecordItemCommandRepository(this._firestoreService);
  
  // 作成
  Future<void> create(RecordItem item) async {
    await _firestoreService.setDocument(
      RecordItem.collectionPath(item.userId),
      item.id,
      item.toJson(),
    );
  }
  
  // 存在しなければ作成（複合処理の例）
  Future<void> createIfNotExists(RecordItem item) async {
    final exists = await _firestoreService.documentExists(
      RecordItem.collectionPath(item.userId),
      item.id,
    );
    
    if (!exists) {
      await create(item);
    }
  }
}
```

**依存関係:** models, services（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Store: グローバル状態管理層

**責務:**

- アプリ全体で共有されるグローバルな状態管理
- 複数view_modelで共有される状態
- 別モジュールから参照される状態（公開ポイント）
- アプリケーション固有のビジネスルール

**設計原則:**

1. **責任範囲の明確化**
   - 各Storeは単一の責任領域を持つ
   - 認証、アカウント情報、決済状態など、明確に分離
   - 責任の境界を越えた処理は行わない

2. **単方向データフロー**
   - Store間の依存は単方向を維持
   - 下位のStoreが上位のStoreを直接変更しない
   - イベントや状態監視による間接的な連携

3. **真実の源泉（Single Source of Truth）**
   - 各データの管理責任を1つのStoreに集約
   - 他のStoreは参照のみ、または通知を受けて反応
   - データの重複管理を避ける

4. **状態の初期化と破棄**
   - 明確な初期化順序の定義
   - 適切なタイミングでの状態クリア
   - メモリリークを防ぐ適切な破棄処理

**実装例:**

```dart
// Storeクラスの基本構造
class AuthStore {
  // 現在の状態
  AuthState _state = AuthState.loading();
  
  // 状態の取得
  AuthState get state => _state;
  
  // サインイン処理
  Future<void> signIn(String email, String password) async {
    _state = AuthState.loading();
    try {
      final user = await _authRepository.signIn(email, password);
      _state = AuthState.authenticated(user);
      _notifyListeners();
    } catch (e) {
      _state = AuthState.error(e.toString());
      _notifyListeners();
    }
  }
  
  // 状態変更の通知（実装は状態管理ライブラリに依存）
  void _notifyListeners() {
    // 状態変更を通知
  }
}
```

**Store間の連携パターン:**

- **依存関係による連携**: 上位Storeから下位Storeのメソッドを呼び出し
- **状態監視による連携**: 他Storeの状態変化を監視して反応
- **イベント駆動**: 状態変化を契機に他のStoreが反応

具体的な実装例やユースケース別の詳細なパターンについては、[Store実装パターンガイド](./05_store-implementation-guide.md)を参照してください。

**依存関係:** repository のみ（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Flow: フロー状態管理層

**責務:**

- 特定の画面群でのみ共有される一時的な状態管理
- マルチステップフォーム、チェックアウトフローなど
- フロー完了時に状態をクリア

**実装例:**

```dart
class OnboardingFlow {
  // 現在のフロー状態
  OnboardingState _state = OnboardingState.initial();
  
  OnboardingState get state => _state;

  void nextStep() {
    // ステップ進行ロジック
    _state = _state.copyWith(currentStep: _state.currentStep + 1);
    _notifyListeners();
  }

  void complete() {
    // フロー完了処理
    _clearState(); // 状態クリア
  }
  
  void _clearState() {
    _state = OnboardingState.initial();
    _notifyListeners();
  }
}
```

**依存関係:** store, repository（詳細は[依存関係のルール](#依存関係のルール)を参照）

### ViewModel: 画面状態管理層

**責務:**

- Page/Componentと1対1で対応する画面固有の状態管理
- UI表示に関するロジック（フィルタリング、ソート、フォーマット）
- 画面のイベント処理

**実装例:**

```dart
class RecordListViewModel {
  // 画面の状態
  RecordListState _state = RecordListState.loading();
  
  RecordListState get state => _state;
  
  // 初期化時にデータを読み込み
  RecordListViewModel() {
    _loadItems();
  }

  Future<void> toggleItem(String itemId) async {
    // UI操作の処理
    final updatedItems = _updateItemStatus(itemId);
    _state = _state.copyWith(items: updatedItems);
    _notifyListeners();
  }
  
  Future<void> _loadItems() async {
    // データ読み込み処理
  }
}
```

**依存関係:** store, flow, repository（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Component: UIコンポーネント層

**責務:**

- 再利用可能なUIコンポーネント
- モジュール固有のUI部品
- routingで直接遷移しない要素

**実装例:**

```dart
class RecordItemCard extends StatelessWidget {
  final RecordItem item;
  final VoidCallback? onTap;

  const RecordItemCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // UI実装
  }
}
```

**依存関係:** view_model（必要な場合）（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Page: 画面層

**責務:**

- 画面全体の構築
- ルーティングの遷移先
- Componentを組み合わせてUIを構成

**実装例:**

```dart
class RecordListPage extends ConsumerWidget {
  const RecordListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(recordListViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('記録一覧')),
      body: _buildBody(viewModel),
    );
  }
}
```

**依存関係:** component, view_model（詳細は[依存関係のルール](#依存関係のルール)を参照）

### Services: 外部サービス抽象化層

**責務:**

- 外部ライブラリ（3rd party）のラッパー層
- 単なる薄いラッパーではなく、プロジェクトで必要な機能を集約した専用インターフェース
- 必要な機能のみを型安全な形で公開し、不要な複雑さを隠蔽
- ライブラリ固有の実装詳細を隠蔽
- エラーハンドリングを統一的に処理（AppExceptionへの変換）

**実装例:**

```dart
// 外部ライブラリの複雑な実装を隠蔽し、プロジェクト専用のインターフェースを提供
class SharedPreferenceService {
  final SharedPreferences _prefs;
  
  SharedPreferenceService(this._prefs);
  
  // プロジェクトで必要な型安全なメソッドのみを公開
  Future<void> saveUserSettings(UserSettings settings) async {
    try {
      await _prefs.setString('user_settings', jsonEncode(settings.toJson()));
    } catch (e) {
      // 外部ライブラリの例外をAppExceptionに変換
      throw AppException(
        code: AppErrorCode.storageError,
        message: '設定の保存に失敗しました',
      );
    }
  }
  
  UserSettings? getUserSettings() {
    try {
      final json = _prefs.getString('user_settings');
      if (json == null) return null;
      return UserSettings.fromJson(jsonDecode(json));
    } catch (e) {
      // エラーハンドリングを統一
      throw AppException(
        code: AppErrorCode.dataParseError,
        message: '設定の読み込みに失敗しました',
      );
    }
  }
  
  // プロジェクト固有の便利メソッド
  Future<void> clearAllUserData() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith('user_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
```

**設計の意図:**

1. **抽象化による保護**: 外部ライブラリの変更から上位層を保護
2. **型安全性**: プロジェクトのモデルに合わせた型安全なインターフェース
3. **エラーの統一**: すべての例外をAppExceptionに変換し、一貫したエラーハンドリング
4. **機能の集約**: 複数の低レベル操作を組み合わせた高レベルメソッドの提供

**依存関係:** なし（最下層の一つ）（詳細は[依存関係のルール](#依存関係のルール)を参照）

## 依存関係の方向

```
Page → Component → ViewModel → Flow → Store → Repository → Models
                        ↓         ↓      ↓         ↓
                     Services  Services Services Services
```

- 上位層は下位層に依存できる
- 下位層は上位層を知らない
- **循環参照は絶対に禁止**
- 同一層内での参照は層により異なる（後述）
- **すべての層が必須ではなく、機能の要件に応じて必要な層のみを実装する**

## 依存関係のルール

### 基本ルール

1. **垂直方向の依存**
   - 上位層は下位層に依存できる
   - 下位層は上位層を知らない
   - services層は各層から参照可能（主にrepository層から使用）

2. **循環参照の禁止**
   - すべての層において循環参照は絶対に禁止
   - A → B → A のような参照は設計を見直す

3. **機能間の参照**
   - 別の機能モジュールからはStore層のみ参照可能
   - 他の層は参照禁止

### 同一層内での参照ルール

| 層 | 同一階層参照 | 理由・制約 | 実装例 |
|---|---|---|---|
| **Page** | ❌ 禁止 | 画面は独立、遷移はRouterが管理 | 各Pageは他のPageを直接参照しない |
| **Component** | ✅ 許可 | コンポーネントツリー構築に必要 | 親→子の一方向のみ、循環参照禁止 |
| **ViewModel** | ❌ 禁止 | 画面固有の状態管理 | 共有状態はFlow/Store経由 |
| **Flow** | 🔶 原則禁止 | 特定用途のため事例少 | 明確な理由がある場合のみ許可 |
| **Store** | ✅ 許可 | グローバル状態の連携 | AuthStore → AccountStore等、依存グラフを明確に |
| **Repository** | ⚠️ 慎重に許可 | トランザクション境界を考慮 | 関連エンティティの整合性が必要な場合のみ |
| **Models** | ✅ 許可 | ドメイン構造の表現 | 集約・関連の実装 |

**凡例：**

- ❌ **禁止**：同一階層での参照を認めない
- ✅ **許可**：同一階層での参照を認める（ルールあり）
- 🔶 **原則禁止**：基本的に避けるが、明確な理由があれば許可
- ⚠️ **慎重に許可**：必要性を十分検討した上で許可

### Repository層の特別な考慮事項

Repository層での同一階層参照は以下の場合に限定：

1. **関連エンティティの整合性確保**

   ```dart
   class UserCommandRepository {
     final ProfileCommandRepository _profileRepository;
     
     // ユーザーとプロファイルを同時に作成（トランザクション）
     Future<void> createUserWithProfile(User user, Profile profile) async {
       // トランザクション処理
     }
   }
   ```

2. **注意事項**
   - 煩雑さやバグのリスクが高まる場合は禁止を検討
   - 可能な限りStore層での調整を優先
   - トランザクション境界を明確に意識

### Store層の依存管理

Store間の依存関係は以下のガイドラインに従う：

1. **依存の方向を明確化**
   - 単方向の依存グラフを維持
   - 循環参照は絶対に禁止
   - 依存関係を最小限に保つ

2. **依存パターン**
   - **直接依存**: 上位Storeが下位Storeのメソッドを呼び出し
   - **監視パターン**: 状態変化の監視と反応的な処理
   - **選択的監視**: 必要なプロパティのみを監視してパフォーマンス最適化

3. **実装例**

   ```dart
   class AccountStore {
     final AuthStore _authStore;
     AccountState _state = AccountState.initial();
     
     AccountStore(this._authStore) {
       // AuthStoreの状態変化を監視
       _authStore.addListener(_onAuthStateChanged);
     }
     
     void _onAuthStateChanged() {
       if (_authStore.state is Unauthenticated) {
         _clearAccountData();
       }
     }
     
     void _clearAccountData() {
       _state = AccountState.initial();
       _notifyListeners();
     }
   }
   ```

4. **ベストプラクティス**
   - 初期化順序を明確に定義
   - 状態のクリア処理を適切に実装
   - テスタビリティを考慮した設計

詳細な実装パターンやユースケース別の例については、[Store実装パターンガイド](./05_store-implementation-guide.md)を参照してください。
