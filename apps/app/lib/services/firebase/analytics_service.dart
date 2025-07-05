import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/exception/app_exception_helpers.dart';

final analyticsServiceProvider = Provider<AnalyticsService>(
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
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters?.map((key, value) => MapEntry(key, value ?? '')),
      );
    } catch (e) {
      throw AppExceptions.unknown('イベントログ送信に失敗しました', e);
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      throw AppExceptions.unknown('画面表示ログ送信に失敗しました', e);
    }
  }

  Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (e) {
      throw AppExceptions.unknown('ユーザーID設定に失敗しました', e);
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      throw AppExceptions.unknown('ユーザープロパティ設定に失敗しました', e);
    }
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      throw AppExceptions.unknown('アナリティクス収集設定に失敗しました', e);
    }
  }
}
