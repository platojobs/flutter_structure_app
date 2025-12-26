import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的资料'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, controller),
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
                    child: controller.avatarUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(controller.avatarUrl),
                          )
                        : Text(
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
            
            // 资料信息
            Expanded(
              child: ListView(
                children: [
                  _buildProfileItem('姓名', controller.name),
                  _buildProfileItem('邮箱', controller.email),
                  _buildProfileItem('手机号', '188****8888'),
                  _buildProfileItem('生日', '1990-01-01'),
                  _buildProfileItem('地址', '北京市朝阳区'),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑资料'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '姓名'),
              initialValue: controller.name,
              onChanged: (value) => controller.name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '邮箱'),
              initialValue: controller.email,
              onChanged: (value) => controller.email = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '手机号'),
              initialValue: '188****8888',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // 更新用户资料
              controller.updateProfile({
                'name': controller.name,
                'email': controller.email,
              });
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}