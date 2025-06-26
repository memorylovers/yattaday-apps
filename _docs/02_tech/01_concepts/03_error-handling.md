# エラーハンドリング戦略

## 基本原則

**🚨 重要**: アプリ内で発生するすべての例外は**必ず`AppException`に変換**すること

## AppException

### 定義

```dart
@freezed
class AppException with _$AppException implements Exception {
  const factory AppException({
    required AppErrorCode code,
    required String message,
    Object? originalError,
    StackTrace? stackTrace,
  }) = _AppException;
}
```

### エラーコード

```dart
enum AppErrorCode {
  // 認証関連
  noAuth,              // ログインが必要
  authAlreadyLinked,   // 別アカウントに連携済み
  
  // データ操作関連
  concurrentUpdate,    // 同時更新エラー
  validationError,     // バリデーションエラー
  
  // 共通エラー
  networkError,        // ネットワークエラー
  notFound,           // データが見つからない
  unknown,            // 予期しないエラー
}
```

## 各層での責任分担

### Service層（外部ライブラリのラッパー）

**責務:** 外部ライブラリの例外を**必ず**AppExceptionに変換

```dart
class FirestoreService {
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (error) {
      // FirebaseExceptionをAppExceptionに変換
      if (error is FirebaseException) {
        throw AppException(
          code: _mapFirebaseErrorCode(error.code),
          message: _getErrorMessage(error.code),
          originalError: error,
          stackTrace: StackTrace.current,
        );
      }
      throw AppException(
        code: AppErrorCode.unknown,
        message: '予期しないエラーが発生しました',
        originalError: error,
        stackTrace: StackTrace.current,
      );
    }
  }
  
  AppErrorCode _mapFirebaseErrorCode(String code) {
    switch (code) {
      case 'permission-denied':
        return AppErrorCode.noAuth;
      case 'network-request-failed':
        return AppErrorCode.networkError;
      case 'not-found':
        return AppErrorCode.notFound;
      default:
        return AppErrorCode.unknown;
    }
  }
}
```

### Repository層

**責務:** Service層の例外をキャッチし、`handleError()`で処理

```dart
class RecordItemCommandRepository {
  final FirestoreService _firestoreService;
  
  Future<void> create(RecordItem item) async {
    try {
      await _firestoreService.addDocument(
        'items',
        item.toJson(),
      );
    } catch (error) {
      handleError(error); // AppExceptionを再スロー
    }
  }
}
```

### Store/Flow層

**責務:** ビジネスロジックエラーを**必ず**AppExceptionとして発生

```dart
@riverpod
class RecordItemStore extends _$RecordItemStore {
  Future<void> createItem(String title) async {
    // バリデーション
    if (title.isEmpty) {
      throw AppException(
        code: AppErrorCode.validationError,
        message: 'タイトルは必須です',
      );
    }
    
    try {
      final item = RecordItem(
        id: uuid.v4(),
        title: title,
        userId: _currentUserId,
      );
      await _repository.create(item);
    } catch (error) {
      handleError(error);
    }
  }
}
```

### ViewModel層

**責務:** **AppExceptionのみ**をキャッチしてUI状態に変換

```dart
@riverpod
class RecordListViewModel extends _$RecordListViewModel {
  @override
  RecordListState build() => const RecordListState.initial();
  
  Future<void> createItem(String title) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _store.createItem(title);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      // AppExceptionのみをキャッチ
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
    }
  }
}
```

### Page/Component層

**責務:** エラー状態の表示のみ（例外処理は行わない）

```dart
class RecordListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordListViewModelProvider);
    
    if (state.error != null) {
      return ErrorWidget(
        error: state.error!,
        onRetry: () => ref.read(recordListViewModelProvider.notifier).retry(),
      );
    }
    
    // 通常のUI表示
  }
}
```

## 共通ヘルパー関数

### handleError

```dart
// common/exception/error_handler.dart
Never handleError(Object error, [StackTrace? stackTrace]) {
  if (error is AppException) {
    // すでにAppExceptionの場合はそのまま再スロー
    throw error;
  }
  
  // 予期しない例外はAppExceptionに変換
  throw AppException(
    code: AppErrorCode.unknown,
    message: '予期しないエラーが発生しました',
    originalError: error,
    stackTrace: stackTrace ?? StackTrace.current,
  );
}
```

## エラー表示のガイドライン

### ユーザーへの表示

```dart
extension AppExceptionMessage on AppException {
  String get userMessage {
    switch (code) {
      case AppErrorCode.noAuth:
        return 'ログインが必要です';
      case AppErrorCode.networkError:
        return 'ネットワークエラーが発生しました。接続を確認してください';
      case AppErrorCode.notFound:
        return 'データが見つかりませんでした';
      case AppErrorCode.validationError:
        return message; // バリデーションエラーは具体的なメッセージを表示
      default:
        return 'エラーが発生しました。しばらくしてからお試しください';
    }
  }
  
  Widget get actionWidget {
    switch (code) {
      case AppErrorCode.noAuth:
        return LoginButton(); // ログイン画面への誘導
      case AppErrorCode.networkError:
        return RetryButton(); // 再試行ボタン
      default:
        return SupportButton(); // サポートへの問い合わせ
    }
  }
}
```

## 例外変換の必須化チェックリスト

- [ ] Service層: すべての外部ライブラリ例外をAppExceptionに変換
- [ ] Repository層: try-catchで`handleError()`を必ず呼び出す
- [ ] Store/Flow層: ビジネスエラーは`throw AppException()`
- [ ] ViewModel層: `on AppException`でのみキャッチ
- [ ] 直接的なthrow: AppException以外の例外は禁止

## ロギングとモニタリング

```dart
// エラーログの送信
void logError(AppException exception) {
  // 開発環境: コンソールに出力
  if (kDebugMode) {
    debugPrint('Error: ${exception.code} - ${exception.message}');
    if (exception.originalError != null) {
      debugPrint('Original: ${exception.originalError}');
    }
  }
  
  // 本番環境: Crashlyticsに送信
  if (!kDebugMode) {
    FirebaseCrashlytics.instance.recordError(
      exception.originalError ?? exception,
      exception.stackTrace,
      reason: exception.message,
      information: [
        'code: ${exception.code}',
        'message: ${exception.message}',
      ],
    );
  }
}
```