import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/hooks/use_error_message.dart';
import '../../../common/types/types.dart';
import '../../../components/loading_overlay.dart';
import '../../../components/or_divider.dart';
import '../../../components/scaffold/gradient_scaffold.dart';
import '../4_view_model/login_view_model.dart';
import '../5_component/app_branding_section.dart';
import '../5_component/login_buttons.dart';
import '../5_component/terms_of_service_text.dart';

/// ログイン画面
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    // エラーメッセージの監視
    useErrorMessage(loginState.errorMessage, context);

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
                // アプリブランディングセクション
                const AppBrandingSection(),
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
                            const OrDivider(),
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
                      if (loginState.isLoading) const LoadingOverlay(),
                    ],
                  ),
                ),
                // 利用規約
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: const TermsOfServiceText(),
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
