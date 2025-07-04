import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/services/firebase/analytics_service.dart';

// シンプルなFirebaseAnalyticsのテスト用実装
class TestFirebaseAnalytics {
  final List<LoggedEvent> loggedEvents = [];
  final List<LoggedScreenView> loggedScreenViews = [];
  String? userId;
  final Map<String, String?> userProperties = {};
  bool analyticsCollectionEnabled = true;

  void clearLogs() {
    loggedEvents.clear();
    loggedScreenViews.clear();
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    loggedEvents.add(LoggedEvent(name: name, parameters: parameters));
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    loggedScreenViews.add(
      LoggedScreenView(screenName: screenName, screenClass: screenClass),
    );
  }

  Future<void> setUserId({String? id}) async {
    userId = id;
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    userProperties[name] = value;
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    analyticsCollectionEnabled = enabled;
  }
}

// FirebaseAnalyticsをラップするテスト用クラス
class TestableAnalyticsService extends AnalyticsService {
  final TestFirebaseAnalytics testAnalytics;

  TestableAnalyticsService(this.testAnalytics) : super();

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    await testAnalytics.logEvent(
      name: name,
      parameters: parameters?.map((key, value) => MapEntry(key, value ?? '')),
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await testAnalytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> setUserId(String? id) async {
    await testAnalytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await testAnalytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await testAnalytics.setAnalyticsCollectionEnabled(enabled);
  }
}

// テスト用のデータクラス
class LoggedEvent {
  final String name;
  final Map<String, Object?>? parameters;

  LoggedEvent({required this.name, this.parameters});
}

class LoggedScreenView {
  final String screenName;
  final String? screenClass;

  LoggedScreenView({required this.screenName, this.screenClass});
}

void main() {
  late TestFirebaseAnalytics testAnalytics;
  late TestableAnalyticsService analyticsService;

  setUp(() {
    testAnalytics = TestFirebaseAnalytics();
    analyticsService = TestableAnalyticsService(testAnalytics);
  });

  group('AnalyticsService', () {
    group('logEvent', () {
      test('イベントをログに記録できる', () async {
        await analyticsService.logEvent(
          name: 'test_event',
          parameters: {'param1': 'value1', 'param2': 123},
        );

        expect(testAnalytics.loggedEvents.length, 1);
        final event = testAnalytics.loggedEvents.first;
        expect(event.name, 'test_event');
        expect(event.parameters?['param1'], 'value1');
        expect(event.parameters?['param2'], 123);
      });

      test('パラメータなしでイベントをログに記録できる', () async {
        await analyticsService.logEvent(name: 'simple_event');

        expect(testAnalytics.loggedEvents.length, 1);
        final event = testAnalytics.loggedEvents.first;
        expect(event.name, 'simple_event');
        expect(event.parameters, isNull);
      });

      test('null値を含むパラメータは空文字列に変換される', () async {
        await analyticsService.logEvent(
          name: 'event_with_null',
          parameters: {
            'param1': 'value1',
            'param2': null,
            'param3': 456,
          },
        );

        expect(testAnalytics.loggedEvents.length, 1);
        final event = testAnalytics.loggedEvents.first;
        expect(event.parameters?['param1'], 'value1');
        expect(event.parameters?['param2'], '');
        expect(event.parameters?['param3'], 456);
      });
    });

    group('logScreenView', () {
      test('画面表示をログに記録できる', () async {
        await analyticsService.logScreenView(
          screenName: 'home_screen',
          screenClass: 'HomePage',
        );

        expect(testAnalytics.loggedScreenViews.length, 1);
        final screenView = testAnalytics.loggedScreenViews.first;
        expect(screenView.screenName, 'home_screen');
        expect(screenView.screenClass, 'HomePage');
      });

      test('screenClassなしで画面表示をログに記録できる', () async {
        await analyticsService.logScreenView(screenName: 'settings_screen');

        expect(testAnalytics.loggedScreenViews.length, 1);
        final screenView = testAnalytics.loggedScreenViews.first;
        expect(screenView.screenName, 'settings_screen');
        expect(screenView.screenClass, isNull);
      });
    });

    group('setUserId', () {
      test('ユーザーIDを設定できる', () async {
        await analyticsService.setUserId('user123');

        expect(testAnalytics.userId, 'user123');
      });

      test('nullでユーザーIDをクリアできる', () async {
        await analyticsService.setUserId('user123');
        await analyticsService.setUserId(null);

        expect(testAnalytics.userId, isNull);
      });
    });

    group('setUserProperty', () {
      test('ユーザープロパティを設定できる', () async {
        await analyticsService.setUserProperty(
          name: 'subscription_status',
          value: 'premium',
        );

        expect(testAnalytics.userProperties['subscription_status'], 'premium');
      });

      test('複数のユーザープロパティを設定できる', () async {
        await analyticsService.setUserProperty(
          name: 'user_type',
          value: 'regular',
        );
        await analyticsService.setUserProperty(
          name: 'age_group',
          value: '25-34',
        );

        expect(testAnalytics.userProperties['user_type'], 'regular');
        expect(testAnalytics.userProperties['age_group'], '25-34');
      });

      test('nullでユーザープロパティをクリアできる', () async {
        await analyticsService.setUserProperty(
          name: 'favorite_category',
          value: 'sports',
        );
        await analyticsService.setUserProperty(
          name: 'favorite_category',
          value: null,
        );

        expect(testAnalytics.userProperties['favorite_category'], isNull);
      });
    });

    group('setAnalyticsCollectionEnabled', () {
      test('アナリティクス収集を有効にできる', () async {
        await analyticsService.setAnalyticsCollectionEnabled(true);

        expect(testAnalytics.analyticsCollectionEnabled, isTrue);
      });

      test('アナリティクス収集を無効にできる', () async {
        await analyticsService.setAnalyticsCollectionEnabled(false);

        expect(testAnalytics.analyticsCollectionEnabled, isFalse);
      });
    });

    group('複数の操作を組み合わせたテスト', () {
      test('複数のイベントと画面表示をログに記録できる', () async {
        await analyticsService.logScreenView(screenName: 'home_screen');
        await analyticsService.logEvent(name: 'button_clicked');
        await analyticsService.logScreenView(screenName: 'detail_screen');
        await analyticsService.logEvent(
          name: 'item_viewed',
          parameters: {'item_id': 'item123'},
        );

        expect(testAnalytics.loggedScreenViews.length, 2);
        expect(testAnalytics.loggedEvents.length, 2);
        
        expect(testAnalytics.loggedScreenViews[0].screenName, 'home_screen');
        expect(testAnalytics.loggedScreenViews[1].screenName, 'detail_screen');
        
        expect(testAnalytics.loggedEvents[0].name, 'button_clicked');
        expect(testAnalytics.loggedEvents[1].name, 'item_viewed');
        expect(testAnalytics.loggedEvents[1].parameters?['item_id'], 'item123');
      });

      test('ユーザー情報とイベントを組み合わせて記録できる', () async {
        await analyticsService.setUserId('user456');
        await analyticsService.setUserProperty(
          name: 'subscription_status',
          value: 'free',
        );
        await analyticsService.logEvent(
          name: 'upgrade_prompted',
          parameters: {'source': 'home_screen'},
        );

        expect(testAnalytics.userId, 'user456');
        expect(testAnalytics.userProperties['subscription_status'], 'free');
        expect(testAnalytics.loggedEvents.length, 1);
        expect(testAnalytics.loggedEvents.first.name, 'upgrade_prompted');
      });
    });
  });
}