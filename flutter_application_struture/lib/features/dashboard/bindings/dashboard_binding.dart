import 'package:get/instance_manager.dart';
import '../controllers/dashboard_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Dashboard控制器
    Get.lazyPut<DashboardController>(() => DashboardController(
      authController: Get.find(),
    ));
  }
}