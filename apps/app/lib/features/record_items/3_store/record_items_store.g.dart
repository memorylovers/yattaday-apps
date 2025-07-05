// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_items_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordItemsStoreHash() => r'e24e92f57b7acb268c5ee5ef5d853e2143e1c5c5';

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

abstract class _$RecordItemsStore
    extends BuildlessAsyncNotifier<List<RecordItem>> {
  late final String userId;

  FutureOr<List<RecordItem>> build(String userId);
}

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
///
/// Copied from [RecordItemsStore].
@ProviderFor(RecordItemsStore)
const recordItemsStoreProvider = RecordItemsStoreFamily();

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
///
/// Copied from [RecordItemsStore].
class RecordItemsStoreFamily extends Family<AsyncValue<List<RecordItem>>> {
  /// 指定したユーザーの記録項目一覧を取得するプロバイダ
  ///
  /// Copied from [RecordItemsStore].
  const RecordItemsStoreFamily();

  /// 指定したユーザーの記録項目一覧を取得するプロバイダ
  ///
  /// Copied from [RecordItemsStore].
  RecordItemsStoreProvider call(String userId) {
    return RecordItemsStoreProvider(userId);
  }

  @override
  RecordItemsStoreProvider getProviderOverride(
    covariant RecordItemsStoreProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordItemsStoreProvider';
}

/// 指定したユーザーの記録項目一覧を取得するプロバイダ
///
/// Copied from [RecordItemsStore].
class RecordItemsStoreProvider
    extends AsyncNotifierProviderImpl<RecordItemsStore, List<RecordItem>> {
  /// 指定したユーザーの記録項目一覧を取得するプロバイダ
  ///
  /// Copied from [RecordItemsStore].
  RecordItemsStoreProvider(String userId)
    : this._internal(
        () => RecordItemsStore()..userId = userId,
        from: recordItemsStoreProvider,
        name: r'recordItemsStoreProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordItemsStoreHash,
        dependencies: RecordItemsStoreFamily._dependencies,
        allTransitiveDependencies:
            RecordItemsStoreFamily._allTransitiveDependencies,
        userId: userId,
      );

  RecordItemsStoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<RecordItem>> runNotifierBuild(
    covariant RecordItemsStore notifier,
  ) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(RecordItemsStore Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecordItemsStoreProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<RecordItemsStore, List<RecordItem>>
  createElement() {
    return _RecordItemsStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordItemsStoreProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecordItemsStoreRef on AsyncNotifierProviderRef<List<RecordItem>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _RecordItemsStoreProviderElement
    extends AsyncNotifierProviderElement<RecordItemsStore, List<RecordItem>>
    with RecordItemsStoreRef {
  _RecordItemsStoreProviderElement(super.provider);

  @override
  String get userId => (origin as RecordItemsStoreProvider).userId;
}

String _$recordItemByIdStoreHash() =>
    r'232f4d537d272b326aa39ebdf21e5aeaacdb82c6';

abstract class _$RecordItemByIdStore
    extends BuildlessAsyncNotifier<RecordItem?> {
  late final String recordItemId;

  FutureOr<RecordItem?> build(String recordItemId);
}

/// 指定したIDの記録項目を取得するプロバイダ
///
/// Copied from [RecordItemByIdStore].
@ProviderFor(RecordItemByIdStore)
const recordItemByIdStoreProvider = RecordItemByIdStoreFamily();

/// 指定したIDの記録項目を取得するプロバイダ
///
/// Copied from [RecordItemByIdStore].
class RecordItemByIdStoreFamily extends Family<AsyncValue<RecordItem?>> {
  /// 指定したIDの記録項目を取得するプロバイダ
  ///
  /// Copied from [RecordItemByIdStore].
  const RecordItemByIdStoreFamily();

  /// 指定したIDの記録項目を取得するプロバイダ
  ///
  /// Copied from [RecordItemByIdStore].
  RecordItemByIdStoreProvider call(String recordItemId) {
    return RecordItemByIdStoreProvider(recordItemId);
  }

  @override
  RecordItemByIdStoreProvider getProviderOverride(
    covariant RecordItemByIdStoreProvider provider,
  ) {
    return call(provider.recordItemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordItemByIdStoreProvider';
}

/// 指定したIDの記録項目を取得するプロバイダ
///
/// Copied from [RecordItemByIdStore].
class RecordItemByIdStoreProvider
    extends AsyncNotifierProviderImpl<RecordItemByIdStore, RecordItem?> {
  /// 指定したIDの記録項目を取得するプロバイダ
  ///
  /// Copied from [RecordItemByIdStore].
  RecordItemByIdStoreProvider(String recordItemId)
    : this._internal(
        () => RecordItemByIdStore()..recordItemId = recordItemId,
        from: recordItemByIdStoreProvider,
        name: r'recordItemByIdStoreProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordItemByIdStoreHash,
        dependencies: RecordItemByIdStoreFamily._dependencies,
        allTransitiveDependencies:
            RecordItemByIdStoreFamily._allTransitiveDependencies,
        recordItemId: recordItemId,
      );

  RecordItemByIdStoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordItemId,
  }) : super.internal();

  final String recordItemId;

  @override
  FutureOr<RecordItem?> runNotifierBuild(
    covariant RecordItemByIdStore notifier,
  ) {
    return notifier.build(recordItemId);
  }

  @override
  Override overrideWith(RecordItemByIdStore Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecordItemByIdStoreProvider._internal(
        () => create()..recordItemId = recordItemId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordItemId: recordItemId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<RecordItemByIdStore, RecordItem?>
  createElement() {
    return _RecordItemByIdStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordItemByIdStoreProvider &&
        other.recordItemId == recordItemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordItemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecordItemByIdStoreRef on AsyncNotifierProviderRef<RecordItem?> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;
}

class _RecordItemByIdStoreProviderElement
    extends AsyncNotifierProviderElement<RecordItemByIdStore, RecordItem?>
    with RecordItemByIdStoreRef {
  _RecordItemByIdStoreProviderElement(super.provider);

  @override
  String get recordItemId =>
      (origin as RecordItemByIdStoreProvider).recordItemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
