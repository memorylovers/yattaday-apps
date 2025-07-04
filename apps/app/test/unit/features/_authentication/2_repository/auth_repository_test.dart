import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/features/_authentication/1_models/auth_user.dart';
import 'package:myapp/features/_authentication/2_repository/auth_repository.dart';
import 'package:myapp/services/firebase/auth_service.dart';

// Fake実装
class FakeAuthService implements AuthService {
  User? _currentUser;
  final List<User?> _authStateChanges = [];
  final List<User?> _userChanges = [];
  bool _shouldThrowOnSignIn = false;
  bool _shouldThrowOnSignOut = false;
  bool _shouldThrowOnLinkAccount = false;
  bool _shouldThrowOnDeleteAccount = false;
  AppException? _exceptionToThrow;

  void setCurrentUser(User? user) {
    _currentUser = user;
    _authStateChanges.add(user);
    _userChanges.add(user);
  }

  void setShouldThrowOnSignIn(bool shouldThrow, [AppException? exception]) {
    _shouldThrowOnSignIn = shouldThrow;
    _exceptionToThrow = exception;
  }

  void setShouldThrowOnSignOut(bool shouldThrow, [AppException? exception]) {
    _shouldThrowOnSignOut = shouldThrow;
    _exceptionToThrow = exception;
  }

  void setShouldThrowOnLinkAccount(bool shouldThrow, [AppException? exception]) {
    _shouldThrowOnLinkAccount = shouldThrow;
    _exceptionToThrow = exception;
  }

  void setShouldThrowOnDeleteAccount(bool shouldThrow, [AppException? exception]) {
    _shouldThrowOnDeleteAccount = shouldThrow;
    _exceptionToThrow = exception;
  }

  @override
  Stream<User?> get authStateChanges => Stream.fromIterable(_authStateChanges);

  @override
  Stream<User?> get userChanges => Stream.fromIterable(_userChanges);

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User?> signIn(AuthType authType) async {
    if (_shouldThrowOnSignIn && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    return _currentUser;
  }

  @override
  Future<User?> signInAnonymously() async {
    return signIn(AuthType.anonymous);
  }

  @override
  Future<User?> signInWithGoogle() async {
    return signIn(AuthType.google);
  }

  @override
  Future<User?> signInWithApple() async {
    return signIn(AuthType.apple);
  }

  @override
  Future<void> linkAccount(AuthType authType) async {
    if (_shouldThrowOnLinkAccount && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
  }

  @override
  Future<void> reauthenticate(AuthType authType) async {
    // Not used in repository tests
  }

  @override
  Future<void> signOut() async {
    if (_shouldThrowOnSignOut && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    _currentUser = null;
    _authStateChanges.add(null);
    _userChanges.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    if (_shouldThrowOnDeleteAccount && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    _currentUser = null;
    _authStateChanges.add(null);
    _userChanges.add(null);
  }
}

// テスト用のUserクラス
class FakeUser implements User {
  @override
  final String uid;

  @override
  final String? email;

  @override
  final String? displayName;

  @override
  final String? photoURL;

  @override
  final bool isAnonymous;

  @override
  final bool emailVerified;

  @override
  final String? phoneNumber;

  @override
  final UserMetadata metadata;

  @override
  final List<UserInfo> providerData;

  FakeUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.isAnonymous = false,
    this.emailVerified = false,
    this.phoneNumber,
    required this.metadata,
    this.providerData = const [],
  });

  // 未実装のメソッド（テストに不要）
  @override
  Future<void> delete() => throw UnimplementedError();

  @override
  Future<String> getIdToken([bool forceRefresh = false]) => throw UnimplementedError();

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) => throw UnimplementedError();

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithRedirect(AuthProvider provider) => throw UnimplementedError();

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithRedirect(AuthProvider provider) => throw UnimplementedError();

  @override
  String? get refreshToken => null;

  @override
  Future<void> reload() => throw UnimplementedError();

  @override
  Future<User> unlink(String providerId) => throw UnimplementedError();

  @override
  Future<void> updateDisplayName(String? displayName) => throw UnimplementedError();

  @override
  Future<void> updateEmail(String newEmail) => throw UnimplementedError();

  @override
  Future<void> updatePassword(String newPassword) => throw UnimplementedError();

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) => throw UnimplementedError();

  @override
  Future<void> updatePhotoURL(String? photoURL) => throw UnimplementedError();

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) => throw UnimplementedError();

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();

  @override
  String? get tenantId => null;
}

// テスト用のUserInfoクラス
class FakeUserInfo implements UserInfo {
  @override
  final String? displayName;

  @override
  final String? email;

  @override
  final String? phoneNumber;

