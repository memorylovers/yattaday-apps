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

    // ユーザイベントハンドラ
    void onPressSignInGoogle() {
      loginViewModel.signIn(AuthType.google);
    }

    void onPressSignInApple() {
      loginViewModel.signIn(AuthType.apple);
    }

    void onPressSignInAnonymous() {
      loginViewModel.signIn(AuthType.anonymous);
    }

    return GradientScaffold(
      body: Column(
        children: [
          // アプリブランディングセクション（50%）
          const Expanded(child: Center(child: AppBrandingSection())),

          // ボタンと利用規約セクション（50%）
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(20),
                          // ボタン
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GoogleLoginButton(
                                isLoading: loginState.isLoading,
                                onPressed: onPressSignInGoogle,
                              ),
                              const Gap(12),
                              AppleLoginButton(
                                isLoading: loginState.isLoading,
                                onPressed: onPressSignInApple,
                              ),
                              const Gap(16),
                              // 区切り線
                              const OrDivider(),
                              const Gap(16),
                              // 匿名ログインボタン
                              AnonymousLoginButton(
                                isLoading: loginState.isLoading,
                                onPressed: onPressSignInAnonymous,
                              ),
                            ],
                          ),
                          const Gap(20),
                          // 利用規約
                          const TermsOfServiceText(),
                          const Gap(20),
                        ],
                      ),
                    ),
                  ),
                ),
                if (loginState.isLoading) const LoadingOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
