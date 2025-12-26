import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/extensions.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '注册账户',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // 欢迎信息
                _buildWelcomeHeader(),
                
                const SizedBox(height: 32),
                
                // 注册表单
                _buildRegisterForm(),
                
                const SizedBox(height: 24),
                
                // 注册按钮
                _buildRegisterButton(),
                
                const SizedBox(height: 16),
                
                // 登录链接
                _buildLoginLink(),
              ],
            );
          }),
        ),
      ),
    );
  }

  // 构建欢迎头部
  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        // 头像上传区域
        GestureDetector(
          onTap: controller.pickAvatar,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: controller.avatarPath.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey[600],
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '上传头像',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      controller.avatarFile!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        const Text(
          '创建您的账户',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          '请填写以下信息完成注册',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 构建注册表单
  Widget _buildRegisterForm() {
    return Column(
      children: [
        // 姓名输入
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: '姓名',
            hintText: '请输入您的姓名',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: controller.getError('name'),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 邮箱输入
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: '邮箱地址',
            hintText: '请输入您的邮箱',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: controller.getError('email'),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 手机号输入
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: '手机号码',
            hintText: '请输入您的手机号',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: controller.getError('phone'),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 密码输入
        TextFormField(
          controller: controller.passwordController,
          obscureText: controller.obscurePassword,
          decoration: InputDecoration(
            labelText: '密码',
            hintText: '请输入密码（至少8位）',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword 
                  ? Icons.visibility_off_outlined 
                  : Icons.visibility_outlined,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: controller.getError('password'),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 确认密码输入
        TextFormField(
          controller: controller.confirmPasswordController,
          obscureText: controller.obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: '确认密码',
            hintText: '请再次输入密码',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureConfirmPassword 
                  ? Icons.visibility_off_outlined 
                  : Icons.visibility_outlined,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: controller.getError('confirmPassword'),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 同意条款
        Row(
          children: [
            Checkbox(
              value: controller.agreeTerms,
              onChanged: (value) => controller.toggleAgreeTerms(),
              activeColor: Colors.blue,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.toggleAgreeTerms(),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    children: [
                      const TextSpan(text: '我已阅读并同意 '),
                      TextSpan(
                        text: '用户协议',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(text: ' 和 '),
                      TextSpan(
                        text: '隐私政策',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        if (controller.getError('terms') != null) ...[
          const SizedBox(height: 4),
          Text(
            controller.getError('terms')!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  // 构建注册按钮
  Widget _buildRegisterButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isLoading || !controller.agreeTerms ? null : () async {
          final success = await controller.register();
          if (success) {
            Get.snackbar(
              '注册成功',
              '欢迎加入我们！请检查邮箱验证链接',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.offAllNamed('/login');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                '创建账户',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // 构建登录链接
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('已有账户？'),
        TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('立即登录'),
        ),
      ],
    );
  }
}