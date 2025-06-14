import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/router_routes.dart';
import '../../_authentication/application/auth_providers.dart';

/// 設定画面
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5DD3DC),
              const Color(0xFF7EDBB7),
              const Color(0xFFF5D563),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.white,
            child: ListView(
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
                          children: const [
                            Text(
                              '田中 太郎',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'tanaka@example.com',
                              style: TextStyle(
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
                  title: 'アカウント',
                  children: [
                    _buildListTile(
                      icon: Icons.credit_card,
                      title: 'プラン管理',
                      subtitle: '現在のプラン: フリー',
                      onTap: () => const PaymentPageRoute().go(context),
                    ),
                    _buildListTile(
                      icon: Icons.person_outline,
                      title: 'プロフィール編集',
                      onTap: () {
                        // TODO: プロフィール編集
                      },
                    ),
                  ],
                ),

                // アプリ設定セクション
                _buildSection(
                  context,
                  title: 'アプリ設定',
                  children: [
                    _buildListTile(
                      icon: Icons.notifications_outlined,
                      title: '通知設定',
                      subtitle: 'リマインダー通知などカスタマイズ',
                      onTap: () {
                        // TODO: 通知設定
                      },
                    ),
                    _buildListTile(
                      icon: Icons.palette_outlined,
                      title: 'テーマ',
                      subtitle: 'ライトモード',
                      onTap: () {
                        // TODO: テーマ設定
                      },
                    ),
                    _buildListTile(
                      icon: Icons.language,
                      title: '言語',
                      subtitle: '日本語',
                      onTap: () {
                        // TODO: 言語設定
                      },
                    ),
                  ],
                ),

                // サポートセクション
                _buildSection(
                  context,
                  title: 'サポート',
                  children: [
                    _buildListTile(
                      icon: Icons.help_outline,
                      title: 'ヘルプ',
                      onTap: () {
                        // TODO: ヘルプ
                      },
                    ),
                    _buildListTile(
                      icon: Icons.mail_outline,
                      title: 'お問い合わせ',
                      onTap: () {
                        // TODO: お問い合わせ
                      },
                    ),
                    _buildListTile(
                      icon: Icons.description_outlined,
                      title: '利用規約',
                      onTap: () {
                        // TODO: 利用規約
                      },
                    ),
                    _buildListTile(
                      icon: Icons.lock_outline,
                      title: 'プライバシーポリシー',
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
                        isLoading.value
                            ? null
                            : () async {
                              try {
                                isLoading.value = true;
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                await ref
                                    .read(authStoreProvider.notifier)
                                    .signOut();
                              } catch (e) {
                                // TODO: エラー処理
                              } finally {
                                isLoading.value = false;
                              }
                            },
                    icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                    label: const Text(
                      'ログアウト',
                      style: TextStyle(color: Colors.red, fontSize: 16),
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
          ),
        ),
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
