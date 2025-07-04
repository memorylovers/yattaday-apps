import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/services/admob/admob_service.dart';

// テスト用のMobileAdsインスタンス
class TestMobileAdsInstance {
  bool isInitialized = false;
  bool shouldThrowOnInitialize = false;

  Future<InitializationStatus> initialize() async {
    if (shouldThrowOnInitialize) {
      throw Exception('Failed to initialize');
    }
    isInitialized = true;
    return TestInitializationStatus();
  }
}

// InitializationStatus用のテスト実装
class TestInitializationStatus implements InitializationStatus {
  @override
  Map<String, AdapterStatus> get adapterStatuses => {};
}

// BannerAd用のFake実装
class FakeBannerAd extends BannerAd {
  final String testAdUnitId;
  bool isLoaded = false;
  bool isDisposed = false;

  FakeBannerAd({
    required this.testAdUnitId,
    required super.size,
    required super.request,
    required super.listener,
  }) : super(
          adUnitId: testAdUnitId,
        );

  @override
  Future<void> load() async {
    isLoaded = true;
    listener.onAdLoaded?.call(this);
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    super.dispose();
  }
}

// RewardedAd用のFake実装
class FakeRewardedAd {
  final String adUnitId;
  bool isDisposed = false;
  FullScreenContentCallback<RewardedAd>? fullScreenContentCallback;

  FakeRewardedAd({required this.adUnitId});

  Future<void> show({required OnUserEarnedRewardCallback onUserEarnedReward}) async {
    // RewardedAdインスタンスが必要なため、このテストでは簡略化
    // テスト用のダミーRewardedAdを作成
    final dummyRewardedAd = _DummyRewardedAd(adUnitId: adUnitId);
    fullScreenContentCallback?.onAdShowedFullScreenContent?.call(dummyRewardedAd);
    onUserEarnedReward(
      FakeAdWithoutView(adUnitId: adUnitId), 
      FakeRewardItem(amount: 1, type: 'coins'),
    );
    fullScreenContentCallback?.onAdDismissedFullScreenContent?.call(dummyRewardedAd);
  }

  Future<void> dispose() async {
    isDisposed = true;
  }
}

// AdWithoutView用のFake実装
class FakeAdWithoutView implements AdWithoutView {
  @override
  final String adUnitId;

  FakeAdWithoutView({required this.adUnitId});

  @override
  OnPaidEventCallback? get onPaidEvent => null;

  @override
  set onPaidEvent(OnPaidEventCallback? callback) {}

  @override
  Future<void> dispose() async {}

  @override
  ResponseInfo? get responseInfo => null;

  @override
  set responseInfo(ResponseInfo? info) {}

  @override
  Future<void> setImmersiveMode(bool immersiveModeEnabled) async {}
}

// RewardItem用のFake実装
class FakeRewardItem implements RewardItem {
  @override
  final num amount;
  @override
  final String type;

  FakeRewardItem({required this.amount, required this.type});
}

// LoadAdError用のFake実装
class FakeLoadAdError implements LoadAdError {
  @override
  final int code = 0;
  @override
  final String domain = 'test';
  @override
  final String message = 'Test error';
  @override
  final ResponseInfo? responseInfo = null;

  @override
  String toString() => 'FakeLoadAdError: $message';
}

// テスト用のダミーRewardedAd
class _DummyRewardedAd implements RewardedAd {
  @override
  final String adUnitId;
  
  _DummyRewardedAd({required this.adUnitId});

  @override
  FullScreenContentCallback<RewardedAd>? fullScreenContentCallback;
  
  @override
  OnPaidEventCallback? onPaidEvent;

  @override
  ResponseInfo? responseInfo;
  
  @override
  AdRequest get request => const AdRequest();
  
  @override
  AdManagerAdRequest get adManagerRequest => throw UnimplementedError();
  
  @override
  RewardedAdLoadCallback get rewardedAdLoadCallback => throw UnimplementedError();
  
  @override
  OnUserEarnedRewardCallback? get onUserEarnedRewardCallback => null;
  
  @override
  set onUserEarnedRewardCallback(OnUserEarnedRewardCallback? callback) {}
  
  @override
  Future<void> dispose() async {}
  
  @override
  Future<void> show({required OnUserEarnedRewardCallback onUserEarnedReward}) => 
      throw UnimplementedError();
  
  @override
  Future<void> setImmersiveMode(bool immersiveModeEnabled) async {}
  
  @override
  Future<bool> setServerSideOptions(ServerSideVerificationOptions options) => 
      Future.value(true);
}

// テスト用のAdMobService
class TestableAdMobService extends AdMobService {
  final TestMobileAdsInstance testMobileAds;
  final Map<String, FakeRewardedAd> fakeRewardedAds = {};

  TestableAdMobService(this.testMobileAds);

