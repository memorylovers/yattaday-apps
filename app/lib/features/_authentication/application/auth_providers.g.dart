// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(uid: json['uid'] as String);

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{'uid': instance.uid};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSignOutWhenFirstRunHash() =>
    r'1eee397e252d3a1f2ece5778cd22aef9e6b5e856';

/// See also [authSignOutWhenFirstRun].
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
String _$authStoreHash() => r'b98b852700c7a860545083e76f9db033e34b45c3';

/// 認証状態
///
/// Copied from [AuthStore].
@ProviderFor(AuthStore)
final authStoreProvider = AsyncNotifierProvider<AuthStore, AuthState?>.internal(
  AuthStore.new,
  name: r'authStoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthStore = AsyncNotifier<AuthState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
