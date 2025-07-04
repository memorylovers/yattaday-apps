// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{'user': instance.user};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSignOutWhenFirstRunHash() =>
    r'b8f16fcc52ccf6777342db8a715cf5cd9a3979c6';

/// アプリ初回起動時のサインアウト処理
///
/// アプリが初回起動の場合、前回の認証情報をクリアするため
/// 自動的にサインアウトを実行する。
///
/// Copied from [authSignOutWhenFirstRun].
@ProviderFor(authSignOutWhenFirstRun)
final authSignOutWhenFirstRunProvider =
    AutoDisposeFutureProvider<void>.internal(
      authSignOutWhenFirstRun,
      name: r'authSignOutWhenFirstRunProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authSignOutWhenFirstRunHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthSignOutWhenFirstRunRef = AutoDisposeFutureProviderRef<void>;
String _$authStoreHash() => r'1dbb55f924520efb4d88045153c5a1c80efa3719';

/// 認証状態管理Store
///
/// ユーザーの認証状態を管理し、ログイン/ログアウトの
/// 操作を提供する。Firebaseに依存しない実装。
///
/// Copied from [AuthStore].
@ProviderFor(AuthStore)
final authStoreProvider =
    StreamNotifierProvider<AuthStore, AuthState?>.internal(
      AuthStore.new,
      name: r'authStoreProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$authStoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthStore = StreamNotifier<AuthState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
