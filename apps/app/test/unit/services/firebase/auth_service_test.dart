import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/services/firebase/auth_service.dart';

// FirebaseAuth用のFake実装
class FakeFirebaseAuth implements FirebaseAuth {
  User? _currentUser;
  final List<void Function(User?)> _authStateListeners = [];
  final List<void Function(User?)> _userChangeListeners = [];
  
  bool _shouldThrowOnSignIn = false;
  bool _shouldThrowOnSignOut = false;
  bool _shouldThrowOnDelete = false;
  FirebaseAuthException? _exceptionToThrow;

  void setCurrentUser(User? user) {
    _currentUser = user;
    _notifyAuthStateListeners(user);
    _notifyUserChangeListeners(user);
  }

  void setShouldThrowOnSignIn(bool shouldThrow, [FirebaseAuthException? exception]) {
    _shouldThrowOnSignIn = shouldThrow;
    _exceptionToThrow = exception;
  }

  void setShouldThrowOnSignOut(bool shouldThrow, [FirebaseAuthException? exception]) {
    _shouldThrowOnSignOut = shouldThrow;
    _exceptionToThrow = exception;
  }

  void setShouldThrowOnDelete(bool shouldThrow, [FirebaseAuthException? exception]) {
    _shouldThrowOnDelete = shouldThrow;
    _exceptionToThrow = exception;
  }

  void _notifyAuthStateListeners(User? user) {
    for (final listener in _authStateListeners) {
      listener(user);
    }
  }

