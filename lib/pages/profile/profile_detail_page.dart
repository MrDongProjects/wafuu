import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';
import 'package:wafu_bunpo/services/auth_service.dart';
import 'package:wafu_bunpo/pages/common/policy_page.dart';
import 'package:wafu_bunpo/constants/policy_contents.dart';
import 'package:wafu_bunpo/models/user_update_dto.dart';
import 'package:wafu_bunpo/pages/auth/change_password_page.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser!;
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authService = AuthService();
      final userUpdateDto = UserUpdateDto(
        nickname: _usernameController.text,
        email: _emailController.text,
      );

      final (success, message) =
          await authService.updateUserInfo(userUpdateDto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (success) {
          setState(() => _isEditing = false);
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser!;
    final defaultAvatar = _getDefaultAvatar();

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
              if (!_isEditing) {
                _usernameController.text = user.username;
                _emailController.text = user.email;
              }
            },
            child: Text(_isEditing ? '取消' : '编辑'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 头像区域
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.wasabiGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.avatar ?? defaultAvatar,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '头像暂不支持修改',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // 个人信息表单
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入用户名';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: _isEditing,
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入邮箱';
                        }
                        if (!value.contains('@')) {
                          return '请输入有效的邮箱地址';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // VIP 信息
                    Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        title: Text(
                          user.vip == 1 ? 'VIP会员' : '普通会员',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          user.vip == 1
                              ? '有效期至：${user.vipEndTime ?? "永久"}'
                              : '开通VIP享受更多功能',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: user.vip != 1
                            ? OutlinedButton(
                                onPressed: () {
                                  // TODO: 实现VIP购买功能
                                },
                                child: const Text('立即开通'),
                              )
                            : null,
                      ),
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          child: const Text('保存修改'),
                        ),
                      ),
                    ],

                    // 其他信息卡片
                    const SizedBox(height: 32),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.security),
                            title: const Text('隐私政策'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PolicyPage(
                                    title: '隐私政策',
                                    content: PolicyContents.privacyPolicy,
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.description),
                            title: const Text('用户协议'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PolicyPage(
                                    title: '用户协议',
                                    content: PolicyContents.userAgreement,
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('关于我们'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PolicyPage(
                                    title: '关于我们',
                                    content: PolicyContents.aboutUs,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // 修改密码按钮
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.wasabiGreen,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('修改密码'),
                      ),
                    ),

                    // 退出登录按钮
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showLogoutDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('退出登录'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '确定',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await AuthService().logout();
      // 返回到上一页并传递退出登录的信号
      Navigator.pop(context, 'logout');
    }
  }

  String _getDefaultAvatar() {
    final List<String> avatarEmojis = [
      '👨',
      '👩',
      '🐱',
      '🐶',
      '🐼',
      '🐨',
      '🐯',
      '🦁',
      '🐸'
    ];

    return avatarEmojis[
        DateTime.now().millisecondsSinceEpoch % avatarEmojis.length];
  }
}