  @override
  Future<void> initialize() async {
    try {
      await testMobileAds.initialize();
    } catch (error) {
      throw const AppException(code: AppErrorCode.adLoadFailed);
    }
  }

  @override
  BannerAd createBannerAd({
    required String adUnitId,
    AdSize adSize = AdSize.banner,
    String label = 'BannerAd',
    AdEventCallback? onAdLoaded,
    AdLoadErrorCallback? onAdFailedToLoad,
    AdEventCallback? onAdOpened,
    AdEventCallback? onAdClosed,
    AdEventCallback? onAdClicked,
    AdEventCallback? onAdImpression,
    OnPaidEventCallback? onPaidEvent,
  }) {
    // 親クラスのマップに格納するため、super.createBannerAdを呼ぶ
    return super.createBannerAd(
      adUnitId: adUnitId,
      adSize: adSize,
      label: label,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
      onAdOpened: onAdOpened,
      onAdClosed: onAdClosed,
      onAdClicked: onAdClicked,
      onAdImpression: onAdImpression,
      onPaidEvent: onPaidEvent,
    );
  }

  // テスト用のヘルパーメソッド
  void addFakeRewardedAd(String adUnitId, FakeRewardedAd ad) {
    fakeRewardedAds[adUnitId] = ad;
  }

  @override
  Future<void> loadRewardedAd({
    required String adUnitId,
    String label = 'RewardedAd',
    GenericAdEventCallback<RewardedAd>? onAdLoaded,
    FullScreenAdLoadErrorCallback? onAdFailedToLoad,
    GenericAdEventCallback<RewardedAd>? onAdShowedFullScreenContent,
    Function(RewardedAd ad, AdError error)? onAdFailedToShowFullScreenContent,
    GenericAdEventCallback<RewardedAd>? onAdDismissedFullScreenContent,
    OnUserEarnedRewardCallback? onUserEarnedReward,
  }) async {
    // テスト用の実装では、事前に追加されたFakeRewardedAdを使用
    final fakeAd = fakeRewardedAds[adUnitId];
    if (fakeAd != null) {
      fakeAd.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
        onAdShowedFullScreenContent: onAdShowedFullScreenContent,
        onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent,
        onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
      );
      onAdLoaded?.call(fakeAd as RewardedAd);
    } else {
      onAdFailedToLoad?.call(FakeLoadAdError());
    }
  }
}

