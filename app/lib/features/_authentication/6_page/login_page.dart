import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/types/types.dart';
import '../../../common/utils/snack_bar_handler.dart';
import 'package:common_widget/common_widget.dart';
import '../../../components/scaffold/gradient_scaffold.dart';
import '../4_view_model/login_view_model.dart';
import '../5_component/login_buttons.dart';

/// ログイン画面
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    // エラーメッセージの監視
    useEffect(() {
      if (loginState.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            // TODO: エラーメッセージをいい感じにする
            SnackBarHandler.showError(
              context,
              message: loginState.errorMessage!,
            );
          }
        });
      }
      return null;
    }, [loginState.errorMessage]);

    return GradientScaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // ロゴ
                const AppLogo(size: 200, color: Colors.white),
                const SizedBox(height: 8),
                // アプリ名
                Text(
                  'YattaDay',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // サブタイトル
                Text(
                  '毎日の記録を簡単に',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),

                // ボタン
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Stack(
                    children: [
                      Visibility(
                        visible: !loginState.isLoading,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        maintainInteractivity: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GoogleLoginButton(
                              isLoading: loginState.isLoading,
                              onPressed:
                                  () => loginViewModel.signIn(AuthType.google),
                            ),
                            const Gap(12),
                            AppleLoginButton(
                              isLoading: loginState.isLoading,
                              onPressed:
                                  () => loginViewModel.signIn(AuthType.apple),
                            ),
                            const Gap(16),
                            // 区切り線
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'または',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            // 匿名ログインボタン
                            AnonymousLoginButton(
                              isLoading: loginState.isLoading,
                              onPressed:
                                  () =>
                                      loginViewModel.signIn(AuthType.anonymous),
                            ),
                          ],
                        ),
                      ),
                      if (loginState.isLoading)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // 利用規約
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'ログインすることで、'),
                        TextSpan(
                          text: '利用規約',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: 'と'),
                        TextSpan(
                          text: 'プライバシーポリシー',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: 'に同意したものとみなされます'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
