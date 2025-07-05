import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final crashlyticsServiceProvider = Provider<CrashlyticsService>(
  (ref) => CrashlyticsService(),
);

/// Firebase Crashlytics サービス
/// 
/// このServiceは他のServiceとは異なり、意図的にAppExceptionをthrowしません。
/// 
/// 理由：
/// - Crashlyticsはエラー監視・レポートツールであり、自身がアプリをクラッシュさせては本末転倒
/// - "Fail Silently"の原則に従い、Crashlytics自体のエラーは静かに処理される
/// - ネットワークエラーや初期化失敗などがあっても、アプリの正常動作を最優先
/// 
/// エラー時の動作：
/// - デバッグモードではコンソールにログ出力
/// - 本番環境では何もせず処理を継続（エラーレポートは後でリトライされる）
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
    try {
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
    } catch (e) {
      // Crashlytics自体のエラーはログに記録して継続
      debugPrint('Failed to record error to Crashlytics: $e');
      // アプリの動作を妨げないため、例外は投げない
    }
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
