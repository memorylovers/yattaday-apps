import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admob_service.g.dart';

class AdMobService {
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  Future<BannerAd?> loadBannerAd({
    required String adUnitId,
    required AdSize size,
  }) async {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    await _bannerAd!.load();
    return _bannerAd;
  }

  Future<RewardedAd?> loadRewardedAd({
    required String adUnitId,
  }) async {
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );

    return _rewardedAd;
  }

  void dispose() {
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
  }
}

@riverpod
AdMobService adMobService(Ref ref) {
  final service = AdMobService();
  ref.onDispose(service.dispose);
  return service;
}