  void _notifyUserChangeListeners(User? user) {
    for (final listener in _userChangeListeners) {
      listener(user);
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return Stream.multi((controller) {
      controller.add(_currentUser);
      void listener(User? user) => controller.add(user);
      _authStateListeners.add(listener);
      controller.onCancel = () => _authStateListeners.remove(listener);
    });
  }

  @override
  Stream<User?> userChanges() {
    return Stream.multi((controller) {
      controller.add(_currentUser);
      void listener(User? user) => controller.add(user);
      _userChangeListeners.add(listener);
      controller.onCancel = () => _userChangeListeners.remove(listener);
    });
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Future<UserCredential> signInAnonymously() async {
    if (_shouldThrowOnSignIn && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    final user = FakeUser(
      uid: 'anonymous-uid',
      isAnonymous: true,
      metadata: FakeUserMetadata(),
    );
    setCurrentUser(user);
    return FakeUserCredential(user: user);
  }

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async {
    if (_shouldThrowOnSignIn && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    final user = FakeUser(
      uid: 'web-user',
      email: 'web@example.com',
      isAnonymous: false,
      metadata: FakeUserMetadata(),
      providerData: [
        FakeUserInfo(
          providerId: provider is GoogleAuthProvider ? 'google.com' : 'apple.com',
          uid: 'web-user',
        ),
      ],
    );
    setCurrentUser(user);
    return FakeUserCredential(user: user);
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    if (_shouldThrowOnSignIn && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    final user = FakeUser(
      uid: 'credential-user',
      email: 'credential@example.com',
      isAnonymous: false,
      metadata: FakeUserMetadata(),
      providerData: [
        FakeUserInfo(
          providerId: 'google.com',
          uid: 'credential-user',
        ),
      ],
    );
    setCurrentUser(user);
    return FakeUserCredential(user: user);
  }

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async {
    if (_shouldThrowOnSignIn && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    final user = FakeUser(
      uid: 'provider-user',
      email: 'provider@example.com',
      isAnonymous: false,
      metadata: FakeUserMetadata(),
      providerData: [
        FakeUserInfo(
          providerId: provider is AppleAuthProvider ? 'apple.com' : 'google.com',
          uid: 'provider-user',
        ),
      ],
    );
    setCurrentUser(user);
    return FakeUserCredential(user: user);
  }

  @override
  Future<void> signOut() async {
    if (_shouldThrowOnSignOut && _exceptionToThrow != null) {
      throw _exceptionToThrow!;
    }
    setCurrentUser(null);
  }

  // 未実装のメソッド（テストに不要）
  @override
  FirebaseApp get app => throw UnimplementedError();
  
  @override
  set app(FirebaseApp value) => throw UnimplementedError();
  
  @override
  String? get customAuthDomain => null;
  
  @override
  set customAuthDomain(String? value) => throw UnimplementedError();

  @override
  Future<void> applyActionCode(String code) => throw UnimplementedError();

  @override
  Future<ActionCodeInfo> checkActionCode(String code) => throw UnimplementedError();

  @override
  Future<void> confirmPasswordReset({required String code, required String newPassword}) => throw UnimplementedError();

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) => throw UnimplementedError();

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) => throw UnimplementedError();

  @override
  Future<UserCredential> getRedirectResult() => throw UnimplementedError();

  @override
  Stream<User?> idTokenChanges() => throw UnimplementedError();

  @override
  bool isSignInWithEmailLink(String emailLink) => throw UnimplementedError();

  @override
  String? get languageCode => null;

  // Removed deprecated methods

  @override
  Future<void> revokeTokenWithAuthorizationCode(String authorizationCode) => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail({required String email, ActionCodeSettings? actionCodeSettings}) => throw UnimplementedError();

  @override
  Future<void> sendSignInLinkToEmail({required String email, required ActionCodeSettings actionCodeSettings}) => throw UnimplementedError();

  @override
  Future<void> setLanguageCode(String? languageCode) => throw UnimplementedError();

  @override
  Future<void> setPersistence(Persistence persistence) => throw UnimplementedError();

  @override
  Future<void> setSettings({bool? appVerificationDisabledForTesting, String? userAccessGroup, String? phoneNumber, String? smsCode, bool? forceRecaptchaFlow}) => throw UnimplementedError();

  // Removed deprecated method

  @override
  Future<UserCredential> signInWithCustomToken(String token) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithEmailLink({required String email, required String emailLink}) => throw UnimplementedError();

  @override
  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithRedirect(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<void> useAuthEmulator(String host, int port, {bool automaticHostMapping = true}) => throw UnimplementedError();

  @override
  Future<String> verifyPasswordResetCode(String code) => throw UnimplementedError();

  @override
  Future<void> verifyPhoneNumber({String? phoneNumber, Duration timeout = const Duration(seconds: 30), int? forceResendingToken, required void Function(String, int?) codeSent, required void Function(String) codeAutoRetrievalTimeout, required void Function(FirebaseAuthException) verificationFailed, required void Function(PhoneAuthCredential) verificationCompleted, String? autoRetrievedSmsCodeForTesting, MultiFactorSession? multiFactorSession, PhoneMultiFactorInfo? multiFactorInfo}) => throw UnimplementedError();

  @override
  String? get tenantId => null;

  @override
  set tenantId(String? tenantId) => throw UnimplementedError();

  // Removed deprecated getters
  
  @override
  Map get pluginConstants => {};
}

// User用のFake実装
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

  @override
  Future<void> delete() async {
    final fakeAuth = FakeFirebaseAuth();
    if (fakeAuth._shouldThrowOnDelete && fakeAuth._exceptionToThrow != null) {
      throw fakeAuth._exceptionToThrow!;
    }
  }

  // 未実装のメソッド
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
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();

  @override
  String? get tenantId => null;

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
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) => throw UnimplementedError();
}

// UserInfo用のFake実装
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

// UserMetadata用のFake実装
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

// UserCredential用のFake実装
class FakeUserCredential implements UserCredential {
  @override
  final User? user;

  FakeUserCredential({required this.user});

  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;
}

void main() {
  late FakeFirebaseAuth fakeAuth;
  late AuthService authService;

  setUp(() {
    fakeAuth = FakeFirebaseAuth();
    authService = AuthService(firebaseAuth: fakeAuth);
  });

  group('AuthService', () {
    group('authStateChanges', () {
      test('認証状態の変更を監視できる', () async {
        final states = <User?>[];
        authService.authStateChanges.listen(states.add);

        // 初期状態（未ログイン）
        await Future.delayed(const Duration(milliseconds: 10));
        expect(states.length, 1);
        expect(states[0], isNull);

        // ユーザーをセット
        final user = FakeUser(
          uid: 'test-uid',
          email: 'test@example.com',
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        await Future.delayed(const Duration(milliseconds: 10));
        expect(states.length, 2);
        expect(states[1]?.uid, 'test-uid');
      });
    });

    group('userChanges', () {
      test('ユーザー情報の変更を監視できる', () async {
        final states = <User?>[];
        authService.userChanges.listen(states.add);

        await Future.delayed(const Duration(milliseconds: 10));
        expect(states.length, 1);
        expect(states[0], isNull);

        final user = FakeUser(
          uid: 'test-uid',
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        await Future.delayed(const Duration(milliseconds: 10));
        expect(states.length, 2);
        expect(states[1]?.uid, 'test-uid');
      });
    });

    group('currentUser', () {
      test('現在のユーザーを取得できる', () {
        final user = FakeUser(
          uid: 'test-uid',
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        expect(authService.currentUser?.uid, 'test-uid');
      });

      test('ユーザーがいない場合はnullを返す', () {
        expect(authService.currentUser, isNull);
      });
    });

    group('signInAnonymously', () {
      test('匿名でサインインできる', () async {
        final user = await authService.signInAnonymously();

        expect(user, isNotNull);
        expect(user!.uid, 'anonymous-uid');
        expect(user.isAnonymous, true);
      });

      test('サインインエラーが伝播される', () async {
        fakeAuth.setShouldThrowOnSignIn(
          true,
          FirebaseAuthException(code: 'operation-not-allowed'),
        );

        expect(
          () => authService.signInAnonymously(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signOut', () {
      test('サインアウトできる', () async {
        final user = FakeUser(
          uid: 'test-uid',
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        await authService.signOut();

        expect(authService.currentUser, isNull);
      });

      test('サインアウトエラーが伝播される', () async {
        fakeAuth.setShouldThrowOnSignOut(
          true,
          FirebaseAuthException(code: 'internal-error'),
        );

        expect(
          () => authService.signOut(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('linkAccount', () {
      test('currentUserがnullの場合は何もしない', () async {
        // エラーがスローされないことを確認
        await expectLater(
          authService.linkAccount(AuthType.google),
          completes,
        );
      });

      test('匿名アカウントはリンクできない', () async {
        final user = FakeUser(
          uid: 'anonymous-uid',
          isAnonymous: true,
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        expect(
          () => authService.linkAccount(AuthType.anonymous),
          throwsException,
        );
      });
    });

    group('reauthenticate', () {
      test('currentUserがnullの場合は何もしない', () async {
        await expectLater(
          authService.reauthenticate(AuthType.google),
          completes,
        );
      });

      test('匿名アカウントは再認証できない', () async {
        final user = FakeUser(
          uid: 'anonymous-uid',
          isAnonymous: true,
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        expect(
          () => authService.reauthenticate(AuthType.anonymous),
          throwsException,
        );
      });
    });

    group('deleteAccount', () {
      test('ユーザーがいない場合は何もしない', () async {
        await expectLater(
          authService.deleteAccount(),
          completes,
        );
      });

      test('アカウントを削除できる', () async {
        final user = FakeUser(
          uid: 'test-uid',
          metadata: FakeUserMetadata(),
        );
        fakeAuth.setCurrentUser(user);

        // 現状のFake実装では削除は成功するがユーザーの状態は変わらない
        await expectLater(
          authService.deleteAccount(),
          completes,
        );
      });
    });
  });

  group('FirebaseAuthUserEx', () {
    test('Googleプロバイダー情報を取得できる', () {
      final user = FakeUser(
        uid: 'test-uid',
        metadata: FakeUserMetadata(),
        providerData: [
          FakeUserInfo(
            providerId: 'google.com',
            uid: 'test-uid',
          ),
          FakeUserInfo(
            providerId: 'apple.com',
            uid: 'test-uid',
          ),
        ],
      );

      expect(user.google?.providerId, 'google.com');
    });

    test('Appleプロバイダー情報を取得できる', () {
      final user = FakeUser(
        uid: 'test-uid',
        metadata: FakeUserMetadata(),
        providerData: [
          FakeUserInfo(
            providerId: 'google.com',
            uid: 'test-uid',
          ),
          FakeUserInfo(
            providerId: 'apple.com',
            uid: 'test-uid',
          ),
        ],
      );

      expect(user.apple?.providerId, 'apple.com');
    });

    test('プロバイダーがない場合はnullを返す', () {
      final user = FakeUser(
        uid: 'test-uid',
        metadata: FakeUserMetadata(),
        providerData: [],
      );

      expect(user.google, isNull);
      expect(user.apple, isNull);
    });
  });
}