import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../_gen/i18n/strings.g.dart';
import '../../../components/scaffold/gradient_scaffold.dart';
import '../../../routing/router_routes.dart';
import '../5_view_model/settings_view_model.dart';

/// 設定画面
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsViewModelProvider);
    final settingsViewModel = ref.read(settingsViewModelProvider.notifier);

    return GradientScaffold(
      title: i18n.settings.title,
      showBackButton: true,
      useWhiteContainer: true,
      body: ListView(
        children: [
          // ユーザープロフィール
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF87CEEB),
                  child: const Text(
                    'T',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.settings.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        i18n.settings.userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // アカウントセクション
          _buildSection(
            context,
            title: i18n.settings.account,
            children: [
              _buildListTile(
                icon: Icons.credit_card,
                title: i18n.settings.planManagement,
                subtitle: '${i18n.settings.currentPlan}: ${i18n.settings.free}',
                onTap: () => const PaymentPageRoute().go(context),
              ),
              _buildListTile(
                icon: Icons.person_outline,
                title: i18n.settings.profileEdit,
                onTap: () {
                  // TODO: プロフィール編集
                },
              ),
            ],
          ),

          // アプリ設定セクション
          _buildSection(
            context,
            title: i18n.settings.appSettings,
            children: [
              _buildListTile(
                icon: Icons.notifications_outlined,
                title: i18n.settings.notifications,
                subtitle: i18n.settings.notificationsDesc,
                onTap: () {
                  // TODO: 通知設定
                },
              ),
              _buildListTile(
                icon: Icons.palette_outlined,
                title: i18n.settings.theme,
                subtitle: i18n.settings.lightMode,
                onTap: () {
                  // TODO: テーマ設定
                },
              ),
              _buildListTile(
                icon: Icons.language,
                title: i18n.settings.language,
                subtitle: i18n.settings.japanese,
                onTap: () {
                  // TODO: 言語設定
                },
              ),
            ],
          ),

          // サポートセクション
          _buildSection(
            context,
            title: i18n.settings.support,
            children: [
              _buildListTile(
                icon: Icons.help_outline,
                title: i18n.settings.help,
                onTap: () {
                  // TODO: ヘルプ
                },
              ),
              _buildListTile(
                icon: Icons.mail_outline,
                title: i18n.settings.contactUs,
                onTap: () {
                  // TODO: お問い合わせ
                },
              ),
              _buildListTile(
                icon: Icons.description_outlined,
                title: i18n.settings.terms,
                onTap: () {
                  // TODO: 利用規約
                },
              ),
              _buildListTile(
                icon: Icons.lock_outline,
                title: i18n.settings.privacy,
                onTap: () {
                  // TODO: プライバシーポリシー
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ログアウトボタン
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              onPressed:
                  settingsState.isLoading ? null : settingsViewModel.signOut,
              icon: Icon(Icons.logout, color: Colors.grey[600], size: 20),
              label: Text(
                i18n.settings.logout,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              )
              : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
