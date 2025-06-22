import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/logger/logger.dart';
import '../../common/utils/system_providers.dart';

/// SharedPreferencesServiceのプロバイダ
///
/// sharedPreferencesProviderの初期化完了後に利用可能
final sharedPreferencesServiceProvider = Provider((ref) {
  final pref = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesService(pref);
});

/// SharedPreferencesのキー定数
class StorageKeys {
  StorageKeys._();

  static const String isFirstRun = 'isFirstRun';
}

/// SharedPreferencesサービス
///
/// アプリケーション固有のストレージアクセスを提供します。
/// 型安全なgetter/setterでデータの読み書きを行います。
class SharedPreferencesService {
  final SharedPreferences pref;

  const SharedPreferencesService(this.pref);

  // 初回起動フラグ
  bool get isFirstRun => pref.getBool(StorageKeys.isFirstRun) ?? true;
  Future<void> setIsFirstRun(bool value) async {
    await pref.setBool(StorageKeys.isFirstRun, value);
    logger.debug('SharedPreferences: set isFirstRun=$value');
  }

  // 全データクリア
  Future<void> clear() async {
    await pref.clear();
    logger.info('SharedPreferences: cleared all data');
  }
}
