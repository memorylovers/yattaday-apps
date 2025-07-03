// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordItemDetailViewModelHash() =>
    r'ae4b70a4e08c1be779196366c65b5e0b1ff11221';

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

abstract class _$RecordItemDetailViewModel
    extends BuildlessAutoDisposeNotifier<RecordItemDetailPageState> {
  late final String recordItemId;

  RecordItemDetailPageState build(String recordItemId);
}

/// See also [RecordItemDetailViewModel].
@ProviderFor(RecordItemDetailViewModel)
const recordItemDetailViewModelProvider = RecordItemDetailViewModelFamily();

/// See also [RecordItemDetailViewModel].
class RecordItemDetailViewModelFamily
    extends Family<RecordItemDetailPageState> {
  /// See also [RecordItemDetailViewModel].
  const RecordItemDetailViewModelFamily();

  /// See also [RecordItemDetailViewModel].
  RecordItemDetailViewModelProvider call(String recordItemId) {
    return RecordItemDetailViewModelProvider(recordItemId);
  }

  @override
  RecordItemDetailViewModelProvider getProviderOverride(
    covariant RecordItemDetailViewModelProvider provider,
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
  String? get name => r'recordItemDetailViewModelProvider';
}

/// See also [RecordItemDetailViewModel].
class RecordItemDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecordItemDetailViewModel,
          RecordItemDetailPageState
        > {
  /// See also [RecordItemDetailViewModel].
  RecordItemDetailViewModelProvider(String recordItemId)
    : this._internal(
        () => RecordItemDetailViewModel()..recordItemId = recordItemId,
        from: recordItemDetailViewModelProvider,
        name: r'recordItemDetailViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordItemDetailViewModelHash,
        dependencies: RecordItemDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            RecordItemDetailViewModelFamily._allTransitiveDependencies,
        recordItemId: recordItemId,
      );

  RecordItemDetailViewModelProvider._internal(
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
  RecordItemDetailPageState runNotifierBuild(
    covariant RecordItemDetailViewModel notifier,
  ) {
    return notifier.build(recordItemId);
  }

  @override
  Override overrideWith(RecordItemDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecordItemDetailViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<
    RecordItemDetailViewModel,
    RecordItemDetailPageState
  >
  createElement() {
    return _RecordItemDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordItemDetailViewModelProvider &&
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
mixin RecordItemDetailViewModelRef
    on AutoDisposeNotifierProviderRef<RecordItemDetailPageState> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;
}

class _RecordItemDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecordItemDetailViewModel,
          RecordItemDetailPageState
        >
    with RecordItemDetailViewModelRef {
  _RecordItemDetailViewModelProviderElement(super.provider);

  @override
  String get recordItemId =>
      (origin as RecordItemDetailViewModelProvider).recordItemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
