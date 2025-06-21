// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item_statistics_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getRecordItemStatisticsUseCaseHash() =>
    r'5efbe4a19d3adf0736a358970c5ada7cb9bd0f43';

/// 記録統計UseCaseのプロバイダー
///
/// Copied from [getRecordItemStatisticsUseCase].
@ProviderFor(getRecordItemStatisticsUseCase)
final getRecordItemStatisticsUseCaseProvider =
    AutoDisposeProvider<GetRecordItemStatisticsUseCase>.internal(
      getRecordItemStatisticsUseCase,
      name: r'getRecordItemStatisticsUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$getRecordItemStatisticsUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRecordItemStatisticsUseCaseRef =
    AutoDisposeProviderRef<GetRecordItemStatisticsUseCase>;
String _$recordItemStatisticsHash() =>
    r'276ad93557d53ec897232cf980c9c97c47308684';

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

/// 特定の記録項目の統計情報を取得するプロバイダー
///
/// Copied from [recordItemStatistics].
@ProviderFor(recordItemStatistics)
const recordItemStatisticsProvider = RecordItemStatisticsFamily();

/// 特定の記録項目の統計情報を取得するプロバイダー
///
/// Copied from [recordItemStatistics].
class RecordItemStatisticsFamily
    extends Family<AsyncValue<RecordItemStatistics>> {
  /// 特定の記録項目の統計情報を取得するプロバイダー
  ///
  /// Copied from [recordItemStatistics].
  const RecordItemStatisticsFamily();

  /// 特定の記録項目の統計情報を取得するプロバイダー
  ///
  /// Copied from [recordItemStatistics].
  RecordItemStatisticsProvider call({required String recordItemId}) {
    return RecordItemStatisticsProvider(recordItemId: recordItemId);
  }

  @override
  RecordItemStatisticsProvider getProviderOverride(
    covariant RecordItemStatisticsProvider provider,
  ) {
    return call(recordItemId: provider.recordItemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordItemStatisticsProvider';
}

/// 特定の記録項目の統計情報を取得するプロバイダー
///
/// Copied from [recordItemStatistics].
class RecordItemStatisticsProvider
    extends AutoDisposeFutureProvider<RecordItemStatistics> {
  /// 特定の記録項目の統計情報を取得するプロバイダー
  ///
  /// Copied from [recordItemStatistics].
  RecordItemStatisticsProvider({required String recordItemId})
    : this._internal(
        (ref) => recordItemStatistics(
          ref as RecordItemStatisticsRef,
          recordItemId: recordItemId,
        ),
        from: recordItemStatisticsProvider,
        name: r'recordItemStatisticsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordItemStatisticsHash,
        dependencies: RecordItemStatisticsFamily._dependencies,
        allTransitiveDependencies:
            RecordItemStatisticsFamily._allTransitiveDependencies,
        recordItemId: recordItemId,
      );

  RecordItemStatisticsProvider._internal(
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
  Override overrideWith(
    FutureOr<RecordItemStatistics> Function(RecordItemStatisticsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecordItemStatisticsProvider._internal(
        (ref) => create(ref as RecordItemStatisticsRef),
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
  AutoDisposeFutureProviderElement<RecordItemStatistics> createElement() {
    return _RecordItemStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordItemStatisticsProvider &&
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
mixin RecordItemStatisticsRef
    on AutoDisposeFutureProviderRef<RecordItemStatistics> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;
}

class _RecordItemStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<RecordItemStatistics>
    with RecordItemStatisticsRef {
  _RecordItemStatisticsProviderElement(super.provider);

  @override
  String get recordItemId =>
      (origin as RecordItemStatisticsProvider).recordItemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
