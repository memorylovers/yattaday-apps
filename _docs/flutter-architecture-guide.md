# Flutter アーキテクチャ設計ガイド - Store/ViewModel/Repository パターン

## 目次

1. [アーキテクチャ概要](#アーキテクチャ概要)
2. [Store パターン](#store-パターン)
3. [ViewModel パターン](#viewmodel-パターン)
4. [Repository パターン](#repository-パターン)
5. [Flow（中間層）](#flow中間層)
6. [CQRS アプローチ](#cqrs-アプローチ)
7. [実装ガイドライン](#実装ガイドライン)

## アーキテクチャ概要

### 5層アーキテクチャ

```
┌─────────────────────┐
│       View          │ → UI表示
│  (Presentation)     │   - Widget、画面レイアウト
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│    ViewModel        │ → 画面状態管理
│  (Screen State)     │   - UI状態、画面ロジック
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│       Flow          │ → フロー状態管理
│  (Flow State)       │   - 複数画面間の一時的な共有
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│      Store          │ → グローバル状態管理
│  (Global State)     │   - 認証、設定、カート
└──────────┬──────────┘
           │
┌──────────┴──────────┐
│    Repository       │ → データアクセス
│  (Data Access)      │   - API通信、キャッシュ
└─────────────────────┘
```

### 基本原則

1. **単方向データフロー**: View ← ViewModel ← Flow ← Store ← Repository
2. **責任の明確化**: 各層は単一の責任を持つ
3. **依存性の管理**: 上位層は下位層に依存するが、逆は不可
4. **テスタビリティ**: 各層は独立してテスト可能

## View レイヤー

### 責任範囲

ViewはUIの表示とユーザーインタラクションを担当します。**ビジネスロジックを含まず**、ViewModelの状態を表示するだけです。

#### 基本的なView

```dart
class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelを監視
    final viewModel = context.watch<ProductDetailViewModel>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.product?.name ?? 'Loading...'),
      ),
      body: _buildBody(context, viewModel),
    );
  }
  
  Widget _buildBody(BuildContext context, ProductDetailViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(viewModel.errorMessage!),
            ElevatedButton(
              onPressed: viewModel.retry,
              child: Text('再試行'),
            ),
          ],
        ),
      );
    }
    
    final product = viewModel.product;
    if (product == null) return SizedBox.shrink();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          _ProductImages(
            images: product.images,
            selectedIndex: viewModel.selectedImageIndex,
            onImageTap: viewModel.selectImage,
          ),
          _ProductInfo(product: product),
          _AddToCartButton(
            onPressed: viewModel.addToCart,
            isLoading: viewModel.isAddingToCart,
          ),
        ],
      ),
    );
  }
}

// UIコンポーネント（純粋なWidget）
class _ProductImages extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onImageTap;
  
  const _ProductImages({
    required this.images,
    required this.selectedIndex,
    required this.onImageTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // メイン画像
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(images[selectedIndex]),
        ),
        // サムネイル
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onImageTap(index),
                child: Container(
                  width: 80,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: index == selectedIndex 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Image.network(images[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### ViewとViewModelの連携

```dart
// Screen（ViewとViewModelを結合）
class ProductDetailScreen extends StatelessWidget {
  final String productId;
  
  const ProductDetailScreen({required this.productId});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailViewModel(
        productId: productId,
        repository: context.read<ProductRepository>(),
        cartStore: context.read<CartStore>(),
        favoriteStore: context.read<FavoriteStore>(),
      )..loadProduct(), // 初期データ読み込み
      child: ProductDetailView(),
    );
  }
}
```

### Viewの設計原則

1. **ロジックを持たない**: すべてのロジックはViewModelに委譲
2. **テスタブル**: WidgetテストでUIの振る舞いを検証
3. **再利用可能**: 小さなコンポーネントに分割
4. **パフォーマンス**: 必要な部分のみリビルド

```dart
// ❌ 悪い例：Viewにロジックがある
class BadView extends StatelessWidget {
  Widget build(BuildContext context) {
    final price = product.price;
    final tax = price * 0.1;  // ビジネスロジックがView内に！
    final total = price + tax;
    
    return Text('¥${total.toStringAsFixed(0)}');
  }
}

// ✅ 良い例：ViewModelでロジックを処理
class GoodView extends StatelessWidget {
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    
    return Text('¥${viewModel.priceWithTax}');
  }
}
```

## Store パターン

### 責任範囲(Store)

Storeはアプリ全体で共有されるグローバルな状態を管理します。

#### AuthStore（認証状態管理）

```dart
class AuthStore extends ChangeNotifier {
  // 認証情報
  String? accessToken;
  String? refreshToken;
  String? userId;
  String? email;
  AuthStatus status = AuthStatus.unauthenticated;
  
  // 認証操作
  Future<void> signIn(String email, String password) async {
    try {
      final response = await _api.signIn(email, password);
      
      // 認証情報を保存
      accessToken = response.accessToken;
      userId = response.userId;
      this.email = email;
      status = AuthStatus.authenticated;
      
      // 他のStoreに通知
      await accountStore.loadUserProfile(userId);
      await paymentStore.initializeForUser(userId, email);
      
    } catch (e) {
      status = AuthStatus.error;
      throw e;
    }
  }
  
  Future<void> signOut() async {
    await _clearTokens();
    status = AuthStatus.unauthenticated;
    
    // 関連Storeをクリア
    accountStore.clearUserData();
    paymentStore.clearPaymentData();
  }
  
  // セッション復元
  Future<void> restoreSession() async {
    final tokens = await _secureStorage.read(key: 'auth_tokens');
    if (tokens != null) {
      // トークンの有効性確認と復元
    }
  }
}
```

#### AccountStore（アカウント情報管理）

```dart
class AccountStore extends ChangeNotifier {
  User? currentUser;
  List<LinkedProvider> linkedProviders = [];
  UserSettings? settings;
  
  // プロファイル管理
  Future<void> loadUserProfile(String userId) async {
    currentUser = await _api.getUserProfile(userId);
    notifyListeners();
  }
  
  Future<void> updateProfile(String name, String bio) async {
    await _api.updateUserProfile(name, bio);
    currentUser = currentUser?.copyWith(name: name, bio: bio);
    notifyListeners();
  }
  
  // キャッシュからの復元
  Future<void> restoreCachedProfile() async {
    final cached = await _localStorage.read(key: 'user_profile');
    if (cached != null) {
      currentUser = User.fromJson(jsonDecode(cached));
      notifyListeners();
    }
    
    // バックグラウンドで最新情報取得
    _refreshProfileInBackground();
  }
}
```

#### PaymentStore（決済・サブスクリプション管理）

```dart
class PaymentStore extends ChangeNotifier {
  SubscriptionStatus? status;
  String? currentPlanId;
  DateTime? expiresAt;
  List<PaymentMethod> paymentMethods = [];
  
  // サブスクリプション状態の判定
  bool get isPremiumUser => 
    status == SubscriptionStatus.active && 
    currentPlanId == 'premium';
  
  bool get isFreeTier => 
    status == null || 
    status == SubscriptionStatus.expired;
  
  // 購入処理
  Future<bool> purchaseSubscription(String planId) async {
    if (!authStore.isAuthenticated) {
      throw Exception('認証が必要です');
    }
    
    try {
      final result = await _purchases.purchasePackage(planId);
      
      await _api.verifyPurchase(
        userId: authStore.userId!,
        receipt: result.receipt,
      );
      
      status = SubscriptionStatus.active;
      currentPlanId = planId;
      
      await accountStore.refreshUserProfile();
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

### Store間の依存関係

```
AuthStore → AccountStore → PaymentStore
    ↓              ↓
  (signIn)    (loadProfile)
    ↓              ↓
  通知 ────────→ 初期化
```

## ViewModel パターン

### 責任範囲(ViewModel)

ViewModelは特定の画面のUI状態を管理します。**画面と1対1**の関係を維持します。

#### 基本的なViewModel

```dart
class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository repository;
  final CartStore cartStore;
  final FavoriteStore favoriteStore;
  
  // UI状態
  bool isLoading = false;
  String? errorMessage;
  Product? product;
  
  // 画面固有の状態
  int selectedImageIndex = 0;
  bool isDescriptionExpanded = false;
  
  // 初期化
  Future<void> loadProduct(String productId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      product = await repository.getProduct(productId);
    } catch (e) {
      errorMessage = 'データの読み込みに失敗しました';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // UIアクション
  Future<void> addToCart() async {
    if (product == null) return;
    
    try {
      await cartStore.addToCart(product!.id, 1);
      // スナックバー表示など
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  void selectImage(int index) {
    selectedImageIndex = index;
    notifyListeners();
  }
}
```

#### 複雑なViewModel（フォーム管理）

```dart
class ProfileEditViewModel extends ChangeNotifier {
  final AccountStore accountStore;
  
  // フォーム状態
  late TextEditingController nameController;
  late TextEditingController bioController;
  bool hasUnsavedChanges = false;
  bool isLoading = false;
  String? errorMessage;
  
  ProfileEditViewModel({required this.accountStore}) {
    final user = accountStore.currentUser;
    nameController = TextEditingController(text: user?.name);
    bioController = TextEditingController(text: user?.bio);
    
    nameController.addListener(_onFormChanged);
    bioController.addListener(_onFormChanged);
  }
  
  void _onFormChanged() {
    hasUnsavedChanges = 
      nameController.text != accountStore.currentUser?.name ||
      bioController.text != accountStore.currentUser?.bio;
    notifyListeners();
  }
  
  Future<void> saveProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      await accountStore.updateProfile(
        name: nameController.text,
        bio: bioController.text,
      );
      hasUnsavedChanges = false;
    } catch (e) {
      errorMessage = 'プロフィールの更新に失敗しました';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
```

### ViewModelの使用

```dart
class ProfileEditScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 画面生成時にViewModel生成、画面破棄時に自動破棄
      create: (_) => ProfileEditViewModel(
        accountStore: context.read<AccountStore>(),
      ),
      child: _ProfileEditView(),
    );
  }
}
```

## Repository パターン

### 基本的なRepository

```dart
abstract class ProductRepository {
  // データアクセス
  Future<Product> getProduct(String id);
  Future<List<Product>> getProducts({int? limit});
  
  // リアルタイム対応
  Stream<Product> watchProduct(String id);
  Stream<List<Product>> watchProducts({int? limit});
}

// 実装
class FirestoreProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore;
  final Map<String, Product> _cache = {};
  
  @override
  Future<Product> getProduct(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }
    
    final doc = await _firestore.collection('products').doc(id).get();
    final product = Product.fromFirestore(doc);
    _cache[id] = product;
    return product;
  }
  
  @override
  Stream<Product> watchProduct(String id) {
    return _firestore
        .collection('products')
        .doc(id)
        .snapshots()
        .map((doc) => Product.fromFirestore(doc));
  }
}
```

### CQRS アプローチ

#### Query Repository（参照用）

```dart
abstract class ProductQueryRepository {
  Future<Product> findById(String id);
  Future<List<Product>> findByCategory(String categoryId);
  Future<List<Product>> search(ProductSearchCriteria criteria);
  Stream<Product> watchProduct(String id);
}

abstract class OrderQueryRepository {
  Future<Order> findById(String id);
  Future<List<Order>> findByUser(String userId);
  Future<List<Order>> findByDateRange(DateRange range);
  Stream<Order> watchOrderStatus(String orderId);
}
```

#### Command Repository（更新用）

```dart
abstract class InventoryCommands {
  // トランザクショナルな操作
  Future<void> adjustStock(String productId, int adjustment, String reason);
  Future<void> transferStock(String fromId, String toId, int quantity);
  Future<void> receiveStock(List<StockReceipt> receipts);
}

abstract class OrderCommands {
  // 注文集約の操作
  Future<Order> createOrder(CreateOrderRequest request);
  Future<void> cancelOrder(String orderId, CancellationReason reason);
  Future<void> shipOrder(String orderId, ShippingInfo info);
}

// Firestore実装
class FirestoreInventoryCommands implements InventoryCommands {
  @override
  Future<void> transferStock(String fromId, String toId, int quantity) async {
    await _firestore.runTransaction((transaction) async {
      final fromRef = _firestore.collection('products').doc(fromId);
      final toRef = _firestore.collection('products').doc(toId);
      
      final fromDoc = await transaction.get(fromRef);
      final toDoc = await transaction.get(toRef);
      
      final fromStock = fromDoc.data()?['stock'] ?? 0;
      if (fromStock < quantity) {
        throw InsufficientStockException();
      }
      
      transaction.update(fromRef, {'stock': fromStock - quantity});
      transaction.update(toRef, {
        'stock': (toDoc.data()?['stock'] ?? 0) + quantity
      });
      
      // 履歴記録
      transaction.create(_firestore.collection('stockMovements').doc(), {
        'from': fromId,
        'to': toId,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }
}
```

## Flow（中間層）

### 概要

Flowは特定の画面群でのみ共有される一時的な状態を管理します。

```dart
class CheckoutFlow extends ChangeNotifier {
  // フロー内の状態
  ShippingInfo? shipping;
  PaymentMethod? payment;
  DeliveryOption? delivery;
  
  // フローの進行管理
  CheckoutStep currentStep = CheckoutStep.cart;
  
  bool get canProceed => switch (currentStep) {
    CheckoutStep.cart => true,
    CheckoutStep.shipping => shipping != null,
    CheckoutStep.payment => payment != null,
    CheckoutStep.confirm => true,
  };
  
  void nextStep() {
    if (canProceed) {
      currentStep = CheckoutStep.values[currentStep.index + 1];
      notifyListeners();
    }
  }
  
  Future<void> completeCheckout() async {
    // APIに送信
    final order = await _api.createOrder({
      'shipping': shipping?.toJson(),
      'payment': payment?.toJson(),
      'delivery': delivery?.toJson(),
    });
    
    // グローバルStoreを更新
    cartStore.clear();
    
    // フローをクリア
    shipping = null;
    payment = null;
    delivery = null;
    currentStep = CheckoutStep.cart;
  }
}
```

### Flowの使用

```dart
class CheckoutFlowScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    // フロー開始時にFlowを生成
    return ChangeNotifierProvider(
      create: (_) => CheckoutFlow(
        cartStore: context.read<CartStore>(),
        orderRepository: context.read<OrderRepository>(),
      ),
      child: Navigator(
        onGenerateRoute: (settings) {
          return switch (settings.name) {
            '/cart' => MaterialPageRoute(builder: (_) => CartScreen()),
            '/shipping' => MaterialPageRoute(builder: (_) => ShippingScreen()),
            '/payment' => MaterialPageRoute(builder: (_) => PaymentScreen()),
            '/confirm' => MaterialPageRoute(builder: (_) => ConfirmScreen()),
            _ => null,
          };
        },
      ),
    );
  }
}
```

## 参考: CQRS アプローチ

### Repository導出プロセス

#### 1. ドメインモデル分析

```
User ─── Order ─── OrderItem
 │         │           │
 │      Payment     Product ─── Category
 │         │           │
 └─────────┴────── Inventory
```

#### 2. 集約の識別

```dart
// 集約ルート = 独立して存在し、他から参照される
const aggregateRoots = {
  'User': ['User', 'UserProfile', 'UserSettings'],
  'Order': ['Order', 'OrderItem', 'Payment', 'Shipping'],
  'Product': ['Product', 'Inventory'],
  'Category': ['Category'],
};
```

#### 3. Query Repository の導出

各集約ルートに対して読み取り専用のRepositoryを作成：

```dart
// 基本エンティティ用
UserQueryRepository
ProductQueryRepository
OrderQueryRepository
CategoryQueryRepository

// 特殊な参照用
ProductSearchRepository  // 全文検索
ReportingRepository     // 集計・レポート
RecommendationRepository // レコメンド
```

#### 4. Command Repository の導出

ユースケースとトランザクション境界から導出：

```dart
// ユースケース分析
const useCases = {
  '商品登録': ['Product作成', 'Inventory初期化'],
  '在庫調整': ['Inventory更新', '履歴記録'],
  '注文作成': ['Order作成', 'Inventory減少', 'Payment作成'],
  '注文キャンセル': ['Order更新', 'Inventory復元', 'Payment取消'],
};

// Command Repository
ProductCommands      // 商品CRUD
InventoryCommands    // 在庫操作
OrderCommands        // 注文処理
PaymentCommands      // 決済処理
```

## 実装ガイドライン

### ディレクトリ構造

```
lib/
├── presentation/
│   ├── views/          # UI表示（Widget）
│   ├── view_models/    # 画面状態管理
│   ├── flows/          # フロー状態管理
│   └── stores/         # グローバル状態管理
├── domain/
│   ├── models/         # ドメインモデル
│   └── repositories/   # Repository インターフェース
├── infrastructure/
│   ├── firebase/       # Firestore実装
│   └── rest/          # REST API実装
└── main.dart
```

### 依存性注入

```dart
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository（ステートレス）
        Provider(create: (_) => FirestoreProductRepository()),
        Provider(create: (_) => FirestoreOrderRepository()),
        
        // グローバルStore
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProxyProvider<AuthStore, AccountStore>(
          create: (_) => AccountStore(),
          update: (_, auth, account) => account!..authStore = auth,
        ),
        ChangeNotifierProxyProvider<AuthStore, PaymentStore>(
          create: (_) => PaymentStore(),
          update: (_, auth, payment) => payment!..authStore = auth,
        ),
      ],
      child: MaterialApp(/* ... */),
    );
  }
}
```

### テスト戦略

#### Repository テスト

```dart
test('在庫移動', () async {
  final repo = MockInventoryCommands();
  
  when(repo.checkStock('A', 10)).thenAnswer((_) async => true);
  
  await repo.transferStock('A', 'B', 10);
  
  verify(repo.transferStock('A', 'B', 10)).called(1);
});
```

#### Store テスト

```dart
test('カート追加', () async {
  final cartStore = CartStore(mockRepository);
  
  await cartStore.addToCart('product-1', 2);
  
  expect(cartStore.items.length, 1);
  expect(cartStore.totalQuantity, 2);
});
```

#### ViewModel テスト

```dart
test('商品読み込み', () async {
  final vm = ProductDetailViewModel(mockRepository, mockStores);
  
  await vm.loadProduct('123');
  
  expect(vm.isLoading, false);
  expect(vm.product?.id, '123');
});
```

### ベストプラクティス

1. **責任の分離**
   - Store: ビジネスロジックとグローバル状態
   - Flow: フロー固有の一時的状態
   - ViewModel: UI制御と画面固有の状態
   - Repository: データアクセスとキャッシュ

2. **依存関係**
   - 単方向データフロー（上位層 → 下位層）
   - 循環依存を避ける
   - インターフェースを介した疎結合

3. **状態管理**
   - グローバル状態は最小限に
   - 画面固有の状態はViewModel内に
   - 不要になった状態は適切に破棄

4. **エラーハンドリング**
   - 各層で適切にエラーを処理
   - ユーザーフレンドリーなエラーメッセージ
   - リトライ機能の実装

5. **パフォーマンス**
   - 適切なキャッシュ戦略
   - 不要なリビルドを避ける
   - ページネーションの実装

## ビジネスロジックの配置戦略

### ビジネスロジックの分類と配置原則

#### 1. Repository層のビジネスロジック

**データ中心の純粋なビジネスロジック**をRepositoryに配置します。

```dart
class ProductRepository {
  // ✅ データ変換・正規化
  Product _mapApiToModel(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['title'],
      price: _calculatePrice(json['base_price'], json['tax_rate']),
      imageUrl: _buildImageUrl(json['image_path']),
    );
  }
  
  // ✅ 価格計算（純粋関数）
  double _calculatePrice(double basePrice, double taxRate) {
    return basePrice * (1 + taxRate);
  }
  
  // ✅ データの整合性チェック
  bool isValidProduct(Product product) {
    return product.name.isNotEmpty &&
           product.price > 0 &&
           product.categoryId != null;
  }
  
  // ✅ 複数データソースの統合
  Future<Product> getProductWithInventory(String id) async {
    final product = await _api.getProduct(id);
    final inventory = await _inventoryApi.getStock(id);
    
    return product.copyWith(
      stock: inventory.available,
      canPurchase: inventory.available > 0,
    );
  }
}
```

#### 2. Store層のビジネスロジック

**状態管理とアプリケーション固有のビジネスルール**をStoreに配置します。

```dart
class CartStore extends ChangeNotifier {
  final ProductRepository _repository;
  final List<CartItem> _items = [];
  
  // ✅ カート固有のビジネスルール
  double get subtotal {
    return _items.fold(0, (sum, item) => 
      sum + (item.product.price * item.quantity));
  }
  
  // ✅ 送料計算（アプリケーションロジック）
  double get shippingFee {
    if (subtotal >= 5000) return 0;  // 5000円以上で送料無料
    return 500;
  }
  
  // ✅ 割引計算（ビジネスルール）
  double get discount {
    if (_items.length >= 5) return subtotal * 0.1;  // 5個以上で10%OFF
    return 0;
  }
  
  double get total => subtotal + shippingFee - discount;
  
  // ✅ 在庫確認を含むカート追加（複合的なビジネスロジック）
  Future<void> addToCart(String productId, int quantity) async {
    // Repositoryで在庫確認（データ取得）
    final isAvailable = await _repository.checkStock(productId, quantity);
    
    if (!isAvailable) {
      throw InsufficientStockException();
    }
    
    // 購入制限チェック（ビジネスルール）
    final existing = _items.firstWhereOrNull(
      (item) => item.productId == productId
    );
    
    if (existing != null && existing.quantity + quantity > 10) {
      throw PurchaseLimitExceededException('一度に購入できるのは10個までです');
    }
    
    // カート更新
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      final product = await _repository.getProduct(productId);
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
  }
}
```

#### 3. ViewModel層のビジネスロジック

**UI表示に関するロジックのみ**をViewModelに配置します。

```dart
class ProductListViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  final FavoriteStore _favoriteStore;
  
  List<Product> products = [];
  String searchQuery = '';
  SortOrder sortOrder = SortOrder.newest;
  PriceRange? priceFilter;
  
  // ✅ 表示用のフィルタリング（UIロジック）
  List<Product> get displayedProducts {
    var filtered = products;
    
    // 検索フィルター
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    // 価格フィルター
    if (priceFilter != null) {
      filtered = filtered.where((p) => 
        p.price >= priceFilter!.min && p.price <= priceFilter!.max
      ).toList();
    }
    
    // ソート（表示順序のみ）
    switch (sortOrder) {
      case SortOrder.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOrder.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOrder.newest:
        // デフォルト順
        break;
    }
    
    return filtered;
  }
  
  // ✅ 表示形式の変換（UIロジック）
  String getFormattedPrice(double price) {
    return '¥${NumberFormat('#,###').format(price)}';
  }
  
  // ❌ ビジネスロジックは書かない
  // double calculateDiscount(Product product) {
  //   return product.price * 0.1;  // これはStore or Repositoryへ
  // }
}
```

### ドメインモデルの活用

**基本的な計算ロジック**はドメインモデルに配置することも推奨されます。

```dart
// ドメインモデルに基本的なロジックを含める
class Product {
  final String id;
  final String name;
  final double basePrice;
  final double taxRate;
  
  // ✅ エンティティ固有の計算
  double get price => basePrice * (1 + taxRate);
  
  // ✅ 割引価格の計算
  double discountedPrice(double discountRate) {
    return price * (1 - discountRate);
  }
  
  // ✅ 在庫状態の判定
  bool canPurchase(int requestedQuantity) {
    return stock >= requestedQuantity && isActive;
  }
}

class OrderItem {
  final Product product;
  final int quantity;
  final double? appliedDiscountRate;
  
  // ✅ 明細の小計計算
  double get subtotal {
    if (appliedDiscountRate != null) {
      return product.discountedPrice(appliedDiscountRate!) * quantity;
    }
    return product.price * quantity;
  }
}
```

### ビジネスロジック配置のガイドライン

| ロジックの種類 | 配置場所 | 例 |
|--------------|---------|---|
| データ変換・検証 | Repository | APIレスポンスの変換、データ検証 |
| 純粋な計算 | Repository/Domain | 価格計算、日付計算 |
| エンティティ固有の処理 | Domain Model | 商品の割引計算、在庫判定 |
| 状態に依存するルール | Store | カート合計、送料計算 |
| 複数エンティティの調整 | Store | 在庫確認してカート追加 |
| UI表示ロジック | ViewModel | フィルタリング、ソート、フォーマット |
| 画面遷移制御 | ViewModel/Flow | 次画面への遷移判定 |

### アンチパターンと解決策

#### ❌ 悪い例：ロジックの重複

```dart
// Repository
class ProductRepository {
  double calculateDiscountPrice(Product product, double rate) {
    return product.price * (1 - rate);
  }
}

// Store（同じロジックを重複実装）
class CartStore {
  double getDiscountedTotal(double rate) {
    return items.fold(0, (sum, item) => 
      sum + item.product.price * (1 - rate));  // 重複！
  }
}
```

#### ✅ 良い例：ドメインモデルに集約

```dart
// ドメインモデル
class Product {
  double discountedPrice(double rate) => price * (1 - rate);
}

// Repository
class ProductRepository {
  // データ取得のみに専念
  Future<Product> getProduct(String id) async { /* ... */ }
}

// Store
class CartStore {
  double getDiscountedTotal(double rate) {
    return items.fold(0, (sum, item) => 
      sum + item.product.discountedPrice(rate) * item.quantity);
  }
}
```

### 実践的な判断フロー

```
ビジネスロジックを実装する際の判断フロー：

1. このロジックは純粋関数か？
   Yes → Repository or Domain Model
   No  → 次へ

2. 特定のエンティティに固有か？
   Yes → Domain Model
   No  → 次へ

3. アプリケーションの状態に依存するか？
   Yes → Store
   No  → 次へ

4. UI表示のためのロジックか？
   Yes → ViewModel
   No  → Repository
```

この原則により、ビジネスロジックが適切に配置され、重複を避けつつテストしやすい設計が実現できます。

## まとめ

このアーキテクチャにより：

- **保守性**: 責任が明確で変更の影響範囲が限定的
- **テスタビリティ**: 各層が独立してテスト可能
- **スケーラビリティ**: 機能追加が容易
- **移行性**: Firestore → REST APIなどの移行が段階的に可能

各プロジェクトの要件に応じて、必要な部分を採用し、最適なアーキテクチャを構築してください。
