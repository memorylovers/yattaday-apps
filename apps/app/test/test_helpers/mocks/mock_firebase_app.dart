import 'package:firebase_core/firebase_core.dart';

/// FirebaseApp用のモック実装
class MockFirebaseApp implements FirebaseApp {
  @override
  final String name;
  
  @override
  final FirebaseOptions options;

  MockFirebaseApp({
    this.name = '[DEFAULT]',
    FirebaseOptions? options,
  }) : options = options ?? _defaultOptions;

  static final _defaultOptions = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
  );

  @override
  Future<void> delete() async {
    // テストでは何もしない
  }

  @override
  bool get isAutomaticDataCollectionEnabled => false;

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {
    // テストでは何もしない
  }

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {
    // テストでは何もしない
  }
}