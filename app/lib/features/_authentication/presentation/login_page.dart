import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../_gen/assets/assets.gen.dart';
import '../../../common/types/types.dart';
import '../../../common/utils/snack_bar_handler.dart';
import '../../../components/scaffold/gradient_scaffold.dart';
import '../application/auth_providers.dart';
import 'widgets/login_buttons.dart';

/// ログイン画面
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    /// ログイン押下時の処理
    onClickLogin(AuthType authType) async {
      try {
        isLoading.value = true;

        // await Future.delayed(3.seconds);

        // throw AppException();
        await ref.read(authStoreProvider.notifier).signIn(authType);
      } catch (e) {
        if (!context.mounted) return;

        // TODO: エラーメッセージをいい感じにする
        SnackBarHandler.showError(context, message: "$e");
        isLoading.value = false;
      }
    }

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
                Assets.icons.icon.svg(
                  width: 200,
                  height: 200,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
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
                        visible: !isLoading.value,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        maintainInteractivity: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GoogleLoginButton(
                              isLoading: isLoading.value,
                              onPressed: () => onClickLogin(AuthType.google),
                            ),
                            const Gap(12),
                            AppleLoginButton(
                              isLoading: isLoading.value,
                              onPressed: () => onClickLogin(AuthType.apple),
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
                              isLoading: isLoading.value,
                              onPressed: () => onClickLogin(AuthType.anonymous),
                            ),
                          ],
                        ),
                      ),
                      if (isLoading.value)
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
