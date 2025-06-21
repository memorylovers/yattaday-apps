import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  bool _isConfigured = false;

  Future<void> initialize(String apiKey) async {
    if (_isConfigured) return;

    await Purchases.configure(PurchasesConfiguration(apiKey));
    _isConfigured = true;
  }

  Future<CustomerInfo> getCustomerInfo() async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }
    return await Purchases.getCustomerInfo();
  }

  Future<List<Package>> getOfferings() async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }

    final offerings = await Purchases.getOfferings();
    final current = offerings.current;

    if (current == null) {
      return [];
    }

    return current.availablePackages;
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }

    final purchaseResult = await Purchases.purchasePackage(package);
    return purchaseResult;
  }

  Future<CustomerInfo> restorePurchases() async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }

    return await Purchases.restorePurchases();
  }

  Future<void> logIn(String userId) async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }

    await Purchases.logIn(userId);
  }

  Future<void> logOut() async {
    if (!_isConfigured) {
      throw StateError('RevenueCat not configured. Call initialize() first.');
    }

    await Purchases.logOut();
  }

  bool get isConfigured => _isConfigured;
}
