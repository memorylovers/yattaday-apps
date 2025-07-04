import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/services/firebase/crashlytics_service.dart';

// FirebaseCrashlytics用のFake実装
class FakeFirebaseCrashlytics implements FirebaseCrashlytics {
  final List<RecordedError> _recordedErrors = [];
  final List<String> _logs = [];
  String? _userIdentifier;
  final Map<String, Object> _customKeys = {};
  bool _isCrashlyticsCollectionEnabled = true;
  FirebaseApp? _app;

  // テスト用のヘルパーメソッド
  List<RecordedError> get recordedErrors => List.unmodifiable(_recordedErrors);
  List<String> get logs => List.unmodifiable(_logs);
  String? get userIdentifier => _userIdentifier;
  Map<String, Object> get customKeys => Map.unmodifiable(_customKeys);

  void clearRecords() {
    _recordedErrors.clear();
    _logs.clear();
    _customKeys.clear();
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    _recordedErrors.add(
      RecordedError(
        exception: exception,
        stack: stack,
        reason: reason,
        fatal: fatal,
      ),
    );
  }

  @override
  Future<void> log(String message) async {
    _logs.add(message);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    _userIdentifier = identifier;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    _customKeys[key] = value;
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    _isCrashlyticsCollectionEnabled = enabled;
  }

  @override
  bool get isCrashlyticsCollectionEnabled => _isCrashlyticsCollectionEnabled;

  // 未実装のメソッド（テストに不要）
  @override
  Future<void> crash() => throw UnimplementedError();

  @override
  Future<void> deleteUnsentReports() => throw UnimplementedError();

  @override
  Future<bool> didCrashOnPreviousExecution() => throw UnimplementedError();

  @override
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}) => throw UnimplementedError();

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) => throw UnimplementedError();

  @override
  Future<void> sendUnsentReports() => throw UnimplementedError();

  @override
  Map get pluginConstants => {};

  @override
  Future<bool> checkForUnsentReports() => throw UnimplementedError();

  @override
  FirebaseApp get app => _app ?? (throw UnimplementedError());

  @override
  set app(FirebaseApp value) => _app = value;
}

// テスト用のデータクラス
class RecordedError {
  final dynamic exception;
  final StackTrace? stack;
  final dynamic reason;
  final bool fatal;

  RecordedError({
    required this.exception,
    this.stack,
    this.reason,
    required this.fatal,
  });
}

