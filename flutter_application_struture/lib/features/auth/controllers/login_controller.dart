import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../core/mixins/validation_mixin.dart';
import '../../../core/mixins/loading_mixin.dart';
import '../../../core/mixins/message_mixin.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../core/exceptions/app_exceptions.dart';

class LoginController extends GetxController 
    with ValidationMixin, LoadingMixin, MessageMixin {
  // 依赖注入
  final AuthUseCases _authUseCases;
  
  // 表单数据
  final RxString _email = ''.obs;
  final RxString _password = ''.obs;
  final RxBool _rememberMe = false.obs;
  final RxBool _obscurePassword = true.obs;
  
  // Getters
  String get email => _email.value;
  String get password => _password.value;
  bool get rememberMe => _rememberMe.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get isLoading => loading;
  RxString get emailObs => _email;
  RxString get passwordObs => _password;
  RxBool get rememberMeObs => _rememberMe;
  RxBool get obscurePasswordObs => _obscurePassword;
  
  LoginController({
    required AuthUseCases authUseCases,
  }) : _authUseCases = authUseCases;
  
  // 更新邮箱
  void updateEmail(String email) {
    _email.value = email;
    clearErrors();
  }
  
  // 更新密码
  void updatePassword(String password) {
    _password.value = password;
    clearErrors();
  }
  
  // 切换记住我状态
  void toggleRememberMe() {
    _rememberMe.value = !_rememberMe.value;
  }
  
  // 切换密码显示状态
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }
  
  // 登录
  Future<bool> login() async {
    try {
      setLoading(true);
      clearErrors();
      
      // 输入验证
      final emailError = validateEmail(_email.value);
      final passwordError = validatePassword(_password.value);
      
      final errors = <String, String>{};
      if (emailError != null) errors['email'] = emailError;
      if (passwordError != null) errors['password'] = passwordError;
      
      if (errors.isNotEmpty) {
        setErrors(errors);
        return false;
      }
      
      // 执行登录
      final result = await _authUseCases.login(_email.value, _password.value);
      
      // 如果选择记住我，保存登录状态
      if (_rememberMe.value) {
        // 记住密码逻辑（实际生产环境应该避免明文存储密码）
        // 这里可以存储到安全存储中
      }
      
      showMessage('登录成功', isError: false);
      return true;
      
    } on AppException catch (e) {
      showMessage(e.message, isError: true);
      return false;
    } catch (e) {
      showMessage('登录失败，请重试', isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 忘记密码
  void forgotPassword() {
    if (_email.value.isEmpty) {
      showMessage('请先输入邮箱地址', isError: true);
      return;
    }
    
    final emailError = validateEmail(_email.value);
    if (emailError != null) {
      setErrors({'email': emailError});
      return;
    }
    
    // 跳转到忘记密码页面
    Get.toNamed('/forgot-password', arguments: {'email': _email.value});
  }
  
  // 跳转到注册页面
  void goToRegister() {
    Get.toNamed('/register');
  }
  
  // 使用第三方登录（Google）
  Future<bool> loginWithGoogle() async {
    try {
      setLoading(true);
      // TODO: 实现Google登录逻辑
      showMessage('Google登录功能待实现', isError: false);
      return false;
    } catch (e) {
      showMessage('Google登录失败', isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 使用第三方登录（Apple）
  Future<bool> loginWithApple() async {
    try {
      setLoading(true);
      // TODO: 实现Apple登录逻辑
      showMessage('Apple登录功能待实现', isError: false);
      return false;
    } catch (e) {
      showMessage('Apple登录失败', isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 生物识别登录
  Future<bool> biometricLogin() async {
    try {
      setLoading(true);
      // TODO: 实现生物识别登录逻辑
      showMessage('生物识别登录功能待实现', isError: false);
      return false;
    } catch (e) {
      showMessage('生物识别登录失败', isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 快速登录（游客模式）
  Future<bool> guestLogin() async {
    try {
      setLoading(true);
      // TODO: 实现游客登录逻辑
      showMessage('游客登录功能待实现', isError: false);
      return false;
    } catch (e) {
      showMessage('游客登录失败', isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }
  
  // 清除表单
  void clearForm() {
    _email.value = '';
    _password.value = '';
    _rememberMe.value = false;
    clearErrors();
  }
  
  // 验证方法
  String? validateEmail(String? email) {
    if (email.isNullOrEmpty) return '请输入邮箱地址';
    if (!email!.isValidEmail) return '请输入有效的邮箱地址';
    return null;
  }
  
  @override
  String? validatePassword(String? password, {int minLength = 6}) {
    if (password.isNullOrEmpty) return '请输入密码';
    if (password!.length < minLength) return '密码至少$minLength位字符';
    return null;
  }
}