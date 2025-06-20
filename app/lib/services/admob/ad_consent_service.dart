import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_consent_service.g.dart';

class AdConsentService {
  final ConsentInformation _consentInformation = ConsentInformation.instance;
  
  Future<void> requestConsentInfoUpdate() async {
    final params = ConsentRequestParameters();
    
    try {
      _consentInformation.requestConsentInfoUpdate(
        params,
        () => debugPrint('Consent info updated successfully'),
        (FormError error) => debugPrint('Failed to update consent info: ${error.errorCode}: ${error.message}'),
      );
    } catch (error) {
      debugPrint('Failed to update consent info: $error');
      rethrow;
    }
  }

  Future<bool> isPrivacyOptionsRequired() async {
    final status = await _consentInformation.getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  }

  Future<void> loadAndShowConsentFormIfRequired() async {
    try {
      ConsentForm.loadAndShowConsentFormIfRequired(
        (FormError? error) {
          if (error != null) {
            debugPrint('Error loading consent form: ${error.errorCode}: ${error.message}');
          } else {
            debugPrint('Consent form shown');
          }
        },
      );
    } catch (error) {
      debugPrint('Error loading consent form: $error');
      rethrow;
    }
  }
  
  Future<void> showPrivacyOptionsForm() async {
    try {
      ConsentForm.showPrivacyOptionsForm(
        (FormError? error) {
          if (error != null) {
            debugPrint('Error showing privacy options: ${error.errorCode}: ${error.message}');
          } else {
            debugPrint('Privacy options form shown');
          }
        },
      );
    } catch (error) {
      debugPrint('Error showing privacy options: $error');
      rethrow;
    }
  }

  Future<void> resetConsent() async {
    await _consentInformation.reset();
  }

  Future<bool> canRequestAds() async {
    return await _consentInformation.canRequestAds();
  }
}

@riverpod
AdConsentService adConsentService(Ref ref) {
  return AdConsentService();
}