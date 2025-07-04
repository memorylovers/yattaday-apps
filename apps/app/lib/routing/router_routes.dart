import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/_authentication/7_page/login_page.dart';
import '../features/_payment/7_page/payment_page.dart';
import '../features/_startup/7_page/startup_page.dart';
import '../features/account/7_page/settings_page.dart';
import '../features/home/7_page/home_page.dart';
import '../features/record_items/7_page/record_item_list_page.dart';
import '../features/record_items/7_page/record_item_detail_page.dart';
import 'router_provider.dart';

part 'router_routes.g.dart';

/// 初期表示の画面
final initialPath = StartupPageRoute.path;

/// 未ログインの画面(ログイン画面)
final loginPath = LoginPageRoute.path;

/// ログイン済みの画面
final homePath = RecordItemsListPageRoute.path;

/// /startup: Startup
@TypedGoRoute<StartupPageRoute>(path: StartupPageRoute.path)
class StartupPageRoute extends GoRouteData {
  const StartupPageRoute();

  static const path = "/";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(child: StartupPage(), name: path);
  }
}

/// /login: ログイン画面
@TypedGoRoute<LoginPageRoute>(path: LoginPageRoute.path)
class LoginPageRoute extends GoRouteData {
  const LoginPageRoute();

  static const path = "/login";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(child: LoginPage(), name: path);
  }
}

/// ホーム画面のレイアウト
@TypedStatefulShellRoute<HomePageRoute>(
  branches: [
    TypedStatefulShellBranch<RecordItemsListPageBranch>(
      routes: [
        TypedGoRoute<RecordItemsListPageRoute>(
          path: RecordItemsListPageRoute.path,
          routes: [
            TypedGoRoute<RecordItemsDetailPageRoute>(
              path: RecordItemsDetailPageRoute.path,
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsPageBranch>(
      routes: [
        TypedGoRoute<SettingsPageRoute>(
          path: SettingsPageRoute.path,
          routes: [TypedGoRoute<PaymentPageRoute>(path: PaymentPageRoute.path)],
        ),
      ],
    ),
  ],
)
class HomePageRoute extends StatefulShellRouteData {
  const HomePageRoute();

  static GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
  static const String $restorationScopeId = 'restorationScopeId';

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return HomePage(navigationShell: navigationShell);
  }
}

/// /record-items: 記録項目一覧画面
class RecordItemsListPageRoute extends GoRouteData {
  const RecordItemsListPageRoute();

  static const path = '/record-items';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // RecordItemsListPageWithAuth を作成して認証済みユーザーIDを渡す
    return const RecordItemsListPage();
  }
}

class RecordItemsListPageBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = recordItemsTabKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

/// /record-items/:id: 記録項目詳細画面
class RecordItemsDetailPageRoute extends GoRouteData {
  const RecordItemsDetailPageRoute({required this.id});

  static const path = ':id';

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RecordItemsDetailPage(recordItemId: id);
  }
}

/// /settings: 設定画面
class SettingsPageRoute extends GoRouteData {
  const SettingsPageRoute();

  static const path = '/settings';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(child: SettingsPage(), name: path);
  }
}

class SettingsPageBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = settingTabKey;
  static const String $restorationScopeId = 'restorationScopeId';
}

/// /settings/payment: 課金画面
class PaymentPageRoute extends GoRouteData {
  const PaymentPageRoute();

  static const path = 'payment';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(child: PaymentPage(), name: path);
  }
}
