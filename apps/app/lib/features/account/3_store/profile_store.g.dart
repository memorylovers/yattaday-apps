// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAccountProfileHash() => r'4b687a6483d1ce9ad063cd56a73b59908d827f0c';

/// ログインユーザーのプロフィール情報を取得するProvider
///
/// 他のfeatureから参照する際の主要なエントリポイント
///
/// Copied from [myAccountProfile].
@ProviderFor(myAccountProfile)
final myAccountProfileProvider =
    AutoDisposeFutureProvider<AccountProfile?>.internal(
      myAccountProfile,
      name: r'myAccountProfileProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$myAccountProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyAccountProfileRef = AutoDisposeFutureProviderRef<AccountProfile?>;
String _$accountProfileHash() => r'0dc97250f9fc8c795b292872574ef7cbc1810f85';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 特定ユーザーのプロフィール情報を取得するProvider
///
/// 他ユーザーのプロフィールを参照する際に使用
///
/// Copied from [accountProfile].
@ProviderFor(accountProfile)
const accountProfileProvider = AccountProfileFamily();

/// 特定ユーザーのプロフィール情報を取得するProvider
///
/// 他ユーザーのプロフィールを参照する際に使用
///
/// Copied from [accountProfile].
class AccountProfileFamily extends Family<AsyncValue<AccountProfile?>> {
  /// 特定ユーザーのプロフィール情報を取得するProvider
  ///
  /// 他ユーザーのプロフィールを参照する際に使用
  ///
  /// Copied from [accountProfile].
  const AccountProfileFamily();

  /// 特定ユーザーのプロフィール情報を取得するProvider
  ///
  /// 他ユーザーのプロフィールを参照する際に使用
  ///
  /// Copied from [accountProfile].
  AccountProfileProvider call(String uid) {
    return AccountProfileProvider(uid);
  }

  @override
  AccountProfileProvider getProviderOverride(
    covariant AccountProfileProvider provider,
  ) {
    return call(provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountProfileProvider';
}

/// 特定ユーザーのプロフィール情報を取得するProvider
///
/// 他ユーザーのプロフィールを参照する際に使用
///
/// Copied from [accountProfile].
class AccountProfileProvider
    extends AutoDisposeFutureProvider<AccountProfile?> {
  /// 特定ユーザーのプロフィール情報を取得するProvider
  ///
  /// 他ユーザーのプロフィールを参照する際に使用
  ///
  /// Copied from [accountProfile].
  AccountProfileProvider(String uid)
    : this._internal(
        (ref) => accountProfile(ref as AccountProfileRef, uid),
        from: accountProfileProvider,
        name: r'accountProfileProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$accountProfileHash,
        dependencies: AccountProfileFamily._dependencies,
        allTransitiveDependencies:
            AccountProfileFamily._allTransitiveDependencies,
        uid: uid,
      );

  AccountProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<AccountProfile?> Function(AccountProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProfileProvider._internal(
        (ref) => create(ref as AccountProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AccountProfile?> createElement() {
    return _AccountProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProfileProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountProfileRef on AutoDisposeFutureProviderRef<AccountProfile?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _AccountProfileProviderElement
    extends AutoDisposeFutureProviderElement<AccountProfile?>
    with AccountProfileRef {
  _AccountProfileProviderElement(super.provider);

  @override
  String get uid => (origin as AccountProfileProvider).uid;
}

String _$searchAccountProfilesHash() =>
    r'3eefe9156e2f3ea72f5e1df3deb15757b3112e49';

/// 表示名でユーザーを検索するProvider
///
/// ユーザー検索機能で使用
///
/// Copied from [searchAccountProfiles].
@ProviderFor(searchAccountProfiles)
const searchAccountProfilesProvider = SearchAccountProfilesFamily();

/// 表示名でユーザーを検索するProvider
///
/// ユーザー検索機能で使用
///
/// Copied from [searchAccountProfiles].
class SearchAccountProfilesFamily
    extends Family<AsyncValue<List<AccountProfile>>> {
  /// 表示名でユーザーを検索するProvider
  ///
  /// ユーザー検索機能で使用
  ///
  /// Copied from [searchAccountProfiles].
  const SearchAccountProfilesFamily();

  /// 表示名でユーザーを検索するProvider
  ///
  /// ユーザー検索機能で使用
  ///
  /// Copied from [searchAccountProfiles].
  SearchAccountProfilesProvider call(String query, {int limit = 20}) {
    return SearchAccountProfilesProvider(query, limit: limit);
  }

  @override
  SearchAccountProfilesProvider getProviderOverride(
    covariant SearchAccountProfilesProvider provider,
  ) {
    return call(provider.query, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchAccountProfilesProvider';
}

/// 表示名でユーザーを検索するProvider
///
/// ユーザー検索機能で使用
///
/// Copied from [searchAccountProfiles].
class SearchAccountProfilesProvider
    extends AutoDisposeFutureProvider<List<AccountProfile>> {
  /// 表示名でユーザーを検索するProvider
  ///
  /// ユーザー検索機能で使用
  ///
  /// Copied from [searchAccountProfiles].
  SearchAccountProfilesProvider(String query, {int limit = 20})
    : this._internal(
        (ref) => searchAccountProfiles(
          ref as SearchAccountProfilesRef,
          query,
          limit: limit,
        ),
        from: searchAccountProfilesProvider,
        name: r'searchAccountProfilesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchAccountProfilesHash,
        dependencies: SearchAccountProfilesFamily._dependencies,
        allTransitiveDependencies:
            SearchAccountProfilesFamily._allTransitiveDependencies,
        query: query,
        limit: limit,
      );

  SearchAccountProfilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.limit,
  }) : super.internal();

  final String query;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<AccountProfile>> Function(SearchAccountProfilesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchAccountProfilesProvider._internal(
        (ref) => create(ref as SearchAccountProfilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AccountProfile>> createElement() {
    return _SearchAccountProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchAccountProfilesProvider &&
        other.query == query &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchAccountProfilesRef
    on AutoDisposeFutureProviderRef<List<AccountProfile>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _SearchAccountProfilesProviderElement
    extends AutoDisposeFutureProviderElement<List<AccountProfile>>
    with SearchAccountProfilesRef {
  _SearchAccountProfilesProviderElement(super.provider);

  @override
  String get query => (origin as SearchAccountProfilesProvider).query;
  @override
  int get limit => (origin as SearchAccountProfilesProvider).limit;
}

String _$profileStoreHash() => r'0dd54ed7b9043c104a86ef2857bf7660b76f6358';

/// プロフィール情報を管理するStore
///
/// ユーザーの公開プロフィール情報を管理し、
/// アカウント作成時のプロフィール自動作成も担当する。
///
/// Copied from [ProfileStore].
@ProviderFor(ProfileStore)
final profileStoreProvider =
    AsyncNotifierProvider<ProfileStore, AccountProfile?>.internal(
      ProfileStore.new,
      name: r'profileStoreProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$profileStoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileStore = AsyncNotifier<AccountProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
