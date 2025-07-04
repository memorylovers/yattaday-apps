import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/_authentication/1_models/auth_type.dart';
import 'package:myapp/features/_authentication/1_models/auth_user.dart';
import 'package:myapp/features/_authentication/2_repository/auth_repository.dart';
import 'package:myapp/features/_authentication/3_store/auth_store.dart';
import 'package:myapp/services/shared_preferences/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../test_helpers/fixtures/test_data_builders.dart';

/// AuthRepository用のフェイク実装
class FakeAuthRepository implements AuthRepository {
  final StreamController<AuthUser?> _authStateController = StreamController<AuthUser?>.broadcast();
  AuthUser? _currentUser;

  FakeAuthRepository() {
    // 初期値を設定
    _authStateController.add(null);
  }

  void setCurrentUser(AuthUser? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  @override
  Stream<AuthUser?> watchAuthState() => _authStateController.stream;

  @override
  Future<AuthUser?> signIn(AuthType type) async {
    final user = createTestAuthUser(
      uid: 'signed-in-user',
      email: 'test@example.com',
      authTypes: [type],
    );
    setCurrentUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    setCurrentUser(null);
  }

  @override
  Future<void> delete() async {
    setCurrentUser(null);
  }

  @override
  Future<void> linkAccount(AuthType type) async {
    if (_currentUser != null) {
      final updatedTypes = [..._currentUser!.authTypes, type];
      final updatedUser = _currentUser!.copyWith(authTypes: updatedTypes);
      setCurrentUser(updatedUser);
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }

  void dispose() {
    _authStateController.close();
  }
}

/// SharedPreferencesService用のフェイク実装
class FakeSharedPreferencesService extends SharedPreferencesService {
  bool _isFirstRun = false;

  FakeSharedPreferencesService() : super(FakeSharedPreferences());

  void setIsFirstRunForTest(bool value) {
    _isFirstRun = value;
  }

  @override
  bool get isFirstRun => _isFirstRun;

  @override
  Future<void> setIsFirstRun(bool value) async {
    _isFirstRun = value;
  }
}

/// SharedPreferences用のフェイク実装
class FakeSharedPreferences implements SharedPreferences {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  bool? getBool(String key) => _data[key] as bool?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _data[key] = value;
    return true;
  }

  @override
  Object? get(String key) => _data[key];

  @override
  Set<String> getKeys() => _data.keys.toSet();

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  double? getDouble(String key) => _data[key] as double?;

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  List<String>? getStringList(String key) => (_data[key] as List?)?.cast<String>();

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  bool containsKey(String key) => _data.containsKey(key);

  @override
  Future<void> reload() async {}

  @override
  Future<bool> commit() async => true;
}

void main() {
  group('AuthStore', () {
    late ProviderContainer container;
    late FakeAuthRepository fakeAuthRepository;
    late FakeSharedPreferencesService fakeSharedPreferencesService;

    setUp(() {
      fakeAuthRepository = FakeAuthRepository();
      fakeSharedPreferencesService = FakeSharedPreferencesService();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuthRepository),
          sharedPreferencesServiceProvider.overrideWithValue(fakeSharedPreferencesService),
        ],
      );
    });

    tearDown(() {
      fakeAuthRepository.dispose();
      container.dispose();
    });

    group('build', () {
      test('初期状態でRepositoryの認証状態を監視する', () async {
        final user = createTestAuthUser();
        fakeAuthRepository.setCurrentUser(user);

        // 少し待機してストリームが更新されるのを待つ
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = await container.read(authStoreProvider.future);

        expect(state?.user, equals(user));
        expect(state?.uid, equals(user.uid));
      });

      test('認証状態の変更がストリームに反映される', () async {
        // 初期状態：未認証
        fakeAuthRepository.setCurrentUser(null);
        expect(await container.read(authStoreProvider.future), isNull);

        // ユーザーを設定
        final user = createTestAuthUser();
        fakeAuthRepository.setCurrentUser(user);
        await Future.delayed(const Duration(milliseconds: 100));
        expect((await container.read(authStoreProvider.future))?.user, equals(user));

        // サインアウト
        fakeAuthRepository.setCurrentUser(null);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(await container.read(authStoreProvider.future), isNull);
      });
    });

    group('signIn', () {
      test('指定した認証タイプでサインインできる', () async {
        final notifier = container.read(authStoreProvider.notifier);

        await notifier.signIn(AuthType.google);

        final state = await container.read(authStoreProvider.future);
        expect(state?.user.authTypes, contains(AuthType.google));
      });

      test('異なる認証タイプでサインインできる', () async {
        final notifier = container.read(authStoreProvider.notifier);

        await notifier.signIn(AuthType.anonymous);

        final state = await container.read(authStoreProvider.future);
        expect(state?.user.authTypes, contains(AuthType.anonymous));
      });
    });

    group('signOut', () {
      test('サインアウトすると認証状態がnullになる', () async {
        // 事前にサインイン
        final notifier = container.read(authStoreProvider.notifier);
        await notifier.signIn(AuthType.google);

        // サインアウト
        await notifier.signOut();

        final state = await container.read(authStoreProvider.future);
        expect(state, isNull);
      });
    });

    group('delete', () {
      test('アカウント削除すると認証状態がnullになる', () async {
        // 事前にサインイン
        final notifier = container.read(authStoreProvider.notifier);
        await notifier.signIn(AuthType.google);

        // アカウント削除
        await notifier.delete();

        final state = await container.read(authStoreProvider.future);
        expect(state, isNull);
      });
    });

    group('linkAccount', () {
      test('既存アカウントに新しい認証タイプを連携できる', () async {
        // 匿名でサインイン
        final notifier = container.read(authStoreProvider.notifier);
        await notifier.signIn(AuthType.anonymous);

        // Googleアカウントを連携
        await notifier.linkAccount(AuthType.google);

        final state = await container.read(authStoreProvider.future);
        expect(state?.user.authTypes, containsAll([AuthType.anonymous, AuthType.google]));
      });
    });

    group('authSignOutWhenFirstRun', () {
      test('初回起動時は自動的にサインアウトされる', () async {
        // ユーザーがサインイン済みの状態
        fakeAuthRepository.setCurrentUser(createTestAuthUser());
        
        // 初回起動フラグをセット
        fakeSharedPreferencesService.setIsFirstRunForTest(true);

        // authSignOutWhenFirstRunを実行
        await container.read(authSignOutWhenFirstRunProvider.future);

        // サインアウトされていることを確認
        final state = await container.read(authStoreProvider.future);
        expect(state, isNull);
        
        // 初回起動フラグがfalseになっていることを確認
        expect(fakeSharedPreferencesService.isFirstRun, isFalse);
      });

      test('初回起動でない場合はサインアウトされない', () async {
        // ユーザーがサインイン済みの状態
        final user = createTestAuthUser();
        fakeAuthRepository.setCurrentUser(user);
        
        // 初回起動フラグをfalseに
        fakeSharedPreferencesService.setIsFirstRunForTest(false);

        // authSignOutWhenFirstRunを実行
        await container.read(authSignOutWhenFirstRunProvider.future);

        // サインアウトされていないことを確認
        final state = await container.read(authStoreProvider.future);
        expect(state?.user, equals(user));
      });
    });

    group('AuthState', () {
      test('uidプロパティがuser.uidを返す', () {
        final user = createTestAuthUser(uid: 'test-uid-123');
        final state = AuthState(user: user);

        expect(state.uid, equals('test-uid-123'));
      });
    });
  });
}