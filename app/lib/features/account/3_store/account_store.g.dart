// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAccountHash() => r'288a0c2e77d6eba36723685ff7e02c1f7d8b2a02';

/// ログインユーザーのアカウント情報を取得するProvider
///
/// 他のfeatureから参照する際の主要なエントリポイント
///
/// Copied from [myAccount].
@ProviderFor(myAccount)
final myAccountProvider = AutoDisposeFutureProvider<Account?>.internal(
  myAccount,
  name: r'myAccountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyAccountRef = AutoDisposeFutureProviderRef<Account?>;
String _$accountStoreHash() => r'008a37f43485bb2ced00b4763cda9a9374db4661';

/// アカウント情報を管理するStore
///
/// 認証されたユーザーのアカウント情報を管理し、
/// 初回ログイン時の自動作成も担当する。
/// 他のfeatureからはこのStoreを通じてアカウント情報にアクセスする。
///
/// Copied from [AccountStore].
@ProviderFor(AccountStore)
final accountStoreProvider =
    AsyncNotifierProvider<AccountStore, Account?>.internal(
      AccountStore.new,
      name: r'accountStoreProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$accountStoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountStore = AsyncNotifier<Account?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
