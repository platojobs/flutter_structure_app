import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserProfilePage extends GetView<UserController> {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户资料'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/profile/edit'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Column(
          children: [
            // 头像和基本信息
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      controller.name.isNotEmpty ? controller.name[0] : 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            
            // 用户信息列表
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    icon: Icons.person,
                    title: '我的资料',
                    onTap: () => Get.toNamed('/profile'),
                  ),
                  _buildListTile(
                    icon: Icons.shopping_bag,
                    title: '我的订单',
                    onTap: () => Get.toNamed('/orders'),
                  ),
                  _buildListTile(
                    icon: Icons.favorite,
                    title: '我的收藏',
                    onTap: () => Get.toNamed('/favorites'),
                  ),
                  _buildListTile(
                    icon: Icons.settings,
                    title: '设置',
                    onTap: () => Get.toNamed('/settings'),
                  ),
                  _buildListTile(
                    icon: Icons.help,
                    title: '帮助与反馈',
                    onTap: () => Get.toNamed('/help'),
                  ),
                  _buildListTile(
                    icon: Icons.logout,
                    title: '退出登录',
                    onTap: () => controller.logout(),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}