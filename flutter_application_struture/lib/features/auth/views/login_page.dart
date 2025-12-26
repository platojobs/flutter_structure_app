import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/extensions.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Logo和应用名称
              _buildHeader(),
              
              const SizedBox(height: 48),
              
              // 登录表单
              _buildLoginForm(),
              
              const SizedBox(height: 24),
              
              // 第三方登录选项
              _buildThirdPartyLogin(),
              
              const SizedBox(height: 24),
              
              // 底部链接
              _buildBottomLinks(),
            ],
          ),
        ),
      ),
    );
  }

  // 构建头部
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo图标
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.store,
            color: Colors.white,
            size: 40,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 应用名称
        const Text(
          '欢迎回来',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 8),
        
        const Text(
          '登录您的账户继续使用',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // 构建登录表单
  Widget _buildLoginForm() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 邮箱输入
          TextFormField(
            controller: TextEditingController(text: controller.email)
              ..selection = TextSelection.collapsed(offset: controller.email.length),
            onChanged: controller.updateEmail,
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
          
          // 密码输入
          TextFormField(
            controller: TextEditingController(text: controller.password)
              ..selection = TextSelection.collapsed(offset: controller.password.length),
            onChanged: controller.updatePassword,
            obscureText: controller.obscurePassword,
            decoration: InputDecoration(
              labelText: '密码',
              hintText: '请输入您的密码',
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
          
          // 记住我和忘记密码
          Row(
            children: [
              Checkbox(
                value: controller.rememberMe,
                onChanged: (value) => controller.toggleRememberMe(),
                activeColor: Colors.blue,
              ),
              const Text('记住我'),
              const Spacer(),
              TextButton(
                onPressed: controller.forgotPassword,
                child: const Text('忘记密码？'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 登录按钮
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading ? null : () async {
                final success = await controller.login();
                if (success) {
                  Get.offAllNamed('/dashboard');
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
                    '登录',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      );
    });
  }

  // 构建第三方登录
  Widget _buildThirdPartyLogin() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '或使用第三方登录',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Google登录
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.loginWithGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 24),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Apple登录
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.loginWithApple,
                icon: const Icon(Icons.apple, size: 24),
                label: const Text('Apple'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // 生物识别登录
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.biometricLogin,
            icon: const Icon(Icons.fingerprint, size: 20),
            label: const Text('生物识别登录'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建底部链接
  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('还没有账户？'),
        TextButton(
          onPressed: controller.goToRegister,
          child: const Text('立即注册'),
        ),
      ],
    );
  }
}