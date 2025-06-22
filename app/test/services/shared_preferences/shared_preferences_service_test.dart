import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/common/utils/system_providers.dart';
import 'package:myapp/services/shared_preferences/shared_preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('SharedPreferencesService', () {
    late SharedPreferences prefs;
    late SharedPreferencesService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = SharedPreferencesService(prefs);
    });

    group('isFirstRun', () {
      test('初期値はtrue', () {
        expect(service.isFirstRun, isTrue);
      });

      test('値を設定できる', () async {
        await service.setIsFirstRun(false);
        expect(service.isFirstRun, isFalse);
        
        await service.setIsFirstRun(true);
        expect(service.isFirstRun, isTrue);
      });
    });


    group('clear', () {
      test('すべてのデータをクリアする', () async {
        // データを設定
        await service.setIsFirstRun(false);
        
        // データが設定されていることを確認
        expect(service.isFirstRun, isFalse);
        
        // クリア
        await service.clear();
        
        // デフォルト値に戻る
        expect(service.isFirstRun, isTrue);
      });
    });

    group('Provider', () {
      test('Providerから取得できる', () {
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
        );
        
        final service = container.read(sharedPreferencesServiceProvider);
        expect(service, isA<SharedPreferencesService>());
      });
    });
  });
}