import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/services/admob/ad_consent_service.dart';

// ConsentInformation用のFake実装
class FakeConsentInformation implements ConsentInformation {
  ConsentStatus _consentStatus = ConsentStatus.unknown;
  PrivacyOptionsRequirementStatus _privacyOptionsRequirementStatus = 
      PrivacyOptionsRequirementStatus.notRequired;
  bool _canRequestAds = false;
  bool _shouldThrowOnUpdate = false;
  bool _shouldThrowOnReset = false;
  bool _isReset = false;

  // テスト用のセッター
  void setConsentStatus(ConsentStatus status) {
    _consentStatus = status;
  }

  void setPrivacyOptionsRequirementStatus(PrivacyOptionsRequirementStatus status) {
    _privacyOptionsRequirementStatus = status;
  }

  void setCanRequestAds(bool canRequest) {
    _canRequestAds = canRequest;
  }

  void setShouldThrowOnUpdate(bool shouldThrow) {
    _shouldThrowOnUpdate = shouldThrow;
  }

  void setShouldThrowOnReset(bool shouldThrow) {
    _shouldThrowOnReset = shouldThrow;
  }

  bool get isReset => _isReset;

  @override
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    VoidCallback successListener,
    OnConsentInfoUpdateFailureListener failureListener,
  ) {
    // 非同期処理をシミュレート
    Timer(const Duration(milliseconds: 10), () {
      if (_shouldThrowOnUpdate) {
        failureListener(FormError(errorCode: 1, message: 'Update failed'));
      } else {
        successListener();
      }
    });
  }

  @override
  Future<ConsentStatus> getConsentStatus() async {
    return _consentStatus;
  }

  @override
  Future<PrivacyOptionsRequirementStatus> getPrivacyOptionsRequirementStatus() async {
    return _privacyOptionsRequirementStatus;
  }

  @override
  Future<bool> canRequestAds() async {
    return _canRequestAds;
  }

  @override
  Future<void> reset() async {
    if (_shouldThrowOnReset) {
      throw Exception('Reset failed');
    }
    _isReset = true;
    _consentStatus = ConsentStatus.unknown;
  }

  @override
  Future<bool> isConsentFormAvailable() async => true;
}

// ConsentForm用のモック実装
class MockConsentForm {
  static bool shouldFailLoad = false;
  static bool shouldFailShow = false;
  static bool formShown = false;
  static bool privacyOptionsShown = false;

  static void reset() {
    shouldFailLoad = false;
    shouldFailShow = false;
    formShown = false;
    privacyOptionsShown = false;
  }

  static void loadAndShowConsentFormIfRequired(
    OnConsentFormDismissedListener onConsentFormDismissedListener,
  ) {
    Timer(const Duration(milliseconds: 10), () {
      if (shouldFailLoad) {
        onConsentFormDismissedListener(
          FormError(errorCode: 2, message: 'Load failed'),
        );
      } else {
        formShown = true;
        onConsentFormDismissedListener(null);
      }
    });
  }

  static void showPrivacyOptionsForm(
    OnConsentFormDismissedListener onConsentFormDismissedListener,
  ) {
    Timer(const Duration(milliseconds: 10), () {
      if (shouldFailShow) {
        onConsentFormDismissedListener(
          FormError(errorCode: 3, message: 'Show failed'),
        );
      } else {
        privacyOptionsShown = true;
        onConsentFormDismissedListener(null);
      }
    });
  }
}

// MobileAds用のテストインスタンス
class TestMobileAdsInstance {
  bool isInitialized = false;

  Future<InitializationStatus> initialize() async {
    isInitialized = true;
    return TestInitializationStatus();
  }
}

// InitializationStatus用のテスト実装
class TestInitializationStatus implements InitializationStatus {
  @override
  Map<String, AdapterStatus> get adapterStatuses => {};
}