  @override
  final String? photoURL;

  @override
  final String providerId;

  @override
  final String uid;

  FakeUserInfo({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    required this.providerId,
    required this.uid,
  });
}

// テスト用のUserMetadataクラス
class FakeUserMetadata implements UserMetadata {
  @override
  final DateTime? creationTime;

  @override
  final DateTime? lastSignInTime;

  FakeUserMetadata({
    this.creationTime,
    this.lastSignInTime,
  });
}

void main() {
  late FakeAuthService fakeAuthService;
  late FirebaseAuthRepository repository;

  setUp(() {
    fakeAuthService = FakeAuthService();
    repository = FirebaseAuthRepository(fakeAuthService);
  });

  group('FirebaseAuthRepository', () {
    group('watchAuthState', () {
      test('ログインユーザーの状態変化を監視できる', () {
        final fakeUser = FakeUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          emailVerified: true,
          phoneNumber: '+1234567890',
          metadata: FakeUserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 2),
          ),
          providerData: [
            FakeUserInfo(
              providerId: 'google.com',
              uid: 'test-uid',
            ),
          ],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        expectLater(
          repository.watchAuthState(),
          emits(predicate<AuthUser?>((authUser) {
            expect(authUser, isNotNull);
            expect(authUser!.uid, 'test-uid');
            expect(authUser.email, 'test@example.com');
            expect(authUser.displayName, 'Test User');
            expect(authUser.photoUrl, 'https://example.com/photo.jpg');
            expect(authUser.isAnonymous, false);
            expect(authUser.isEmailVerified, true);
            expect(authUser.phoneNumber, '+1234567890');
            expect(authUser.authTypes, [AuthType.google]);
            expect(authUser.createdAt, DateTime(2024, 1, 1));
            expect(authUser.lastSignInAt, DateTime(2024, 1, 2));
            return true;
          })),
        );
      });

      test('未ログイン状態をnullとして監視できる', () {
        fakeAuthService.setCurrentUser(null);

        expectLater(
          repository.watchAuthState(),
          emits(isNull),
        );
      });

      test('匿名ユーザーの状態を正しく変換する', () {
        final fakeUser = FakeUser(
          uid: 'anonymous-uid',
          email: null,
          displayName: null,
          photoURL: null,
          isAnonymous: true,
          emailVerified: false,
          phoneNumber: null,
          metadata: FakeUserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 1),
          ),
          providerData: [],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        expectLater(
          repository.watchAuthState(),
          emits(predicate<AuthUser?>((authUser) {
            expect(authUser, isNotNull);
            expect(authUser!.uid, 'anonymous-uid');
            expect(authUser.isAnonymous, true);
            expect(authUser.authTypes, [AuthType.anonymous]);
            return true;
          })),
        );
      });
    });

    group('getCurrentUser', () {
      test('現在のログインユーザーを取得できる', () async {
        final fakeUser = FakeUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          emailVerified: true,
          phoneNumber: null,
          metadata: FakeUserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 2),
          ),
          providerData: [
            FakeUserInfo(
              providerId: 'apple.com',
              uid: 'test-uid',
            ),
          ],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        final authUser = await repository.getCurrentUser();

        expect(authUser, isNotNull);
        expect(authUser!.uid, 'test-uid');
        expect(authUser.email, 'test@example.com');
        expect(authUser.authTypes, [AuthType.apple]);
      });

      test('未ログイン時はnullを返す', () async {
        fakeAuthService.setCurrentUser(null);

        final authUser = await repository.getCurrentUser();

        expect(authUser, isNull);
      });

      test('複数の認証プロバイダーを持つユーザーを正しく変換する', () async {
        final fakeUser = FakeUser(
          uid: 'multi-auth-uid',
          email: 'multi@example.com',
          displayName: 'Multi Auth User',
          photoURL: null,
          isAnonymous: false,
          emailVerified: true,
          phoneNumber: null,
          metadata: FakeUserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 2),
          ),
          providerData: [
            FakeUserInfo(
              providerId: 'google.com',
              uid: 'multi-auth-uid',
            ),
            FakeUserInfo(
              providerId: 'apple.com',
              uid: 'multi-auth-uid',
            ),
          ],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        final authUser = await repository.getCurrentUser();

        expect(authUser, isNotNull);
        expect(authUser!.authTypes.length, 2);
        expect(authUser.authTypes.contains(AuthType.google), true);
        expect(authUser.authTypes.contains(AuthType.apple), true);
      });
    });

    group('signIn', () {
      test('Googleでサインインできる', () async {
        final fakeUser = FakeUser(
          uid: 'google-user',
          email: 'google@example.com',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await repository.signIn(AuthType.google);

        // サインイン後もユーザーが設定されていることを確認
        expect(fakeAuthService.currentUser, isNotNull);
      });

      test('Appleでサインインできる', () async {
        final fakeUser = FakeUser(
          uid: 'apple-user',
          email: 'apple@example.com',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await repository.signIn(AuthType.apple);

        expect(fakeAuthService.currentUser, isNotNull);
      });

      test('匿名でサインインできる', () async {
        final fakeUser = FakeUser(
          uid: 'anonymous-user',
          isAnonymous: true,
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await repository.signIn(AuthType.anonymous);

        expect(fakeAuthService.currentUser, isNotNull);
      });

      test('サインインエラーが適切に処理される', () async {
        fakeAuthService.setShouldThrowOnSignIn(
          true,
          const AppException(
            code: AppErrorCode.noAuth,
            message: 'ログインに失敗しました',
          ),
        );

        expect(
          () => repository.signIn(AuthType.google),
          throwsA(isA<AppException>()),
        );
      });
    });

    group('signOut', () {
      test('サインアウトできる', () async {
        final fakeUser = FakeUser(
          uid: 'test-user',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await repository.signOut();

        expect(fakeAuthService.currentUser, isNull);
      });

      test('サインアウトエラーが適切に処理される', () async {
        fakeAuthService.setShouldThrowOnSignOut(
          true,
          const AppException(
            code: AppErrorCode.unknown,
            message: 'サインアウトに失敗しました',
          ),
        );

        expect(
          () => repository.signOut(),
          throwsA(isA<AppException>()),
        );
      });
    });

    group('linkAccount', () {
      test('Googleアカウントをリンクできる', () async {
        final fakeUser = FakeUser(
          uid: 'test-user',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        // エラーがスローされないことを確認
        await expectLater(
          repository.linkAccount(AuthType.google),
          completes,
        );
      });

      test('Appleアカウントをリンクできる', () async {
        final fakeUser = FakeUser(
          uid: 'test-user',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await expectLater(
          repository.linkAccount(AuthType.apple),
          completes,
        );
      });

      test('リンクエラーが適切に処理される', () async {
        fakeAuthService.setShouldThrowOnLinkAccount(
          true,
          const AppException(
            code: AppErrorCode.authAlreadyLinked,
            message: '既にリンクされています',
          ),
        );

        expect(
          () => repository.linkAccount(AuthType.google),
          throwsA(isA<AppException>()),
        );
      });
    });

    group('delete', () {
      test('アカウントを削除できる', () async {
        final fakeUser = FakeUser(
          uid: 'test-user',
          metadata: FakeUserMetadata(),
        );
        fakeAuthService.setCurrentUser(fakeUser);

        await repository.delete();

        expect(fakeAuthService.currentUser, isNull);
      });

      test('削除エラーが適切に処理される', () async {
        fakeAuthService.setShouldThrowOnDeleteAccount(
          true,
          const AppException(
            code: AppErrorCode.noAuth,
            message: '再認証が必要です',
          ),
        );

        expect(
          () => repository.delete(),
          throwsA(isA<AppException>()),
        );
      });
    });

    group('_convertToAuthUser', () {
      test('未知のプロバイダーIDは無視される', () async {
        final fakeUser = FakeUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: null,
          photoURL: null,
          isAnonymous: false,
          emailVerified: false,
          phoneNumber: null,
          metadata: FakeUserMetadata(
            creationTime: null,
            lastSignInTime: null,
          ),
          providerData: [
            FakeUserInfo(
              providerId: 'facebook.com', // 未知のプロバイダー
              uid: 'test-uid',
            ),
          ],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        final authUser = await repository.getCurrentUser();

        expect(authUser, isNotNull);
        expect(authUser!.authTypes, isEmpty);
      });

      test('重複するプロバイダーは除外される', () async {
        final fakeUser = FakeUser(
          uid: 'test-uid',
          email: 'test@example.com',
          displayName: null,
          photoURL: null,
          isAnonymous: false,
          emailVerified: false,
          phoneNumber: null,
          metadata: FakeUserMetadata(
            creationTime: null,
            lastSignInTime: null,
          ),
          providerData: [
            FakeUserInfo(
              providerId: 'google.com',
              uid: 'test-uid',
            ),
            FakeUserInfo(
              providerId: 'google.com', // 重複
              uid: 'test-uid',
            ),
          ],
        );

        fakeAuthService.setCurrentUser(fakeUser);

        final authUser = await repository.getCurrentUser();

        expect(authUser, isNotNull);
        expect(authUser!.authTypes.length, 1);
        expect(authUser.authTypes, [AuthType.google]);
      });
    });
  });
}
