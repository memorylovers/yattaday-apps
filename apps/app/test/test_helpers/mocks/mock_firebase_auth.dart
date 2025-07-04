import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mock_firebase_app.dart';

/// FirebaseAuth用のモック実装
/// 
/// テストで使用するためのシンプルなFirebaseAuthのモック実装。
/// 基本的な認証機能のみを実装している。
class MockFirebaseAuth implements FirebaseAuth {
  User? _currentUser;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  final StreamController<User?> _userChangesController = StreamController<User?>.broadcast();

  MockFirebaseAuth({User? currentUser}) : _currentUser = currentUser {
    _authStateController.add(_currentUser);
    _userChangesController.add(_currentUser);
  }

  void dispose() {
    _authStateController.close();
    _userChangesController.close();
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> authStateChanges() => _authStateController.stream;

  @override
  Stream<User?> userChanges() => _userChangesController.stream;

  @override
  Future<UserCredential> signInAnonymously() async {
    _currentUser = MockUser(
      uid: 'anonymous-${DateTime.now().millisecondsSinceEpoch}',
      isAnonymous: true,
    );
    _authStateController.add(_currentUser);
    _userChangesController.add(_currentUser);
    return MockUserCredential(user: _currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
    _userChangesController.add(null);
  }

  // テスト用のヘルパーメソッド
  void setCurrentUser(User? user) {
    _currentUser = user;
    _authStateController.add(user);
    _userChangesController.add(user);
  }

  // 未実装のメソッド（必要に応じて実装を追加）
  @override
  FirebaseApp get app => MockFirebaseApp();

  @override
  set app(FirebaseApp value) {
    // テストでは何もしない
  }

  @override
  Future<void> applyActionCode(String code) => throw UnimplementedError();

  @override
  Future<ActionCodeInfo> checkActionCode(String code) => throw UnimplementedError();

  @override
  Future<void> confirmPasswordReset({required String code, required String newPassword}) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => throw UnimplementedError();

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

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) => throw UnimplementedError();

  @override
  Future<void> sendSignInLinkToEmail({
    required String email,
    required ActionCodeSettings actionCodeSettings,
  }) => throw UnimplementedError();

  @override
  Future<void> setLanguageCode(String? languageCode) => throw UnimplementedError();

  @override
  Future<void> setPersistence(Persistence persistence) => throw UnimplementedError();

  @override
  Future<void> setSettings({
    bool? appVerificationDisabledForTesting,
    String? userAccessGroup,
    String? phoneNumber,
    String? smsCode,
    bool? forceRecaptchaFlow,
  }) async {
    // テストでは何もしない
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> signInWithCustomToken(String token) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) => throw UnimplementedError();

  @override
  Future<ConfirmationResult> signInWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithRedirect(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<void> useAuthEmulator(String host, int port, {bool automaticHostMapping = true}) => 
      throw UnimplementedError();

  @override
  Future<String> verifyPasswordResetCode(String code) => throw UnimplementedError();

  @override
  Future<void> verifyPhoneNumber({
    String? phoneNumber,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(PhoneAuthCredential) verificationCompleted,
    String? autoRetrievedSmsCodeForTesting,
    MultiFactorSession? multiFactorSession,
    PhoneMultiFactorInfo? multiFactorInfo,
  }) => throw UnimplementedError();

  @override
  String? get tenantId => null;

  @override
  set tenantId(String? tenantId) => throw UnimplementedError();

  @override
  Map get pluginConstants => {};

  @override
  Future<void> revokeTokenWithAuthorizationCode(String authorizationCode) => 
      throw UnimplementedError();

  @override
  String? get customAuthDomain => null;

  @override
  set customAuthDomain(String? customAuthDomain) => throw UnimplementedError();
}

/// User用のモック実装
class MockUser implements User {
  @override
  final String uid;
  @override
  final bool isAnonymous;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;
  @override
  final bool emailVerified;
  @override
  final String? phoneNumber;

  MockUser({
    required this.uid,
    this.isAnonymous = false,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.phoneNumber,
  });

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get refreshToken => null;

  @override
  String? get tenantId => null;

  // 未実装のメソッド
  @override
  Future<void> delete() => throw UnimplementedError();

  @override
  Future<String> getIdToken([bool forceRefresh = false]) => throw UnimplementedError();

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) => 
      throw UnimplementedError();

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(
    String phoneNumber, [
    RecaptchaVerifier? verifier,
  ]) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithRedirect(AuthProvider provider) => throw UnimplementedError();

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) => 
      throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithRedirect(AuthProvider provider) => 
      throw UnimplementedError();

  @override
  Future<void> reload() => throw UnimplementedError();

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) => 
      throw UnimplementedError();

  @override
  Future<User> unlink(String providerId) => throw UnimplementedError();

  @override
  Future<void> updateDisplayName(String? displayName) => throw UnimplementedError();

  @override
  Future<void> updateEmail(String newEmail) => throw UnimplementedError();

  @override
  Future<void> updatePassword(String newPassword) => throw UnimplementedError();

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) => 
      throw UnimplementedError();

  @override
  Future<void> updatePhotoURL(String? photoURL) => throw UnimplementedError();

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) => 
      throw UnimplementedError();

  @override
  Future<void> verifyBeforeUpdateEmail(
    String newEmail, [
    ActionCodeSettings? actionCodeSettings,
  ]) => throw UnimplementedError();
}

/// UserMetadata用のモック実装
class MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now().subtract(const Duration(days: 30));

  @override
  DateTime? get lastSignInTime => DateTime.now();
}

/// UserCredential用のモック実装
class MockUserCredential implements UserCredential {
  @override
  final User? user;

  MockUserCredential({this.user});

  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;
}