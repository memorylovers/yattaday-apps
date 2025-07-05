import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../flavors.dart';
import '../../../common/providers/service_providers.dart';

part 'admob_store.freezed.dart';
part 'admob_store.g.dart';

@freezed
class BannerAdWithSize with _$BannerAdWithSize {
  const BannerAdWithSize._();
  const factory BannerAdWithSize({
    required BannerAd bannerAd,
    required AdSize adSize,
  }) = _BannerAdWithSize;

  dispose() {
    bannerAd.dispose();
  }

  SizedBox get widget {
    return SizedBox(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: bannerAd.widget,
    );
  }
}

@freezed
class AdBannerStoreState with _$AdBannerStoreState {
  const AdBannerStoreState._();
  const factory AdBannerStoreState({
    required bool loading,
    required BannerAd? bannerTop,
    required BannerAd? bannerResult,
    required AsyncValue<RewardedAd?> rewardedAd,
  }) = _AdBannerStoreState;
}

@Riverpod(keepAlive: true)
class AdBannerStore extends _$AdBannerStore {
  late final AdMobService _adMobService;

  @override
  AdBannerStoreState build() {
    _adMobService = ref.watch(adMobServiceProvider);
    createTop();
    createResult();

    ref.onDispose(() {
      _adMobService.disposeBannerAd(kAdMobBannerTop);
      _adMobService.disposeBannerAd(kAdMobBannerResult);
    });

    return const AdBannerStoreState(
      loading: false,
      bannerTop: null,
      bannerResult: null,
      rewardedAd: AsyncValue.data(null),
    );
  }

  // ********************************************************
  // * private
  // ********************************************************
  void createTop() {
    // バナー広告を作成
    final bannerAd = _adMobService.createBannerAd(
      adUnitId: kAdMobBannerTop,
      label: "AdBannerTop",
      adSize: AdSize.banner,
      onAdLoaded: (ad) {
        state = state.copyWith(bannerTop: ad as BannerAd);
      },
      onAdFailedToLoad: (ad, error) {
        state = state.copyWith(bannerTop: null);
        _adMobService.disposeBannerAd(kAdMobBannerTop);
        // ネットワークエラー時に、少し待って再試行
        Future.delayed(10.seconds).then((_) => createTop());
      },
    );
    bannerAd.load();
  }

  void createResult() {
    // バナー広告を作成
    final bannerAd = _adMobService.createBannerAd(
      adUnitId: kAdMobBannerResult,
      label: "AdBannerResult",
      adSize: AdSize.mediumRectangle,
      onAdLoaded: (ad) {
        state = state.copyWith(bannerResult: ad as BannerAd);
      },
      onAdFailedToLoad: (ad, error) {
        state = state.copyWith(bannerResult: null);
        _adMobService.disposeBannerAd(kAdMobBannerResult);
        // ネットワークエラー時に、少し待って再試行
        Future.delayed(10.seconds).then((_) => createResult());
      },
    );
    bannerAd.load();
  }

  void loadReward() {
    state = state.copyWith(rewardedAd: const AsyncValue.loading());
    _adMobService.loadRewardedAd(
      adUnitId: kAdMobReward,
      label: "AdReward",
      onAdLoaded: (ad) {
        state = state.copyWith(rewardedAd: AsyncValue.data(ad));
      },
      onAdFailedToLoad: (error) {
        state = state.copyWith(
          rewardedAd: AsyncValue.error(error, StackTrace.current),
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        state = state.copyWith(
          rewardedAd: AsyncValue.error(error, StackTrace.current),
        );
        _adMobService.disposeRewardedAd(kAdMobReward);
      },
      onAdDismissedFullScreenContent: (ad) {
        state = state.copyWith(rewardedAd: const AsyncValue.data(null));
        _adMobService.disposeRewardedAd(kAdMobReward);
      },
    );
  }
}

// ********************************************************
// * private
// ********************************************************
extension AdSizeEx on AdSize {
  double get aspect {
    return width / height;
  }
}

extension BannerAdEx on BannerAd {
  AdWidget get widget {
    return AdWidget(ad: this);
  }
}
