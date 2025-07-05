import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/exception/app_exception_helpers.dart';
import '../../common/logger/logger.dart';

final adMobServiceProvider = Provider<AdMobService>((ref) {
  final service = AdMobService();
  ref.onDispose(service.dispose);
  return service;
});

/// AdMobサービス
///
/// Google Mobile Adsの機能をラップし、バナー広告とリワード広告の管理を提供します。
/// エラーハンドリングとロギング機能を含みます。
class AdMobService {
  final Map<String, BannerAd> _bannerAds = {};
  final Map<String, RewardedAd> _rewardedAds = {};

  /// AdMobを初期化します
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      logger.info('AdMob initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize AdMob', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// バナー広告を作成します（ロードはしません）
  ///
  /// [adUnitId] 広告ユニットID
  /// [adSize] 広告サイズ
  /// [label] ログ用のラベル
  /// [onAdLoaded] 広告ロード成功時のコールバック
  /// [onAdFailedToLoad] 広告ロード失敗時のコールバック
  /// [onAdOpened] 広告が開かれた時のコールバック
  /// [onAdClosed] 広告が閉じられた時のコールバック
  /// [onAdClicked] 広告がクリックされた時のコールバック
  /// [onAdImpression] 広告のインプレッション時のコールバック
  /// [onPaidEvent] 有料イベント時のコールバック
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
    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          logger.debug('$label@onAdLoaded: ad=${ad.adUnitId}');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          logger.warning(
            '$label@onAdFailedToLoad: ad=${ad.adUnitId}, err=${error.message}',
          );
          onAdFailedToLoad?.call(ad, error);
        },
        onAdOpened: (ad) {
          logger.debug('$label@onAdOpened: ad=${ad.adUnitId}');
          onAdOpened?.call(ad);
        },
        onAdClosed: (ad) {
          logger.debug('$label@onAdClosed: ad=${ad.adUnitId}');
          onAdClosed?.call(ad);
        },
        onAdClicked: (ad) {
          logger.debug('$label@onAdClicked: ad=${ad.adUnitId}');
          onAdClicked?.call(ad);
        },
        onAdImpression: (ad) {
          logger.debug('$label@onAdImpression: ad=${ad.adUnitId}');
          onAdImpression?.call(ad);
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          logger.debug(
            '$label@onPaidEvent: ad=${ad.adUnitId}, value=$valueMicros',
          );
          onPaidEvent?.call(ad, valueMicros, precision, currencyCode);
        },
      ),
    );

    _bannerAds[adUnitId] = bannerAd;
    return bannerAd;
  }

  /// リワード広告をロードします
  ///
  /// [adUnitId] 広告ユニットID
  /// [label] ログ用のラベル
  /// [onAdLoaded] 広告ロード成功時のコールバック
  /// [onAdFailedToLoad] 広告ロード失敗時のコールバック
  /// [onAdShowedFullScreenContent] フルスクリーン表示時のコールバック
  /// [onAdFailedToShowFullScreenContent] フルスクリーン表示失敗時のコールバック
  /// [onAdDismissedFullScreenContent] フルスクリーン終了時のコールバック
  /// [onUserEarnedReward] リワード獲得時のコールバック
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
    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            logger.debug('$label@onAdLoaded: ad=${ad.adUnitId}');
            _rewardedAds[adUnitId] = ad;

            // フルスクリーンコンテンツのコールバック設定
            ad.fullScreenContentCallback = FullScreenContentCallback<
              RewardedAd
            >(
              onAdShowedFullScreenContent: (ad) {
                logger.debug(
                  '$label@onAdShowedFullScreenContent: ad=${ad.adUnitId}',
                );
                onAdShowedFullScreenContent?.call(ad);
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                logger.warning(
                  '$label@onAdFailedToShowFullScreenContent: ad=${ad.adUnitId}',
                );
                onAdFailedToShowFullScreenContent?.call(ad, error);
              },
              onAdDismissedFullScreenContent: (ad) {
                logger.debug(
                  '$label@onAdDismissedFullScreenContent: ad=${ad.adUnitId}',
                );
                onAdDismissedFullScreenContent?.call(ad);
              },
            );

            onAdLoaded?.call(ad);
          },
          onAdFailedToLoad: (error) {
            logger.warning('$label@onAdFailedToLoad: err=${error.message}');
            onAdFailedToLoad?.call(error);
          },
        ),
      );
    } catch (error) {
      logger.error('Failed to load rewarded ad', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// 指定されたバナー広告を取得します
  BannerAd? getBannerAd(String adUnitId) {
    return _bannerAds[adUnitId];
  }

  /// 指定されたリワード広告を取得します
  RewardedAd? getRewardedAd(String adUnitId) {
    return _rewardedAds[adUnitId];
  }

  /// 指定されたバナー広告を破棄します
  void disposeBannerAd(String adUnitId) {
    _bannerAds[adUnitId]?.dispose();
    _bannerAds.remove(adUnitId);
  }

  /// 指定されたリワード広告を破棄します
  void disposeRewardedAd(String adUnitId) {
    _rewardedAds[adUnitId]?.dispose();
    _rewardedAds.remove(adUnitId);
  }

  /// すべての広告を破棄します
  void dispose() {
    for (final ad in _bannerAds.values) {
      ad.dispose();
    }
    _bannerAds.clear();

    for (final ad in _rewardedAds.values) {
      ad.dispose();
    }
    _rewardedAds.clear();
  }
}