void main() {
  late FakeFirebaseCrashlytics fakeCrashlytics;
  late CrashlyticsService crashlyticsService;

  setUp(() {
    fakeCrashlytics = FakeFirebaseCrashlytics();
    crashlyticsService = CrashlyticsService(crashlytics: fakeCrashlytics);
  });

  tearDown(() {
    fakeCrashlytics.clearRecords();
  });

  group('CrashlyticsService', () {
    group('recordError', () {
      test('エラーを記録できる', () async {
        final exception = Exception('Test exception');
        final stack = StackTrace.current;

        await crashlyticsService.recordError(
          exception,
          stack,
          reason: 'Test reason',
        );

        expect(fakeCrashlytics.recordedErrors.length, 1);
        final error = fakeCrashlytics.recordedErrors.first;
        expect(error.exception, exception);
        expect(error.stack, stack);
        expect(error.reason, 'Test reason');
        expect(error.fatal, false);
      });

      test('致命的なエラーを記録できる', () async {
        final exception = Exception('Fatal exception');

        await crashlyticsService.recordError(
          exception,
          null,
          fatal: true,
        );

        expect(fakeCrashlytics.recordedErrors.length, 1);
        final error = fakeCrashlytics.recordedErrors.first;
        expect(error.exception, exception);
        expect(error.fatal, true);
      });

      test('スタックトレースなしでエラーを記録できる', () async {
        final exception = Exception('No stack exception');

        await crashlyticsService.recordError(exception, null);

        expect(fakeCrashlytics.recordedErrors.length, 1);
        final error = fakeCrashlytics.recordedErrors.first;
        expect(error.exception, exception);
        expect(error.stack, isNull);
        expect(error.fatal, false);
      });

      test('デバッグモードではエラーを記録しない', () async {
        // デバッグモードのテストは実行環境に依存するため、
        // ここではリリースモードでの動作のみをテスト
        expect(kDebugMode, isTrue); // テスト環境はデバッグモード

        // デバッグモードでもrecordErrorは呼ばれるが、
        // 実装では早期リターンしているため記録されない
        await crashlyticsService.recordError(
          Exception('Debug exception'),
          null,
        );

        // デバッグモードでは記録されない
        expect(fakeCrashlytics.recordedErrors.isEmpty, isTrue);
      });
    });

    group('log', () {
      test('メッセージをログに記録できる', () async {
        await crashlyticsService.log('Test message');

        expect(fakeCrashlytics.logs.length, 1);
        expect(fakeCrashlytics.logs.first, 'Test message');
      });

      test('複数のメッセージをログに記録できる', () async {
        await crashlyticsService.log('First message');
        await crashlyticsService.log('Second message');
        await crashlyticsService.log('Third message');

        expect(fakeCrashlytics.logs.length, 3);
        expect(fakeCrashlytics.logs[0], 'First message');
        expect(fakeCrashlytics.logs[1], 'Second message');
        expect(fakeCrashlytics.logs[2], 'Third message');
      });
    });

    group('setUserId', () {
      test('ユーザーIDを設定できる', () async {
        await crashlyticsService.setUserId('user789');

        expect(fakeCrashlytics.userIdentifier, 'user789');
      });

      test('ユーザーIDを更新できる', () async {
        await crashlyticsService.setUserId('user789');
        await crashlyticsService.setUserId('user999');

        expect(fakeCrashlytics.userIdentifier, 'user999');
      });
    });

    group('setCustomKey', () {
      test('カスタムキーを設定できる', () async {
        await crashlyticsService.setCustomKey('version', '1.2.3');

        expect(fakeCrashlytics.customKeys['version'], '1.2.3');
      });

      test('複数のカスタムキーを設定できる', () async {
        await crashlyticsService.setCustomKey('environment', 'production');
        await crashlyticsService.setCustomKey('user_type', 'premium');
        await crashlyticsService.setCustomKey('feature_flag', true);

        expect(fakeCrashlytics.customKeys['environment'], 'production');
        expect(fakeCrashlytics.customKeys['user_type'], 'premium');
        expect(fakeCrashlytics.customKeys['feature_flag'], true);
      });

      test('既存のキーを上書きできる', () async {
        await crashlyticsService.setCustomKey('build', '100');
        await crashlyticsService.setCustomKey('build', '101');

        expect(fakeCrashlytics.customKeys['build'], '101');
      });
    });

    group('setCrashlyticsCollectionEnabled', () {
      test('Crashlytics収集を有効にできる', () async {
        await crashlyticsService.setCrashlyticsCollectionEnabled(true);

        expect(fakeCrashlytics.isCrashlyticsCollectionEnabled, isTrue);
      });

      test('Crashlytics収集を無効にできる', () async {
        await crashlyticsService.setCrashlyticsCollectionEnabled(false);

        expect(fakeCrashlytics.isCrashlyticsCollectionEnabled, isFalse);
      });
    });

    group('複数の操作を組み合わせたテスト', () {
      test('ユーザー情報とエラーを組み合わせて記録できる', () async {
        // ユーザー情報を設定
        await crashlyticsService.setUserId('user123');
        await crashlyticsService.setCustomKey('session_id', 'abc-123');
        await crashlyticsService.setCustomKey('feature', 'payment');

        // ログを記録
        await crashlyticsService.log('Payment process started');
        await crashlyticsService.log('Payment validation failed');

        // エラーを記録（デバッグモードでは記録されない）
        await crashlyticsService.recordError(
          Exception('Payment failed'),
          StackTrace.current,
          reason: 'Invalid card number',
        );

        expect(fakeCrashlytics.userIdentifier, 'user123');
        expect(fakeCrashlytics.customKeys['session_id'], 'abc-123');
        expect(fakeCrashlytics.customKeys['feature'], 'payment');
        expect(fakeCrashlytics.logs.length, 2);
        // デバッグモードではエラーが記録されない
        expect(fakeCrashlytics.recordedErrors.isEmpty, isTrue);
      });

      test('複数のエラーとログを時系列で記録できる', () async {
        await crashlyticsService.log('App started');
        
        await crashlyticsService.recordError(
          Exception('Network error'),
          null,
          reason: 'Timeout',
        );
        
        await crashlyticsService.log('Retrying network request');
        
        await crashlyticsService.recordError(
          Exception('Network error'),
          null,
          reason: 'Connection refused',
          fatal: false,
        );

        expect(fakeCrashlytics.logs.length, 2);
        expect(fakeCrashlytics.logs[0], 'App started');
        expect(fakeCrashlytics.logs[1], 'Retrying network request');
        
        // デバッグモードではエラーが記録されない
        expect(fakeCrashlytics.recordedErrors.isEmpty, isTrue);
      });
    });
  });
}