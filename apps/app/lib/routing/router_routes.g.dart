// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $startupPageRoute,
  $loginPageRoute,
  $homePageRoute,
];

RouteBase get $startupPageRoute => GoRouteData.$route(
  path: '/',

  factory: $StartupPageRouteExtension._fromState,
);

extension $StartupPageRouteExtension on StartupPageRoute {
  static StartupPageRoute _fromState(GoRouterState state) =>
      const StartupPageRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginPageRoute => GoRouteData.$route(
  path: '/login',

  factory: $LoginPageRouteExtension._fromState,
);

extension $LoginPageRouteExtension on LoginPageRoute {
  static LoginPageRoute _fromState(GoRouterState state) =>
      const LoginPageRoute();

  String get location => GoRouteData.$location('/login');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homePageRoute => StatefulShellRouteData.$route(
  parentNavigatorKey: HomePageRoute.$parentNavigatorKey,
  restorationScopeId: HomePageRoute.$restorationScopeId,
  factory: $HomePageRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: RecordItemsListPageBranch.$navigatorKey,
      restorationScopeId: RecordItemsListPageBranch.$restorationScopeId,

      routes: [
        GoRouteData.$route(
          path: '/record-items',

          factory: $RecordItemsListPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',

              factory: $RecordItemsDetailPageRouteExtension._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: SettingsPageBranch.$navigatorKey,
      restorationScopeId: SettingsPageBranch.$restorationScopeId,

      routes: [
        GoRouteData.$route(
          path: '/settings',

          factory: $SettingsPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'payment',

              factory: $PaymentPageRouteExtension._fromState,
            ),
          ],
        ),
      ],
    ),
  ],
);

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();
}

extension $RecordItemsListPageRouteExtension on RecordItemsListPageRoute {
  static RecordItemsListPageRoute _fromState(GoRouterState state) =>
      const RecordItemsListPageRoute();

  String get location => GoRouteData.$location('/record-items');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RecordItemsDetailPageRouteExtension on RecordItemsDetailPageRoute {
  static RecordItemsDetailPageRoute _fromState(GoRouterState state) =>
      RecordItemsDetailPageRoute(id: state.pathParameters['id']!);

  String get location =>
      GoRouteData.$location('/record-items/${Uri.encodeComponent(id)}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsPageRouteExtension on SettingsPageRoute {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      const SettingsPageRoute();

  String get location => GoRouteData.$location('/settings');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PaymentPageRouteExtension on PaymentPageRoute {
  static PaymentPageRoute _fromState(GoRouterState state) =>
      const PaymentPageRoute();

  String get location => GoRouteData.$location('/settings/payment');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
