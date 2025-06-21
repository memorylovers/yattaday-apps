// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_item_histories_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordItemHistoryRepositoryHash() =>
    r'e9ab6cbd41643b2711e62cdcb7795e1f83c203db';

/// 記録項目履歴リポジトリのプロバイダー
///
/// Copied from [recordItemHistoryRepository].
@ProviderFor(recordItemHistoryRepository)
final recordItemHistoryRepositoryProvider =
    AutoDisposeProvider<IRecordItemHistoryRepository>.internal(
      recordItemHistoryRepository,
      name: r'recordItemHistoryRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$recordItemHistoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecordItemHistoryRepositoryRef =
    AutoDisposeProviderRef<IRecordItemHistoryRepository>;
String _$createRecordItemHistoryUseCaseHash() =>
    r'ab92e5b14f696050f2a6ddfbebdf5ab494be005d';

/// 記録作成UseCaseのプロバイダー
///
/// Copied from [createRecordItemHistoryUseCase].
@ProviderFor(createRecordItemHistoryUseCase)
final createRecordItemHistoryUseCaseProvider =
    AutoDisposeProvider<CreateRecordItemHistoryUseCase>.internal(
      createRecordItemHistoryUseCase,
      name: r'createRecordItemHistoryUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$createRecordItemHistoryUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateRecordItemHistoryUseCaseRef =
    AutoDisposeProviderRef<CreateRecordItemHistoryUseCase>;
String _$fetchRecordItemHistoriesUseCaseHash() =>
    r'9445ab3721a6a70392f157b831bab35651bd642e';

/// 記録取得UseCaseのプロバイダー
///
/// Copied from [fetchRecordItemHistoriesUseCase].
@ProviderFor(fetchRecordItemHistoriesUseCase)
final fetchRecordItemHistoriesUseCaseProvider =
    AutoDisposeProvider<FetchRecordItemHistoriesUseCase>.internal(
      fetchRecordItemHistoriesUseCase,
      name: r'fetchRecordItemHistoriesUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$fetchRecordItemHistoriesUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchRecordItemHistoriesUseCaseRef =
    AutoDisposeProviderRef<FetchRecordItemHistoriesUseCase>;
String _$deleteRecordItemHistoryUseCaseHash() =>
    r'16c46c445929855706cb7aafa8d4578d3c95a51a';

/// 記録削除UseCaseのプロバイダー
///
/// Copied from [deleteRecordItemHistoryUseCase].
@ProviderFor(deleteRecordItemHistoryUseCase)
final deleteRecordItemHistoryUseCaseProvider =
    AutoDisposeProvider<DeleteRecordItemHistoryUseCase>.internal(
      deleteRecordItemHistoryUseCase,
      name: r'deleteRecordItemHistoryUseCaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$deleteRecordItemHistoryUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteRecordItemHistoryUseCaseRef =
    AutoDisposeProviderRef<DeleteRecordItemHistoryUseCase>;
String _$watchRecordItemHistoriesHash() =>
    r'1e288fc6f05f207a2dc93d59ed4d01d6dfc995f2';

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

/// 特定の記録項目の履歴を監視するプロバイダー
///
/// Copied from [watchRecordItemHistories].
@ProviderFor(watchRecordItemHistories)
const watchRecordItemHistoriesProvider = WatchRecordItemHistoriesFamily();

/// 特定の記録項目の履歴を監視するプロバイダー
///
/// Copied from [watchRecordItemHistories].
class WatchRecordItemHistoriesFamily
    extends Family<AsyncValue<List<RecordItemHistory>>> {
  /// 特定の記録項目の履歴を監視するプロバイダー
  ///
  /// Copied from [watchRecordItemHistories].
  const WatchRecordItemHistoriesFamily();

  /// 特定の記録項目の履歴を監視するプロバイダー
  ///
  /// Copied from [watchRecordItemHistories].
  WatchRecordItemHistoriesProvider call({
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return WatchRecordItemHistoriesProvider(
      recordItemId: recordItemId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  WatchRecordItemHistoriesProvider getProviderOverride(
    covariant WatchRecordItemHistoriesProvider provider,
  ) {
    return call(
      recordItemId: provider.recordItemId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchRecordItemHistoriesProvider';
}

/// 特定の記録項目の履歴を監視するプロバイダー
///
/// Copied from [watchRecordItemHistories].
class WatchRecordItemHistoriesProvider
    extends AutoDisposeStreamProvider<List<RecordItemHistory>> {
  /// 特定の記録項目の履歴を監視するプロバイダー
  ///
  /// Copied from [watchRecordItemHistories].
  WatchRecordItemHistoriesProvider({
    required String recordItemId,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
         (ref) => watchRecordItemHistories(
           ref as WatchRecordItemHistoriesRef,
           recordItemId: recordItemId,
           startDate: startDate,
           endDate: endDate,
         ),
         from: watchRecordItemHistoriesProvider,
         name: r'watchRecordItemHistoriesProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$watchRecordItemHistoriesHash,
         dependencies: WatchRecordItemHistoriesFamily._dependencies,
         allTransitiveDependencies:
             WatchRecordItemHistoriesFamily._allTransitiveDependencies,
         recordItemId: recordItemId,
         startDate: startDate,
         endDate: endDate,
       );

  WatchRecordItemHistoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordItemId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String recordItemId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    Stream<List<RecordItemHistory>> Function(
      WatchRecordItemHistoriesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchRecordItemHistoriesProvider._internal(
        (ref) => create(ref as WatchRecordItemHistoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordItemId: recordItemId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<RecordItemHistory>> createElement() {
    return _WatchRecordItemHistoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchRecordItemHistoriesProvider &&
        other.recordItemId == recordItemId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordItemId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WatchRecordItemHistoriesRef
    on AutoDisposeStreamProviderRef<List<RecordItemHistory>> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _WatchRecordItemHistoriesProviderElement
    extends AutoDisposeStreamProviderElement<List<RecordItemHistory>>
    with WatchRecordItemHistoriesRef {
  _WatchRecordItemHistoriesProviderElement(super.provider);

  @override
  String get recordItemId =>
      (origin as WatchRecordItemHistoriesProvider).recordItemId;
  @override
  DateTime get startDate =>
      (origin as WatchRecordItemHistoriesProvider).startDate;
  @override
  DateTime get endDate => (origin as WatchRecordItemHistoriesProvider).endDate;
}

String _$watchTodayRecordExistsHash() =>
    r'7b79f63809ade1125dc321a74072d7d53c352363';

/// 今日の記録があるかどうかを監視するプロバイダー
///
/// Copied from [watchTodayRecordExists].
@ProviderFor(watchTodayRecordExists)
const watchTodayRecordExistsProvider = WatchTodayRecordExistsFamily();

/// 今日の記録があるかどうかを監視するプロバイダー
///
/// Copied from [watchTodayRecordExists].
class WatchTodayRecordExistsFamily extends Family<AsyncValue<bool>> {
  /// 今日の記録があるかどうかを監視するプロバイダー
  ///
  /// Copied from [watchTodayRecordExists].
  const WatchTodayRecordExistsFamily();

  /// 今日の記録があるかどうかを監視するプロバイダー
  ///
  /// Copied from [watchTodayRecordExists].
  WatchTodayRecordExistsProvider call({required String recordItemId}) {
    return WatchTodayRecordExistsProvider(recordItemId: recordItemId);
  }

  @override
  WatchTodayRecordExistsProvider getProviderOverride(
    covariant WatchTodayRecordExistsProvider provider,
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
  String? get name => r'watchTodayRecordExistsProvider';
}

/// 今日の記録があるかどうかを監視するプロバイダー
///
/// Copied from [watchTodayRecordExists].
class WatchTodayRecordExistsProvider extends AutoDisposeStreamProvider<bool> {
  /// 今日の記録があるかどうかを監視するプロバイダー
  ///
  /// Copied from [watchTodayRecordExists].
  WatchTodayRecordExistsProvider({required String recordItemId})
    : this._internal(
        (ref) => watchTodayRecordExists(
          ref as WatchTodayRecordExistsRef,
          recordItemId: recordItemId,
        ),
        from: watchTodayRecordExistsProvider,
        name: r'watchTodayRecordExistsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$watchTodayRecordExistsHash,
        dependencies: WatchTodayRecordExistsFamily._dependencies,
        allTransitiveDependencies:
            WatchTodayRecordExistsFamily._allTransitiveDependencies,
        recordItemId: recordItemId,
      );

  WatchTodayRecordExistsProvider._internal(
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
    Stream<bool> Function(WatchTodayRecordExistsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchTodayRecordExistsProvider._internal(
        (ref) => create(ref as WatchTodayRecordExistsRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _WatchTodayRecordExistsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchTodayRecordExistsProvider &&
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
mixin WatchTodayRecordExistsRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;
}

class _WatchTodayRecordExistsProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with WatchTodayRecordExistsRef {
  _WatchTodayRecordExistsProviderElement(super.provider);

  @override
  String get recordItemId =>
      (origin as WatchTodayRecordExistsProvider).recordItemId;
}

String _$recordedDatesHash() => r'0fa50b6d9d4197c373ee1b9ee7523962a99d5518';

/// 記録がある日付のリストを取得するプロバイダー
///
/// Copied from [recordedDates].
@ProviderFor(recordedDates)
const recordedDatesProvider = RecordedDatesFamily();

/// 記録がある日付のリストを取得するプロバイダー
///
/// Copied from [recordedDates].
class RecordedDatesFamily extends Family<AsyncValue<List<String>>> {
  /// 記録がある日付のリストを取得するプロバイダー
  ///
  /// Copied from [recordedDates].
  const RecordedDatesFamily();

  /// 記録がある日付のリストを取得するプロバイダー
  ///
  /// Copied from [recordedDates].
  RecordedDatesProvider call({required String recordItemId}) {
    return RecordedDatesProvider(recordItemId: recordItemId);
  }

  @override
  RecordedDatesProvider getProviderOverride(
    covariant RecordedDatesProvider provider,
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
  String? get name => r'recordedDatesProvider';
}

/// 記録がある日付のリストを取得するプロバイダー
///
/// Copied from [recordedDates].
class RecordedDatesProvider extends AutoDisposeFutureProvider<List<String>> {
  /// 記録がある日付のリストを取得するプロバイダー
  ///
  /// Copied from [recordedDates].
  RecordedDatesProvider({required String recordItemId})
    : this._internal(
        (ref) =>
            recordedDates(ref as RecordedDatesRef, recordItemId: recordItemId),
        from: recordedDatesProvider,
        name: r'recordedDatesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordedDatesHash,
        dependencies: RecordedDatesFamily._dependencies,
        allTransitiveDependencies:
            RecordedDatesFamily._allTransitiveDependencies,
        recordItemId: recordItemId,
      );

  RecordedDatesProvider._internal(
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
    FutureOr<List<String>> Function(RecordedDatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecordedDatesProvider._internal(
        (ref) => create(ref as RecordedDatesRef),
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
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _RecordedDatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordedDatesProvider && other.recordItemId == recordItemId;
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
mixin RecordedDatesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `recordItemId` of this provider.
  String get recordItemId;
}

class _RecordedDatesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with RecordedDatesRef {
  _RecordedDatesProviderElement(super.provider);

  @override
  String get recordItemId => (origin as RecordedDatesProvider).recordItemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
