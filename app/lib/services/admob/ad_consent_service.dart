import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/exception/app_error_code.dart';
import '../../common/exception/app_exception.dart';
import '../../common/logger/logger.dart';

final adConsentServiceProvider = Provider.autoDispose<AdConsentService>(
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
  Future<void> requestConsentInfoUpdate() async {
    final params = ConsentRequestParameters();

    try {
      _consentInformation.requestConsentInfoUpdate(
        params,
        () => logger.debug('Consent info updated successfully'),
        (FormError error) {
          logger.error(
            'Failed to update consent info: ${error.errorCode}: ${error.message}',
          );
          throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
        },
      );
    } catch (error) {
      logger.error('Failed to update consent info', error);
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
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
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
    }
  }

  /// 必要に応じて同意フォームを読み込み、表示します
  Future<void> loadAndShowConsentFormIfRequired() async {
    try {
      ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          logger.error(
            'Error loading consent form: ${error.errorCode}: ${error.message}',
          );
          throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
        } else {
          logger.debug('Consent form shown');
        }
      });
    } catch (error) {
      logger.error('Error loading consent form', error);
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
    }
  }

  /// プライバシーオプションフォームを表示します
  Future<void> showPrivacyOptionsForm() async {
    try {
      ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (error != null) {
          logger.error(
            'Error showing privacy options: ${error.errorCode}: ${error.message}',
          );
          throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
        } else {
          logger.debug('Privacy options form shown');
        }
      });
    } catch (error) {
      logger.error('Error showing privacy options', error);
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
    }
  }

  /// 同意情報をリセットします
  Future<void> resetConsent() async {
    try {
      await _consentInformation.reset();
      logger.info('Consent information reset');
    } catch (error) {
      logger.error('Failed to reset consent', error);
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
    }
  }

  /// 広告リクエストが可能かどうかを確認します
  Future<bool> canRequestAds() async {
    try {
      return await _consentInformation.canRequestAds();
    } catch (error) {
      logger.error('Failed to check if can request ads', error);
      throw AppException(code: AppErrorCode.adLoadFailed, cause: error);
    }
  }
}