void main() {
  late TestMobileAdsInstance testMobileAds;
  late TestableAdMobService adMobService;

  setUp(() {
    testMobileAds = TestMobileAdsInstance();
    adMobService = TestableAdMobService(testMobileAds);
  });

  group('AdMobService', () {
    group('initialize', () {
      test('正常に初期化できる', () async {
        await adMobService.initialize();

        expect(testMobileAds.isInitialized, isTrue);
      });

      test('初期化エラーがAppExceptionとして伝播される', () async {
        testMobileAds.shouldThrowOnInitialize = true;

        expect(
          () => adMobService.initialize(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.adLoadFailed),
          ),
        );
      });
    });

    group('createBannerAd', () {
      test('バナー広告を作成できる', () {
        const adUnitId = 'test-banner-1';
        
        final bannerAd = adMobService.createBannerAd(
          adUnitId: adUnitId,
          adSize: AdSize.banner,
          label: 'TestBanner',
        );

        expect(bannerAd, isNotNull);
        expect(bannerAd.adUnitId, adUnitId);
        expect(adMobService.getBannerAd(adUnitId), isNotNull);
      });

      test('カスタムサイズでバナー広告を作成できる', () {
        const adUnitId = 'test-banner-2';
        
        final bannerAd = adMobService.createBannerAd(
          adUnitId: adUnitId,
          adSize: AdSize.mediumRectangle,
        );

        expect(bannerAd.size, AdSize.mediumRectangle);
      });

      test('コールバックが正しく設定される', () async {
        const adUnitId = 'test-banner-3';
        var loadedCalled = false;
        
        adMobService.createBannerAd(
          adUnitId: adUnitId,
          onAdLoaded: (ad) {
            loadedCalled = true;
          },
        );

        // FakeBannerAdのloadメソッドを呼び出すシミュレーション
        final bannerAd = adMobService.getBannerAd(adUnitId) as FakeBannerAd?;
        await bannerAd?.load();

        expect(loadedCalled, isTrue);
      });
    });

    group('loadRewardedAd', () {
      test('リワード広告をロードできる', () async {
        const adUnitId = 'test-rewarded-1';
        var loadedCalled = false;
        
        final fakeRewardedAd = FakeRewardedAd(adUnitId: adUnitId);
        adMobService.addFakeRewardedAd(adUnitId, fakeRewardedAd);

        await adMobService.loadRewardedAd(
          adUnitId: adUnitId,
          onAdLoaded: (ad) {
            loadedCalled = true;
          },
        );

        expect(loadedCalled, isTrue);
      });

      test('リワード広告のロード失敗時にコールバックが呼ばれる', () async {
        const adUnitId = 'test-rewarded-2';
        var failedCalled = false;
        
        await adMobService.loadRewardedAd(
          adUnitId: adUnitId,
          onAdFailedToLoad: (error) {
            failedCalled = true;
          },
        );

        expect(failedCalled, isTrue);
      });

      test('フルスクリーンコールバックが正しく設定される', () async {
        const adUnitId = 'test-rewarded-3';
        var showedCalled = false;
        var dismissedCalled = false;
        
        final fakeRewardedAd = FakeRewardedAd(adUnitId: adUnitId);
        adMobService.addFakeRewardedAd(adUnitId, fakeRewardedAd);

        await adMobService.loadRewardedAd(
          adUnitId: adUnitId,
          onAdShowedFullScreenContent: (ad) {
            showedCalled = true;
          },
          onAdDismissedFullScreenContent: (ad) {
            dismissedCalled = true;
          },
        );

        // show メソッドを呼び出してコールバックをテスト
        await fakeRewardedAd.show(
          onUserEarnedReward: (ad, reward) {},
        );

        expect(showedCalled, isTrue);
        expect(dismissedCalled, isTrue);
      });
    });

    group('getBannerAd / getRewardedAd', () {
      test('存在するバナー広告を取得できる', () {
        const adUnitId = 'test-banner-get';
        
        adMobService.createBannerAd(adUnitId: adUnitId);
        final bannerAd = adMobService.getBannerAd(adUnitId);

        expect(bannerAd, isNotNull);
        expect(bannerAd?.adUnitId, adUnitId);
      });

      test('存在しないバナー広告はnullを返す', () {
        final bannerAd = adMobService.getBannerAd('non-existent');

        expect(bannerAd, isNull);
      });

      test('存在するリワード広告を取得できる', () async {
        const adUnitId = 'test-rewarded-get';
        
        final fakeRewardedAd = FakeRewardedAd(adUnitId: adUnitId);
        adMobService.addFakeRewardedAd(adUnitId, fakeRewardedAd);

        await adMobService.loadRewardedAd(
          adUnitId: adUnitId,
          onAdLoaded: (_) {},
        );

        final rewardedAd = adMobService.getRewardedAd(adUnitId);
        expect(rewardedAd, isNotNull);
      });

      test('存在しないリワード広告はnullを返す', () {
        final rewardedAd = adMobService.getRewardedAd('non-existent');

        expect(rewardedAd, isNull);
      });
    });

    group('disposeBannerAd / disposeRewardedAd', () {
      test('バナー広告を破棄できる', () {
        const adUnitId = 'test-banner-dispose';
        
        adMobService.createBannerAd(adUnitId: adUnitId);
        adMobService.disposeBannerAd(adUnitId);

        expect(adMobService.getBannerAd(adUnitId), isNull);
      });

      test('リワード広告を破棄できる', () async {
        const adUnitId = 'test-rewarded-dispose';
        
        final fakeRewardedAd = FakeRewardedAd(adUnitId: adUnitId);
        adMobService.addFakeRewardedAd(adUnitId, fakeRewardedAd);

        await adMobService.loadRewardedAd(
          adUnitId: adUnitId,
          onAdLoaded: (_) {},
        );

        adMobService.disposeRewardedAd(adUnitId);

        expect(adMobService.getRewardedAd(adUnitId), isNull);
        expect(fakeRewardedAd.isDisposed, isTrue);
      });
    });

    group('dispose', () {
      test('すべての広告を破棄できる', () async {
        // 複数のバナー広告を作成
        adMobService.createBannerAd(adUnitId: 'banner-1');
        adMobService.createBannerAd(adUnitId: 'banner-2');

        // 複数のリワード広告を作成
        final rewarded1 = FakeRewardedAd(adUnitId: 'rewarded-1');
        final rewarded2 = FakeRewardedAd(adUnitId: 'rewarded-2');
        adMobService.addFakeRewardedAd('rewarded-1', rewarded1);
        adMobService.addFakeRewardedAd('rewarded-2', rewarded2);

        await adMobService.loadRewardedAd(
          adUnitId: 'rewarded-1',
          onAdLoaded: (_) {},
        );
        await adMobService.loadRewardedAd(
          adUnitId: 'rewarded-2',
          onAdLoaded: (_) {},
        );

        // すべて破棄
        adMobService.dispose();

        // すべての広告がクリアされていることを確認
        expect(adMobService.getBannerAd('banner-1'), isNull);
        expect(adMobService.getBannerAd('banner-2'), isNull);
        expect(adMobService.getRewardedAd('rewarded-1'), isNull);
        expect(adMobService.getRewardedAd('rewarded-2'), isNull);
      });
    });
  });
}