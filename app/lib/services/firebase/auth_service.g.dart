// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authServiceHash() => r'82398d9f38c720e4ddf6b218248f15089fd4f178';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthService>;
String _$firebaseAuthHash() => r'8c3e9d11b27110ca96130356b5ef4d5d34a5ffc2';

/// Firebase Authのインスタンス
///
/// Copied from [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$firebaseUserHash() => r'70646ef7b434170dca319f09b5b0b451f3b28be8';

/// Firebase User Stream
///
/// 機密情報が含まれるため、本番環境ではログを抑制する
/// Providerの名称を変える場合は、talkerRiverpodObserver も変更すること
///
/// Copied from [firebaseUser].
@ProviderFor(firebaseUser)
final firebaseUserProvider = AutoDisposeStreamProvider<User?>.internal(
  firebaseUser,
  name: r'firebaseUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseUserRef = AutoDisposeStreamProviderRef<User?>;
String _$firebaseUserUidHash() => r'1e054dcb32c7f69bb984b6ff9fd0f5638a3e1e94';

/// UIDを取得する
///
/// サインインしていない場合はnullを返す
///
/// Copied from [firebaseUserUid].
@ProviderFor(firebaseUserUid)
final firebaseUserUidProvider = AutoDisposeFutureProvider<String?>.internal(
  firebaseUserUid,
  name: r'firebaseUserUidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseUserUidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseUserUidRef = AutoDisposeFutureProviderRef<String?>;
String _$firebaseIdTokenHash() => r'24989a65e647bd2a570c9afd95c3947d15af1dce';

/// idTokenの取得
///
/// Copied from [firebaseIdToken].
@ProviderFor(firebaseIdToken)
final firebaseIdTokenProvider = FutureProvider<String?>.internal(
  firebaseIdToken,
  name: r'firebaseIdTokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseIdTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseIdTokenRef = FutureProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
