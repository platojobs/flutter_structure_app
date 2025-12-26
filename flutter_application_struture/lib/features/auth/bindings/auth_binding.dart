import 'package:get/instance_manager.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 认证控制器
    Get.lazyPut<AuthController>(() => AuthController(
      authUseCases: Get.find(),
      cacheService: Get.find(),
    ));
    
    // 登录控制器（如果需要独立管理）
    Get.lazyPut<LoginController>(() => LoginController(
      authUseCases: Get.find(),
    ));
  }
}