import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final crashlyticsServiceProvider = Provider<CrashlyticsService>(
  (ref) => CrashlyticsService(),
);

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService({FirebaseCrashlytics? crashlytics})
    : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      // In debug mode, print to console instead
      debugPrint('Crashlytics Error: $exception');
      if (stack != null) {
        debugPrint('Stack trace: $stack');
      }
      return;
    }

    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  Future<void> setUserId(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}
