import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class SettingsPage extends GetView<UserController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 账户设置
          _buildSectionTitle('账户'),
          _buildListTile(
            icon: Icons.lock,
            title: '隐私与安全',
            onTap: () => Get.toNamed('/settings/privacy'),
          ),
          _buildListTile(
            icon: Icons.notifications,
            title: '通知设置',
            onTap: () => Get.toNamed('/settings/notifications'),
          ),
          _buildListTile(
            icon: Icons.language,
            title: '语言设置',
            onTap: () => Get.toNamed('/settings/language'),
          ),
          _buildListTile(
            icon: Icons.payment,
            title: '支付设置',
            onTap: () => Get.toNamed('/settings/payment'),
          ),
          
          // 应用设置
          _buildSectionTitle('应用'),
          _buildListTile(
            icon: Icons.brightness_6,
            title: '主题设置',
            onTap: () => Get.toNamed('/settings/theme'),
          ),
          _buildListTile(
            icon: Icons.storage,
            title: '存储与缓存',
            onTap: () => Get.toNamed('/settings/storage'),
          ),
          _buildListTile(
            icon: Icons.help,
            title: '帮助与反馈',
            onTap: () => Get.toNamed('/help'),
          ),
          
          // 关于
          _buildSectionTitle('关于'),
          _buildListTile(
            icon: Icons.info,
            title: '关于我们',
            onTap: () => Get.toNamed('/about'),
          ),
          _buildListTile(
            icon: Icons.privacy_tip,
            title: '隐私政策',
            onTap: () => Get.toNamed('/privacy'),
          ),
          _buildListTile(
            icon: Icons.article,
            title: '服务条款',
            onTap: () => Get.toNamed('/terms'),
          ),
          
          // 退出登录按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('退出登录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('您确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}