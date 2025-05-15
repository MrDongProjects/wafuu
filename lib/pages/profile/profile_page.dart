import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';
import 'package:wafu_bunpo/services/auth_service.dart';
import 'package:wafu_bunpo/pages/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:wafu_bunpo/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wafu_bunpo/pages/profile/feedback_page.dart';
import 'package:wafu_bunpo/pages/profile/profile_detail_page.dart';
import 'package:wafu_bunpo/pages/study/study_stats_page.dart';
import 'package:wafu_bunpo/pages/study/study_settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 随机emoji头像列表
  final List<String> _avatarEmojis = [
    '👨',
    '👩',
    '🐱',
    '🐶',
    '🐼',
    '🐨',
    '🦊',
    '🦁',
    '🐯',
    '🐸'
  ];

  // 保存固定的头像
  late final String _defaultAvatar;

  @override
  void initState() {
    super.initState();
    // 在初始化时生成一个固定的头像
    _defaultAvatar = _avatarEmojis[
        DateTime.now().millisecondsSinceEpoch % _avatarEmojis.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍱'),
            const SizedBox(width: 8),
            const Text('我的'),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 用户信息
                  _buildUserInfo(),
                  const SizedBox(height: 16),

                  // 功能列表
                  _buildMenuItem(
                    context,
                    icon: '📊',
                    title: '学习统计',
                    subtitle: '查看学习进度和成果',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudyStatsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: '🎯',
                    title: '学习计划',
                    subtitle: '制定个性化学习目标',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudySettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: '🏆',
                    title: '考试记录',
                    subtitle: '模拟考试成绩记录',
                    onTap: () {
                      // TODO: 实现考试记录功能
                    },
                  ),

                  const SizedBox(height: 16),

                  // 底部按钮组
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 联系作者
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(
                            '联系作者',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/xiaohongshu.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          onTap: () async {
                            final url = Uri.parse(
                              'https://www.xiaohongshu.com/user/profile/6108f1630000000001003ea8',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                        const Divider(height: 1),
                        // 反馈建议
                        ListTile(
                          leading: const Icon(Icons.feedback_outlined),
                          title: Text(
                            '反馈建议',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackPage(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        // 黑暗模式
                        Consumer<ThemeController>(
                          builder: (context, themeController, _) {
                            return ListTile(
                              leading: Icon(
                                themeController.isDarkMode
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                '黑暗模式',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              trailing: Switch.adaptive(
                                value: themeController.isDarkMode,
                                onChanged: (_) => themeController.toggleTheme(),
                                activeColor: AppTheme.wasabiGreen,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final authService = AuthService();
    final user = authService.currentUser;

    return Container(
      height: 100,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () async {
            final isLoggedIn = await authService.isLoggedIn();
            if (!isLoggedIn) {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );

              if (result == true) {
                setState(() {}); // 刷新界面显示用户信息
              }
            } else {
              final result = await Navigator.push<dynamic>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailPage(),
                ),
              );
              if (result == 'logout' || result == true) {
                setState(() {}); // 刷新界面
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.wasabiGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user?.avatarUrl ?? _defaultAvatar,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user?.username ?? '未登录',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (user?.vip == 1) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'VIP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '点击登录账号',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      // 固定高度和边距
      height: 80,
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        // 移除卡片的默认边距
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.wasabiGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
