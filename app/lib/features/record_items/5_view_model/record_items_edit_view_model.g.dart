// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_items_edit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordItemsEditViewModelHash() =>
    r'818b588815c605cdc69052d2d3f448001e54601a';

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

abstract class _$RecordItemsEditViewModel
    extends BuildlessAutoDisposeNotifier<RecordItemsEditPageState> {
  late final RecordItem recordItem;

  RecordItemsEditPageState build(RecordItem recordItem);
}

/// See also [RecordItemsEditViewModel].
@ProviderFor(RecordItemsEditViewModel)
const recordItemsEditViewModelProvider = RecordItemsEditViewModelFamily();

/// See also [RecordItemsEditViewModel].
class RecordItemsEditViewModelFamily extends Family<RecordItemsEditPageState> {
  /// See also [RecordItemsEditViewModel].
  const RecordItemsEditViewModelFamily();

  /// See also [RecordItemsEditViewModel].
  RecordItemsEditViewModelProvider call(RecordItem recordItem) {
    return RecordItemsEditViewModelProvider(recordItem);
  }

  @override
  RecordItemsEditViewModelProvider getProviderOverride(
    covariant RecordItemsEditViewModelProvider provider,
  ) {
    return call(provider.recordItem);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordItemsEditViewModelProvider';
}

/// See also [RecordItemsEditViewModel].
class RecordItemsEditViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecordItemsEditViewModel,
          RecordItemsEditPageState
        > {
  /// See also [RecordItemsEditViewModel].
  RecordItemsEditViewModelProvider(RecordItem recordItem)
    : this._internal(
        () => RecordItemsEditViewModel()..recordItem = recordItem,
        from: recordItemsEditViewModelProvider,
        name: r'recordItemsEditViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordItemsEditViewModelHash,
        dependencies: RecordItemsEditViewModelFamily._dependencies,
        allTransitiveDependencies:
            RecordItemsEditViewModelFamily._allTransitiveDependencies,
        recordItem: recordItem,
      );

  RecordItemsEditViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordItem,
  }) : super.internal();

  final RecordItem recordItem;

  @override
  RecordItemsEditPageState runNotifierBuild(
    covariant RecordItemsEditViewModel notifier,
  ) {
    return notifier.build(recordItem);
  }

  @override
  Override overrideWith(RecordItemsEditViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecordItemsEditViewModelProvider._internal(
        () => create()..recordItem = recordItem,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordItem: recordItem,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    RecordItemsEditViewModel,
    RecordItemsEditPageState
  >
  createElement() {
    return _RecordItemsEditViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordItemsEditViewModelProvider &&
        other.recordItem == recordItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecordItemsEditViewModelRef
    on AutoDisposeNotifierProviderRef<RecordItemsEditPageState> {
  /// The parameter `recordItem` of this provider.
  RecordItem get recordItem;
}

class _RecordItemsEditViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecordItemsEditViewModel,
          RecordItemsEditPageState
        >
    with RecordItemsEditViewModelRef {
  _RecordItemsEditViewModelProviderElement(super.provider);

  @override
  RecordItem get recordItem =>
      (origin as RecordItemsEditViewModelProvider).recordItem;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
