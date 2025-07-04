import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/features/_app_rate/1_models/app_rate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late AppRate appRate;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    appRate = AppRate(
      pref: prefs,
      installDate: 3,    // 3日
      launchTimes: 5,    // 5回
      remindInterval: 2, // 2日
      isDebug: false,
    );
  });

  group('AppRate', () {
    test('初期状態では初回起動として扱われる', () async {
      expect(prefs.getInt(prefKeyInstallDate), isNull);
      expect(prefs.getInt(prefKeyLaunchTimes), isNull);
      expect(prefs.getBool(prefKeyIsAgreeShowDialog), isNull);
    });

    group('monitor', () {
      test('初回起動時はインストール日時を保存し、起動回数を1にする', () async {
        final beforeTime = DateTime.now().millisecondsSinceEpoch;
        
        await appRate.monitor();
        
        final installDate = prefs.getInt(prefKeyInstallDate);
        expect(installDate, isNotNull);
        expect(installDate! >= beforeTime, isTrue);
        expect(prefs.getInt(prefKeyLaunchTimes), 1);
      });

      test('2回目以降の起動時は起動回数をインクリメントする', () async {
        // 初回起動
        await appRate.monitor();
        expect(prefs.getInt(prefKeyLaunchTimes), 1);

        // 2回目の起動
        await appRate.monitor();
        expect(prefs.getInt(prefKeyLaunchTimes), 2);

        // 3回目の起動
        await appRate.monitor();
        expect(prefs.getInt(prefKeyLaunchTimes), 3);
      });
    });

    group('shouldShowRateDialog', () {
      test('すべての条件を満たさない場合はfalseを返す', () {
        expect(appRate.shouldShowRateDialog(), false);
      });

      test('起動回数の条件のみ満たす場合はfalseを返す', () async {
        // 起動回数を5回に設定
        for (int i = 0; i < 5; i++) {
          await appRate.monitor();
        }
        
        expect(appRate.isOverLaunchTimes(), true);
        expect(appRate.isOverInstallDate(), false);
        expect(appRate.shouldShowRateDialog(), false);
      });

      test('すべての条件を満たす場合はtrueを返す', () async {
        // インストール日時を3日以上前に設定
        final oldDate = DateTime.now().subtract(const Duration(days: 4));
        await prefs.setInt(prefKeyInstallDate, oldDate.millisecondsSinceEpoch);
        
        // 起動回数を5回に設定
        await prefs.setInt(prefKeyLaunchTimes, 5);
        
        expect(appRate.isOverLaunchTimes(), true);
        expect(appRate.isOverInstallDate(), true);
        expect(appRate.isOverRemindDate(), true);
        expect(appRate.shouldShowRateDialog(), true);
      });

      test('表示拒否設定がある場合はfalseを返す', () async {
        // すべての条件を満たす状態を作る
        final oldDate = DateTime.now().subtract(const Duration(days: 4));
        await prefs.setInt(prefKeyInstallDate, oldDate.millisecondsSinceEpoch);
        await prefs.setInt(prefKeyLaunchTimes, 5);
        
        // 表示拒否設定
        await prefs.setBool(prefKeyIsAgreeShowDialog, false);
        
        expect(appRate.shouldShowRateDialog(), false);
      });
    });

    group('selectOk', () {
      test('レビューするを選択した場合は表示拒否フラグを設定する', () async {
        await appRate.selectOk();
        
        expect(prefs.getBool(prefKeyIsAgreeShowDialog), false);
      });
    });

    group('selectLater', () {
      test('あとでを選択した場合はリマインド日時を設定する', () async {
        final beforeTime = DateTime.now().millisecondsSinceEpoch;
        
        await appRate.selectLater();
        
        final remindTime = prefs.getInt(prefKeyRemindInterval);
        expect(remindTime, isNotNull);
        expect(remindTime! >= beforeTime, isTrue);
      });

      test('リマインド期間経過後は再度表示される', () async {
        // すべての条件を満たす状態を作る
        final oldDate = DateTime.now().subtract(const Duration(days: 4));
        await prefs.setInt(prefKeyInstallDate, oldDate.millisecondsSinceEpoch);
        await prefs.setInt(prefKeyLaunchTimes, 5);
        
        // あとでを選択（現在時刻を保存）
        await appRate.selectLater();
        expect(appRate.shouldShowRateDialog(), false);
        
        // リマインド期間経過前（1日後）
        final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
        await prefs.setInt(prefKeyRemindInterval, oneDayAgo.millisecondsSinceEpoch);
        expect(appRate.isOverRemindDate(), false);
        expect(appRate.shouldShowRateDialog(), false);
        
        // リマインド期間経過後（3日後）
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
        await prefs.setInt(prefKeyRemindInterval, threeDaysAgo.millisecondsSinceEpoch);
        expect(appRate.isOverRemindDate(), true);
        expect(appRate.shouldShowRateDialog(), true);
      });
    });

    group('selectNever', () {
      test('しないを選択した場合は表示拒否フラグを設定する', () async {
        await appRate.selectNever();
        
        expect(prefs.getBool(prefKeyIsAgreeShowDialog), false);
      });
    });

    group('isOverLaunchTimes', () {
      test('起動回数が閾値未満の場合はfalseを返す', () async {
        await prefs.setInt(prefKeyLaunchTimes, 4);
        expect(appRate.isOverLaunchTimes(), false);
      });

      test('起動回数が閾値以上の場合はtrueを返す', () async {
        await prefs.setInt(prefKeyLaunchTimes, 5);
        expect(appRate.isOverLaunchTimes(), true);

        await prefs.setInt(prefKeyLaunchTimes, 10);
        expect(appRate.isOverLaunchTimes(), true);
      });
    });

    group('isOverInstallDate', () {
      test('インストールから日数が経過していない場合はfalseを返す', () async {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        await prefs.setInt(prefKeyInstallDate, twoDaysAgo.millisecondsSinceEpoch);
        
        expect(appRate.isOverInstallDate(), false);
      });

      test('インストールから指定日数が経過した場合はtrueを返す', () async {
        final fourDaysAgo = DateTime.now().subtract(const Duration(days: 4));
        await prefs.setInt(prefKeyInstallDate, fourDaysAgo.millisecondsSinceEpoch);
        
        expect(appRate.isOverInstallDate(), true);
      });
    });

    group('カスタム設定', () {
      test('カスタム設定で動作する', () async {
        final customAppRate = AppRate(
          pref: prefs,
          installDate: 1,     // 1日
          launchTimes: 3,     // 3回
          remindInterval: 1,  // 1日
          isDebug: false,
        );

        // 条件を満たす状態を作る
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        await prefs.setInt(prefKeyInstallDate, twoDaysAgo.millisecondsSinceEpoch);
        await prefs.setInt(prefKeyLaunchTimes, 3);

        expect(customAppRate.isOverInstallDate(), true);
        expect(customAppRate.isOverLaunchTimes(), true);
        expect(customAppRate.shouldShowRateDialog(), true);
      });
    });
  });
}