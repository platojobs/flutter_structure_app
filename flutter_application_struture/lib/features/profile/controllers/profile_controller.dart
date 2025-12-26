import 'package:get/get.dart';

class ProfileController extends GetxController {
  // 状态
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxString _name = ''.obs;
  final RxString _email = ''.obs;
  final RxString _avatarUrl = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  String get name => _name.value;
  String get email => _email.value;
  String get avatarUrl => _avatarUrl.value;
  
  // Setters
  set name(String value) => _name.value = value;
  set email(String value) => _email.value = value;
  
  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }
  
  // 加载用户档案
  Future<void> _loadProfile() async {
    try {
      _isLoading.value = true;
      // 这里应该加载用户档案信息
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据
      _name.value = '测试用户';
      _email.value = 'test@example.com';
      _avatarUrl.value = '';
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 更新用户档案
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading.value = true;
      
      // 更新状态
      if (data.containsKey('name')) _name.value = data['name'];
      if (data.containsKey('email')) _email.value = data['email'];
      if (data.containsKey('avatarUrl')) _avatarUrl.value = data['avatarUrl'];
      
      // 这里应该发送更新请求到服务器
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  
  // 登出
  void logout() {
    // 这里应该实现登出逻辑
    Get.offAllNamed('/login');
  }
}