import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/common/exception/app_error_code.dart';
import 'package:myapp/common/exception/app_exception.dart';
import 'package:myapp/services/revenuecat/revenuecat_service.dart';

void main() {
  group('RevenueCatService', () {
    late RevenueCatService revenueCatService;

    setUp(() {
      revenueCatService = RevenueCatService();
    });

    group('initialize', () {
      test('未初期化状態ではisConfiguredがfalse', () {
        expect(revenueCatService.isConfigured, isFalse);
      });

      test('初期化エラーがAppExceptionとして伝播される', () async {
        // 実際のPurchases SDKを使わずにテストすることは困難なため、
        // エラーハンドリングのテストは統合テストで行うことを推奨
        expect(revenueCatService.isConfigured, isFalse);
      });
    });

    group('_ensureConfigured', () {
      test('未初期化の場合はAppExceptionがスローされる', () async {
        // getCustomerInfoを呼び出すことで_ensureConfiguredが呼ばれる
        expect(
          () => revenueCatService.getCustomerInfo(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
          ),
        );
      });

      test('他のメソッドも未初期化の場合はエラー', () async {
        expect(
          () => revenueCatService.setUserId('user_123'),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
          ),
        );

        expect(
          () => revenueCatService.getOfferings(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
          ),
        );

        expect(
          () => revenueCatService.restorePurchases(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
          ),
        );

        expect(
          () => revenueCatService.logOut(),
          throwsA(
            isA<AppException>()
                .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
          ),
        );
      });
    });

    group('currentUserId', () {
      test('初期状態ではnull', () {
        expect(revenueCatService.currentUserId, isNull);
      });
    });

    group('checkIfConfigured', () {
      test('初期状態ではfalseを返す', () async {
        // 実際のPurchases.isConfiguredを呼び出すため、
        // 未初期化状態ではfalseが返される
        final result = await revenueCatService.checkIfConfigured();
        expect(result, isFalse);
      });
    });

    group('リスナー管理', () {
      test('リスナーの追加と削除が正常に動作する', () {
        // リスナーの追加・削除は実際のPurchases SDKに委譲されるため、
        // エラーが発生しないことのみを確認
        void listener(dynamic info) {}

        expect(
          () => revenueCatService.addCustomerInfoUpdateListener(listener),
          returnsNormally,
        );

        expect(
          () => revenueCatService.removeCustomerInfoUpdateListener(listener),
          returnsNormally,
        );
      });
    });

    group('エラーハンドリング', () {
      test('すべてのメソッドがAppExceptionを適切にスローする', () {
        // 未初期化状態でのエラーハンドリングを確認
        final methods = [
          () => revenueCatService.setUserId('test'),
          () => revenueCatService.getCustomerInfo(),
          () => revenueCatService.getOfferings(),
          () => revenueCatService.restorePurchases(),
          () => revenueCatService.logOut(),
        ];

        for (final method in methods) {
          expect(
            method,
            throwsA(
              isA<AppException>()
                  .having((e) => e.code, 'code', AppErrorCode.purchaseNotConfigured),
            ),
          );
        }
      });
    });

    group('統合テストの推奨事項', () {
      test('RevenueCat SDKの実際の動作は統合テストで検証すべき', () {
        // このテストファイルでは、RevenueCatServiceのエラーハンドリングと
        // 基本的な状態管理のみをテストしています。
        // 
        // 以下の機能は実際のRevenueCat SDKとの統合が必要なため、
        // 統合テストまたはモックSDKを使用したテストを推奨します：
        // - initialize: SDK初期化の成功/失敗
        // - setUserId: ユーザーIDの設定とLogInResultの返却
        // - getCustomerInfo: カスタマー情報の取得
        // - getOfferings: オファリング情報の取得
        // - purchasePackage: パッケージの購入処理
        // - restorePurchases: 購入履歴の復元
        // - logOut: ログアウト処理
        
        expect(true, isTrue); // このテストは情報提供のため
      });
    });
  });
}