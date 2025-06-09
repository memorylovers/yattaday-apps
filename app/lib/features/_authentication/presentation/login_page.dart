import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../_gen/assets/assets.gen.dart';
import '../../../_gen/i18n/strings.g.dart';
import '../../../common/types/types.dart';
import '../../../common/utils/snack_bar_handler.dart';
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

    return Scaffold(
      // backgroundColor: lightColorScheme.primary,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Assets.icons.iconCircle512.image(width: 160, height: 160),
              Text(
                i18n.app.name,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const Gap(48),

              // buttons
              Stack(
                children: [
                  // ローディング中は、サイズを維持して非表示にする
                  Visibility(
                    visible: !isLoading.value,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainInteractivity: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GoogleLoginButton(
                          isLoading: isLoading.value,
                          onPressed: () => onClickLogin(AuthType.google),
                        ),
                        const Gap(8),
                        AppleLoginButton(
                          isLoading: isLoading.value,
                          onPressed: () => onClickLogin(AuthType.apple),
                        ),
                        const Gap(8),
                        AnonymousLoginButton(
                          isLoading: isLoading.value,
                          onPressed: () => onClickLogin(AuthType.anonymous),
                        ),
                      ],
                    ),
                  ),

                  // ローディングを表示
                  if (isLoading.value)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
