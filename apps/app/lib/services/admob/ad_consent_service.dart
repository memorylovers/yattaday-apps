import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/exception/app_exception_helpers.dart';
import '../../common/logger/logger.dart';

final adConsentServiceProvider = Provider<AdConsentService>(
  (ref) => AdConsentService(),
);

/// 広告同意サービス
///
/// GDPRおよびその他のプライバシー規制に準拠した広告同意管理を提供します。
/// エラーハンドリングとロギング機能を含みます。
class AdConsentService {
  final ConsentInformation _consentInformation;

  /// コンストラクタ
  ///
  /// [consentInformation] ConsentInformationインスタンス
  AdConsentService({ConsentInformation? consentInformation})
    : _consentInformation = consentInformation ?? ConsentInformation.instance;

  /// 同意情報を更新します
  Future<void> requestConsentInfoUpdate({
    ConsentDebugSettings? debugSettings,
  }) async {
    final params = ConsentRequestParameters(
      consentDebugSettings: debugSettings,
    );

    try {
      final completer = Completer<void>();
      _consentInformation.requestConsentInfoUpdate(
        params,
        () {
          logger.debug('Consent info updated successfully');
          completer.complete();
        },
        (FormError error) {
          logger.error(
            'Failed to update consent info: ${error.errorCode}: ${error.message}',
          );
          completer.completeError(AppExceptions.adLoadFailed(error));
        },
      );
      await completer.future;
    } catch (error) {
      logger.error('Failed to update consent info', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// プライバシーオプションが必要かどうかを確認します
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status =
          await _consentInformation.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (error) {
      logger.error('Failed to get privacy options requirement status', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// 必要に応じて同意フォームを読み込み、表示します
  Future<void> loadAndShowConsentFormIfRequired() async {
    try {
      final completer = Completer<void>();
      ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          logger.error(
            'Error loading consent form: ${error.errorCode}: ${error.message}',
          );
          completer.completeError(AppExceptions.adLoadFailed(error));
        } else {
          logger.debug('Consent form shown');
          completer.complete();
        }
      });
      await completer.future;
    } catch (error) {
      logger.error('Error loading consent form', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// プライバシーオプションフォームを表示します
  Future<void> showPrivacyOptionsForm() async {
    try {
      final completer = Completer<void>();
      ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (error != null) {
          logger.error(
            'Error showing privacy options: ${error.errorCode}: ${error.message}',
          );
          completer.completeError(AppExceptions.adLoadFailed(error));
        } else {
          logger.debug('Privacy options form shown');
          completer.complete();
        }
      });
      await completer.future;
    } catch (error) {
      logger.error('Error showing privacy options', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// 同意情報をリセットします
  Future<void> resetConsent() async {
    try {
      await _consentInformation.reset();
      logger.info('Consent information reset');
    } catch (error) {
      logger.error('Failed to reset consent', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// 広告リクエストが可能かどうかを確認します
  Future<bool> canRequestAds() async {
    try {
      return await _consentInformation.canRequestAds();
    } catch (error) {
      logger.error('Failed to check if can request ads', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }

  /// 同意のチェックとリクエスト（統合メソッド）
  ///
  /// 同意情報の更新、必要に応じて同意フォームの表示、AdMobの初期化を行います
  Future<void> checkAndRequestAdConsent({
    ConsentDebugSettings? debugSettings,
  }) async {
    try {
      // 同意ステータスの取得
      final status = await _consentInformation.getConsentStatus();
      logger.debug('Current consent status: $status');

      // 同意情報の更新
      await requestConsentInfoUpdate(debugSettings: debugSettings);

      // 必要に応じて同意フォームの表示
      await loadAndShowConsentFormIfRequired();

      // 広告リクエストが可能かチェック
      final canRequest = await canRequestAds();
      logger.debug('Can request ads: $canRequest');

      if (canRequest) {
        // AdMobの初期化
        await MobileAds.instance.initialize();
        logger.info('AdMob initialized after consent');
      }
    } catch (error) {
      logger.error('Failed to check and request ad consent', error);
      throw AppExceptions.adLoadFailed(error);
    }
  }
}