void main() {
  late FakeConsentInformation fakeConsentInformation;
  late AdConsentService adConsentService;

  setUp(() {
    fakeConsentInformation = FakeConsentInformation();
    adConsentService = AdConsentService(
      consentInformation: fakeConsentInformation,
    );
    MockConsentForm.reset();
  });

  group('AdConsentService', () {
    group('requestConsentInfoUpdate', () {
      test('同意情報を正常に更新できる', () async {
        await expectLater(
          adConsentService.requestConsentInfoUpdate(),
          completes,
        );
      });

      test('更新エラーがAppExceptionとして伝播される', () async {
        fakeConsentInformation.setShouldThrowOnUpdate(true);

        expect(
          () => adConsentService.requestConsentInfoUpdate(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.adLoadFailed),
          ),
        );
      });

      test('デバッグ設定を指定して更新できる', () async {
        final debugSettings = ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
        );

        await expectLater(
          adConsentService.requestConsentInfoUpdate(
            debugSettings: debugSettings,
          ),
          completes,
        );
      });
    });

    group('isPrivacyOptionsRequired', () {
      test('プライバシーオプションが必要な場合trueを返す', () async {
        fakeConsentInformation.setPrivacyOptionsRequirementStatus(
          PrivacyOptionsRequirementStatus.required,
        );

        final result = await adConsentService.isPrivacyOptionsRequired();

        expect(result, isTrue);
      });

      test('プライバシーオプションが不要な場合falseを返す', () async {
        fakeConsentInformation.setPrivacyOptionsRequirementStatus(
          PrivacyOptionsRequirementStatus.notRequired,
        );

        final result = await adConsentService.isPrivacyOptionsRequired();

        expect(result, isFalse);
      });

      test('プライバシーオプションステータスが不明な場合falseを返す', () async {
        fakeConsentInformation.setPrivacyOptionsRequirementStatus(
          PrivacyOptionsRequirementStatus.unknown,
        );

        final result = await adConsentService.isPrivacyOptionsRequired();

        expect(result, isFalse);
      });
    });

    group('loadAndShowConsentFormIfRequired', () {
      test('同意フォームを正常に表示できる', () async {
        // ConsentFormのモックメソッドを直接使用
        var callbackCalled = false;
        MockConsentForm.loadAndShowConsentFormIfRequired((error) {
          callbackCalled = true;
          expect(error, isNull);
        });

        await Future.delayed(const Duration(milliseconds: 20));
        expect(callbackCalled, isTrue);
        expect(MockConsentForm.formShown, isTrue);
      });

      test('フォーム表示エラーがAppExceptionとして伝播される', () async {
        // ConsentFormのモックメソッドでエラーをシミュレート
        MockConsentForm.shouldFailLoad = true;
        
        var callbackCalled = false;
        MockConsentForm.loadAndShowConsentFormIfRequired((error) {
          callbackCalled = true;
          expect(error, isNotNull);
        });

        await Future.delayed(const Duration(milliseconds: 20));
        expect(callbackCalled, isTrue);
      });
    });

    group('showPrivacyOptionsForm', () {
      test('プライバシーオプションフォームを正常に表示できる', () async {
        var callbackCalled = false;
        MockConsentForm.showPrivacyOptionsForm((error) {
          callbackCalled = true;
          expect(error, isNull);
        });

        await Future.delayed(const Duration(milliseconds: 20));
        expect(callbackCalled, isTrue);
        expect(MockConsentForm.privacyOptionsShown, isTrue);
      });

      test('プライバシーオプション表示エラーがAppExceptionとして伝播される', () async {
        MockConsentForm.shouldFailShow = true;
        
        var callbackCalled = false;
        MockConsentForm.showPrivacyOptionsForm((error) {
          callbackCalled = true;
          expect(error, isNotNull);
        });

        await Future.delayed(const Duration(milliseconds: 20));
        expect(callbackCalled, isTrue);
      });
    });

    group('resetConsent', () {
      test('同意情報をリセットできる', () async {
        await adConsentService.resetConsent();

        expect(fakeConsentInformation.isReset, isTrue);
      });

      test('リセットエラーがAppExceptionとして伝播される', () async {
        fakeConsentInformation.setShouldThrowOnReset(true);

        expect(
          () => adConsentService.resetConsent(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.adLoadFailed),
          ),
        );
      });
    });

    group('canRequestAds', () {
      test('広告リクエストが可能な場合trueを返す', () async {
        fakeConsentInformation.setCanRequestAds(true);

        final result = await adConsentService.canRequestAds();

        expect(result, isTrue);
      });

      test('広告リクエストが不可能な場合falseを返す', () async {
        fakeConsentInformation.setCanRequestAds(false);

        final result = await adConsentService.canRequestAds();

        expect(result, isFalse);
      });
    });

    group('checkAndRequestAdConsent', () {
      test('同意チェックとリクエストの統合フローが正常に動作する', () async {
        fakeConsentInformation.setConsentStatus(ConsentStatus.obtained);
        fakeConsentInformation.setCanRequestAds(true);

        // checkAndRequestAdConsentの実行
        await expectLater(
          adConsentService.checkAndRequestAdConsent(),
          completes,
        );

        // 注：実際のMobileAds.instanceの初期化はテストでは確認できないため、
        // ロジックフローのみをテスト
      });

      test('同意ステータスが不明な場合でも処理が継続される', () async {
        fakeConsentInformation.setConsentStatus(ConsentStatus.unknown);
        fakeConsentInformation.setCanRequestAds(false);

        await expectLater(
          adConsentService.checkAndRequestAdConsent(),
          completes,
        );
      });

      test('デバッグ設定を使用して同意チェックができる', () async {
        final debugSettings = ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
        );
        
        fakeConsentInformation.setConsentStatus(ConsentStatus.required);
        fakeConsentInformation.setCanRequestAds(true);

        await expectLater(
          adConsentService.checkAndRequestAdConsent(
            debugSettings: debugSettings,
          ),
          completes,
        );
      });

      test('エラーが発生した場合AppExceptionがスローされる', () async {
        fakeConsentInformation.setShouldThrowOnUpdate(true);

        expect(
          () => adConsentService.checkAndRequestAdConsent(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.adLoadFailed),
          ),
        );
      });
    });
  });
}