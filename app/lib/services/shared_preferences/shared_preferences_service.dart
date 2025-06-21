import 'package:shared_preferences/shared_preferences.dart';

import '../../common/exception/app_error_code.dart';
import '../../common/exception/app_exception.dart';
import '../../common/logger/logger.dart';

/// SharedPreferencesサービス
/// 
/// SharedPreferencesの機能をラップし、アプリのローカルデータ保存を提供します。
/// エラーハンドリングとロギング機能を含みます。
class SharedPreferencesService {
  SharedPreferences? _preferences;

  /// SharedPreferencesのインスタンスを取得します
  Future<SharedPreferences> get _prefs async {
    try {
      _preferences ??= await SharedPreferences.getInstance();
      return _preferences!;
    } catch (error) {
      logger.error('Failed to get SharedPreferences instance', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 文字列を保存します
  Future<void> setString(String key, String value) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.setString(key, value);
      if (!success) {
        throw Exception('Failed to set string value');
      }
      logger.debug('SharedPreferences: setString key=$key');
    } catch (error) {
      logger.error('Failed to set string value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 文字列を取得します
  Future<String?> getString(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getString(key);
    } catch (error) {
      logger.error('Failed to get string value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 整数を保存します
  Future<void> setInt(String key, int value) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.setInt(key, value);
      if (!success) {
        throw Exception('Failed to set int value');
      }
      logger.debug('SharedPreferences: setInt key=$key, value=$value');
    } catch (error) {
      logger.error('Failed to set int value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 整数を取得します
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(key);
    } catch (error) {
      logger.error('Failed to get int value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 真偽値を保存します
  Future<void> setBool(String key, bool value) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.setBool(key, value);
      if (!success) {
        throw Exception('Failed to set bool value');
      }
      logger.debug('SharedPreferences: setBool key=$key, value=$value');
    } catch (error) {
      logger.error('Failed to set bool value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 真偽値を取得します
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(key);
    } catch (error) {
      logger.error('Failed to get bool value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 小数を保存します
  Future<void> setDouble(String key, double value) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.setDouble(key, value);
      if (!success) {
        throw Exception('Failed to set double value');
      }
      logger.debug('SharedPreferences: setDouble key=$key, value=$value');
    } catch (error) {
      logger.error('Failed to set double value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 小数を取得します
  Future<double?> getDouble(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getDouble(key);
    } catch (error) {
      logger.error('Failed to get double value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 文字列リストを保存します
  Future<void> setStringList(String key, List<String> value) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.setStringList(key, value);
      if (!success) {
        throw Exception('Failed to set string list');
      }
      logger.debug('SharedPreferences: setStringList key=$key, count=${value.length}');
    } catch (error) {
      logger.error('Failed to set string list', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 文字列リストを取得します
  Future<List<String>?> getStringList(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getStringList(key);
    } catch (error) {
      logger.error('Failed to get string list', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 指定されたキーのデータを削除します
  Future<bool> remove(String key) async {
    try {
      final prefs = await _prefs;
      final success = await prefs.remove(key);
      logger.debug('SharedPreferences: remove key=$key, success=$success');
      return success;
    } catch (error) {
      logger.error('Failed to remove value', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// すべてのデータを削除します
  Future<bool> clear() async {
    try {
      final prefs = await _prefs;
      final success = await prefs.clear();
      logger.info('SharedPreferences: cleared all data');
      return success;
    } catch (error) {
      logger.error('Failed to clear storage', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// 指定されたキーが存在するか確認します
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.containsKey(key);
    } catch (error) {
      logger.error('Failed to check key existence', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// すべてのキーを取得します
  Future<Set<String>> getKeys() async {
    try {
      final prefs = await _prefs;
      return prefs.getKeys();
    } catch (error) {
      logger.error('Failed to get all keys', error);
      throw AppException(
        code: AppErrorCode.storageError,
        cause: error,
      );
    }
  }

  /// シングルトンインスタンスをクリアします（テスト用）
  void resetInstance() {
    _preferences = null;
  }
}
