import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final analyticsServiceProvider = Provider.autoDispose<AnalyticsService>(
  (ref) => AnalyticsService(),
);

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters?.map((key, value) => MapEntry(key, value ?? '')),
    );
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
