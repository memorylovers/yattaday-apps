import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../common/exception/app_error_code.dart';
import '../../common/exception/app_exception.dart';
import '../../common/logger/logger.dart';

final revenueCatServiceProvider = Provider.autoDispose<RevenueCatService>(
  (ref) => RevenueCatService(),
);

/// RevenueCatサービス
///
/// RevenueCat SDKの機能をラップし、アプリ内課金の管理を提供します。
/// エラーハンドリングとロギング機能を含みます。
class RevenueCatService {
  bool _isConfigured = false;
  String? _currentUserId;

  /// RevenueCatを初期化します
  ///
  /// [apiKey] RevenueCat APIキー
  /// [appUserId] アプリユーザーID（オプション）
  Future<void> initialize(String apiKey, {String? appUserId}) async {
    try {
      if (_isConfigured) {
        logger.debug('RevenueCat already configured');
        return;
      }

      final configuration = PurchasesConfiguration(apiKey);
      if (appUserId != null) {
        configuration.appUserID = appUserId;
        _currentUserId = appUserId;
      }

      await Purchases.configure(configuration);
      _isConfigured = true;
      logger.info('RevenueCat initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize RevenueCat', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// ユーザーIDを設定・更新します
  ///
  /// [userId] ユーザーID
  /// [email] メールアドレス（オプション）
  Future<LogInResult> setUserId(String userId, {String? email}) async {
    try {
      _ensureConfigured();

      // 現在のユーザーIDと同じ場合は何もしない
      if (_currentUserId == userId) {
        logger.debug('User ID already set: $userId');
        return LogInResult(
          customerInfo: await Purchases.getCustomerInfo(),
          created: false,
        );
      }

      final result = await Purchases.logIn(userId);
      _currentUserId = userId;

      if (email != null && email.isNotEmpty) {
        await Purchases.setEmail(email);
      }

      logger.debug('User logged in: $userId');
      return result;
    } catch (error) {
      logger.error('Failed to set user ID', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// カスタマー情報を取得します
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      _ensureConfigured();
      return await Purchases.getCustomerInfo();
    } catch (error) {
      logger.error('Failed to get customer info', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// 利用可能なオファリングを取得します
  Future<Offerings> getOfferings() async {
    try {
      _ensureConfigured();
      return await Purchases.getOfferings();
    } catch (error) {
      logger.error('Failed to get offerings', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// パッケージを購入します
  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      _ensureConfigured();
      final customerInfo = await Purchases.purchasePackage(package);
      logger.info('Package purchased successfully: ${package.identifier}');
      return customerInfo;
    } catch (error) {
      logger.error('Failed to purchase package', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// 購入履歴を復元します
  Future<CustomerInfo> restorePurchases() async {
    try {
      _ensureConfigured();
      final customerInfo = await Purchases.restorePurchases();
      logger.info('Purchases restored successfully');
      return customerInfo;
    } catch (error) {
      logger.error('Failed to restore purchases', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// ログアウトします
  Future<CustomerInfo> logOut() async {
    try {
      _ensureConfigured();
      final customerInfo = await Purchases.logOut();
      _currentUserId = null;
      logger.info('User logged out successfully');
      return customerInfo;
    } catch (error) {
      logger.error('Failed to log out', error);
      throw AppException(code: AppErrorCode.purchaseError, cause: error);
    }
  }

  /// カスタマー情報更新リスナーを追加します
  void addCustomerInfoUpdateListener(
    void Function(CustomerInfo customerInfo) listener,
  ) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  /// カスタマー情報更新リスナーを削除します
  void removeCustomerInfoUpdateListener(
    void Function(CustomerInfo customerInfo) listener,
  ) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  /// RevenueCatが初期化済みかどうか
  bool get isConfigured => _isConfigured;

  /// RevenueCatが初期化済みかどうかを確認します
  Future<bool> checkIfConfigured() async {
    try {
      final isConfigured = await Purchases.isConfigured;
      _isConfigured = isConfigured;
      return isConfigured;
    } catch (error) {
      logger.error('Failed to check if configured', error);
      return false;
    }
  }

  /// 現在のユーザーID
  String? get currentUserId => _currentUserId;

  void _ensureConfigured() {
    if (!_isConfigured) {
      throw const AppException(code: AppErrorCode.purchaseNotConfigured);
    }
  }
}
