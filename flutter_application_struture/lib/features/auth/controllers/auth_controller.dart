import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/mixins/validation_mixin.dart';
import '../../../core/mixins/cache_mixin.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/mixins/message_mixin.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController 
    with ValidationMixin, CacheMixin, LoadingMixin, MessageMixin {
  // 依赖注入
  final AuthUseCases _authUseCases;
  
  // 响应式状态
  final RxBool _isAuthenticated = false.obs;
  final RxBool _isFirstLaunch = true.obs;
  final Rx<UserEntity?> _currentUser = Rx<UserEntity?>(null);
  final RxString _authToken = ''.obs;
  
  // 注册表单控制器
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();
  
  // 注册表单状态
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;
  final RxBool _agreeTerms = false.obs;
  final RxString _avatarPath = ''.obs;
  final Rx<File?> _avatarFile = Rx<File?>(null);
  
  // Getters
  bool get isAuthenticated => _isAuthenticated.value;
  bool get isFirstLaunch => _isFirstLaunch.value;
  UserEntity? get currentUser => _currentUser.value;
  String get authToken => _authToken.value;
  bool get isLoading => loading;
  RxBool get isAuthenticatedObs => _isAuthenticated;
  RxBool get isFirstLaunchObs => _isFirstLaunch;
  Rx<UserEntity?> get currentUserObs => _currentUser;
  RxString get authTokenObs => _authToken;
  
  // 注册表单Getters
  bool get obscurePassword => _obscurePassword.value;
  bool get obscureConfirmPassword => _obscureConfirmPassword.value;
  bool get agreeTerms => _agreeTerms.value;
  String get avatarPath => _avatarPath.value;
  File? get avatarFile => _avatarFile.value;
  
  // 响应式Getters
  RxBool get obscurePasswordObs => _obscurePassword;
  RxBool get obscureConfirmPasswordObs => _obscureConfirmPassword;
  RxBool get agreeTermsObs => _agreeTerms;
  RxString get avatarPathObs => _avatarPath;
  
  AuthController({
    required AuthUseCases authUseCases,
  }) : _authUseCases = authUseCases;
  
  @override
  void onInit() {
    super.onInit();
    _checkInitialAuthState();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    resetEmailController.dispose();
    super.onClose();
  }
  
  // 检查初始认证状态
  void _checkInitialAuthState() async {
    try {
      setLoading(true);
      
      // 检查是否首次启动
      final isFirstLaunchStr = await getCachedString('is_first_launch');
      final isFirstLaunch = isFirstLaunchStr == null ? true : isFirstLaunchStr == 'false' ? false : true;
      _isFirstLaunch.value = isFirstLaunch;
      
      if (!isFirstLaunch) {
        // 检查缓存的用户认证状态
        final cachedUser = await getCachedJson('current_user');
        final cachedToken = await getCachedString('auth_token');
        
        if (cachedUser != null && cachedToken != null && cachedToken.isNotEmpty) {
          _currentUser.value = UserEntity.fromJson(cachedUser);
          _authToken.value = cachedToken;
          _isAuthenticated.value = true;
        }
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      setLoading(false);
    }
  }
  
  // 登录
  Future<bool> login(String email, String password) async {
    try {
      setLoading(true);
      clearAllErrors();
      
      // 输入验证
      final emailError = validateEmail(email);
      final passwordError = validatePassword(password);
      
      if (emailError != null || passwordError != null) {
        if (emailError != null) setError('email', emailError);
        if (passwordError != null) setError('password', passwordError);
        return false;
      }
      
      // 执行登录
      final result = await _authUseCases.login(email, password);
      
      // 更新状态
      _currentUser.value = result.user;
      _authToken.value = result.accessToken;
      _isAuthenticated.value = true;
      
      // 缓存认证状态
      await _cacheAuthState(result);
      
      showMessage('登录成功');
      return true;
      
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } catch (e) {
      showError('登录失败，请重试');
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 注册
  Future<bool> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    String? phone,
  }) async {
    try {
      setLoading(true);
      clearAllErrors();
      
      // 验证输入
      final emailError = validateEmail(email);
      final passwordError = validatePassword(password);
      final confirmPasswordError = validateConfirmPassword(password, confirmPassword);
      final fullNameError = validateRequired(fullName, fieldName: '姓名');
      
      if (emailError != null) setError('email', emailError);
      if (passwordError != null) setError('password', passwordError);
      if (confirmPasswordError != null) setError('confirmPassword', confirmPasswordError);
      if (fullNameError != null) setError('fullName', fullNameError);
      
      if (hasError('email') || hasError('password') || hasError('confirmPassword') || hasError('fullName')) {
        return false;
      }
      
      // 执行注册
      final registerData = RegisterData(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      final result = await _authUseCases.register(registerData);
      
      // 更新状态
      _currentUser.value = result.user;
      _authToken.value = result.accessToken;
      _isAuthenticated.value = true;
      
      // 缓存认证状态
      await _cacheAuthState(result);
      
      showMessage('注册成功');
      return true;
      
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } catch (e) {
      showError('注册失败，请重试');
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 退出登录
  Future<void> logout() async {
    try {
      setLoading(true);
      
      // 清除服务器端会话
      await _authUseCases.logout();
      
      // 清除本地状态
      _clearAuthState();
      
      showMessage('已退出登录');
      
    } catch (e) {
      // 即使服务器清除失败，也要清除本地状态
      _clearAuthState();
      showError('退出登录失败');
    } finally {
      setLoading(false);
    }
  }
  
  // 忘记密码
  Future<bool> forgotPassword(String email) async {
    try {
      setLoading(true);
      
      final emailError = validateEmail(email);
      if (emailError != null) {
        setError('email', emailError);
        return false;
      }
      
      await _authUseCases.sendPasswordResetEmail(email);
      showMessage('重置密码邮件已发送');
      return true;
      
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } catch (e) {
      showError('发送重置密码邮件失败');
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 刷新认证令牌
  Future<bool> refreshToken() async {
    try {
      final authResult = await _authUseCases.refreshToken();
      _authToken.value = authResult.accessToken;
      await cacheString('auth_token', authResult.accessToken);
      return true;
    } catch (e) {
      // 刷新失败，清理认证状态
      _clearAuthState();
      return false;
    }
  }
  
  // 更新用户资料
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? avatar,
  }) async {
    try {
      setLoading(true);
      
      final updateData = UpdateUserData(
        fullName: fullName,
        phone: phone,
        avatar: avatar,
      );
      
      final updatedUser = await _authUseCases.updateProfile(updateData);
      
      // 更新用户信息
      _currentUser.value = updatedUser;
      
      // 更新缓存
      await cacheJson('current_user', updatedUser.toJson());
      
      showMessage('个人资料更新成功');
      return true;
      
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } catch (e) {
      showError('更新失败，请重试');
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 修改密码
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      setLoading(true);
      
      final newPasswordError = validatePassword(newPassword);
      final confirmPasswordError = validateConfirmPassword(newPassword, confirmPassword);
      
      final errors = <String, String>{};
      if (newPasswordError != null) errors['newPassword'] = newPasswordError;
      if (confirmPasswordError != null) errors['confirmPassword'] = confirmPasswordError;
      
      if (errors.isNotEmpty) {
        errors.forEach((field, message) => setError(field, message));
        return false;
      }
      
      await _authUseCases.changePassword(currentPassword, newPassword);
      
      showMessage('密码修改成功');
      return true;
      
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } catch (e) {
      showError('密码修改失败');
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 注册相关UI方法
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
  }
  
  void toggleAgreeTerms() {
    _agreeTerms.value = !_agreeTerms.value;
  }
  
  Future<void> pickAvatar() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        _avatarFile.value = File(pickedFile.path);
        _avatarPath.value = pickedFile.path;
      }
    } catch (e) {
    showError('选择头像失败');
  }
  }
  
  // 注册方法 - 从表单数据注册
  Future<bool> register() async {
    if (!_agreeTerms.value) {
      setError('terms', '请同意用户协议和隐私政策');
      return false;
    }
    
    final success = await registerUser(
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    
    if (success) {
      _clearRegisterForm();
    }
    
    return success;
  }
  
  // 清空注册表单
  void _clearRegisterForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _obscurePassword.value = true;
    _obscureConfirmPassword.value = true;
    _agreeTerms.value = false;
    _avatarPath.value = '';
    _avatarFile.value = null;
    clearAllErrors();
  }
  
  // 第三方登录方法
  Future<void> loginWithGoogle() async {
    try {
      setLoading(true);
      // TODO: 实现Google登录逻辑
      showMessage('Google登录功能开发中');
    } catch (e) {
      showError('Google登录失败');
    } finally {
      setLoading(false);
    }
  }
  
  Future<void> loginWithApple() async {
    try {
      setLoading(true);
      // TODO: 实现Apple登录逻辑
      showMessage('Apple登录功能开发中');
    } catch (e) {
      showError('Apple登录失败');
    } finally {
      setLoading(false);
    }
  }
  
  Future<void> biometricLogin() async {
    try {
      setLoading(true);
      // TODO: 实现生物识别登录逻辑
      showMessage('生物识别登录功能开发中');
    } catch (e) {
      showError('生物识别登录失败');
    } finally {
      setLoading(false);
    }
  }
  
  // 忘记密码处理
  void showForgotPasswordDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('重置密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请输入您的邮箱地址，我们将发送重置密码链接'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '邮箱地址',
                border: OutlineInputBorder(),
              ),
              controller: resetEmailController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              resetEmailController.clear();
              Get.back();
            },
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = resetEmailController.text.trim();
              if (email.isNotEmpty) {
                await forgotPassword(email);
                resetEmailController.clear();
                Get.back();
              }
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }
  
  // 跳转到注册页面
  void goToRegister() {
    Get.toNamed('/register');
  }
  
  // 完成首次启动设置
  Future<void> completeFirstLaunch() async {
    await cacheString('is_first_launch', 'false');
    _isFirstLaunch.value = false;
  }
  
  // 缓存认证状态
  Future<void> _cacheAuthState(dynamic result) async {
    await cacheJson('current_user', result.user.toJson());
    await cacheString('auth_token', result.accessToken);
  }
  
  // 清除认证状态
  void _clearAuthState() {
    _currentUser.value = null;
    _authToken.value = '';
    _isAuthenticated.value = false;
    
    // 清除缓存
    removeCache('current_user');
    removeCache('auth_token');
  }
  
  // 处理认证错误
  void _handleAuthError(dynamic error) {
    if (error is AuthException) {
      _clearAuthState();
      showError(error.message);
    } else {
      showError('认证状态检查失败');
    }
  }
  
  // 验证方法
  @override
  String? validatePassword(String? password, {int minLength = 6}) {
    if (password?.isNullOrEmpty ?? true) return '请输入密码';
    if (password!.length < minLength) return '密码至少$minLength位字符';
    return null;
  }
  
  @override
  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword?.isNullOrEmpty ?? true) return '请确认密码';
    if (password != confirmPassword) return '两次密码输入不一致';
    return null;
  }
  
  @override
  String? validateRequired(String? value, {String fieldName = '该字段'}) {
    if (value?.isNullOrEmpty ?? true) return '请输入$fieldName';
    return null;
  }
}