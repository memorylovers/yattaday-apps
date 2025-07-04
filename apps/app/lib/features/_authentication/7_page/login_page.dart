import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/hooks/use_error_message.dart';
import '../../../components/loading_overlay.dart';
import '../../../components/or_divider.dart';
import '../../../components/scaffold/gradient_scaffold.dart';
import '../5_view_model/login_view_model.dart';
import '../6_component/app_branding_section.dart';
import '../6_component/login_buttons.dart';
import '../6_component/terms_of_service_text.dart';

/// ログイン画面
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    // エラーメッセージの監視
    useErrorMessage(loginState.errorMessage, context);

    return Stack(
      children: [
        GradientScaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // アプリブランディングセクション（50%）
                Center(child: AppBrandingSection()),
                const Gap(20),

                // ログインボタン
                GoogleLoginButton(
                  isLoading: loginState.isLoading,
                  onPressed: () {
                    loginViewModel.signInGoogle(
                      onError: (error) {
                        // エラーはuseErrorMessageで表示される
                      },
                    );
                  },
                ),
                const Gap(12),

                AppleLoginButton(
                  isLoading: loginState.isLoading,
                  onPressed: () {
                    loginViewModel.signInApple(
                      onError: (error) {
                        // エラーはuseErrorMessageで表示される
                      },
                    );
                  },
                ),

                // 区切り線
                const Gap(16),
                const OrDivider(),
                const Gap(16),

                // 匿名ログインボタン
                AnonymousLoginButton(
                  isLoading: loginState.isLoading,
                  onPressed: () {
                    loginViewModel.signInAnonymous(
                      onError: (error) {
                        // エラーはuseErrorMessageで表示される
                      },
                    );
                  },
                ),

                // 利用規約
                const Gap(20),
                const TermsOfServiceText(),
                const Gap(20),
              ],
            ),
          ),
        ),

        // TODO: ローディングをオーバーレイではなく、AppBrandingSectionの位置を維持したまま、ボタンなどを非表示にし、代わりにローディングを表示したい
        if (loginState.isLoading) LoadingOverlay(),
      ],
    );
  }
}
