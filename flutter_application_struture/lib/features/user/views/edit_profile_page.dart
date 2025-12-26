import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/user_controller.dart';

class EditProfilePage extends GetView<UserController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: controller.name);
    final emailController = TextEditingController(text: controller.email);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑资料'),
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isLoading ? null : () => _saveProfile(context, nameController, emailController),
            child: Text(
              controller.isLoading ? '保存中...' : '保存',
              style: TextStyle(
                color: controller.isLoading ? Colors.grey : Colors.white,
              ),
            ),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像部分
              _buildAvatarSection(),
              const SizedBox(height: 32),
              
              // 错误信息
              if (controller.error.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (controller.error.isNotEmpty) const SizedBox(height: 16),
              
              // 表单部分
              AppTextField(
                label: '姓名',
                hint: '请输入您的姓名',
                controller: nameController,
                isRequired: true,
                prefix: const Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              
              AppTextField(
                label: '邮箱',
                hint: '请输入您的邮箱',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
                prefix: const Icon(Icons.email),
              ),
              const SizedBox(height: 24),
              
              // 保存按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading ? null : () => _saveProfile(context, nameController, emailController),
                  icon: controller.isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(controller.isLoading ? '保存中...' : '保存资料'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showImagePickerDialog,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: controller.avatarUrl.isNotEmpty
                      ? NetworkImage(controller.avatarUrl) as ImageProvider
                      : null,
                  child: controller.avatarUrl.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _showImagePickerDialog,
            child: const Text('点击更换头像'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '选择头像来源',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  icon: Icons.camera_alt,
                  title: '拍照',
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildPickerOption(
                  icon: Icons.photo_library,
                  title: '相册',
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        // 这里应该上传头像到服务器
        // 现在只是更新本地状态
        Get.snackbar('提示', '头像上传功能待实现', snackPosition: SnackPosition.bottom);
      }
    } catch (e) {
      Get.snackbar('错误', '选择图片失败: $e', snackPosition: SnackPosition.bottom);
    }
  }

  void _saveProfile(BuildContext context, TextEditingController nameController, TextEditingController emailController) {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('提示', '请输入姓名', snackPosition: SnackPosition.bottom);
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('提示', '请输入邮箱', snackPosition: SnackPosition.bottom);
      return;
    }
    
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('提示', '请输入有效的邮箱地址', snackPosition: SnackPosition.bottom);
      return;
    }
    
    controller.updateUserInfo({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
    });
    
    Get.snackbar('成功', '资料更新成功', snackPosition: SnackPosition.bottom);
    Get.back();
  }
}