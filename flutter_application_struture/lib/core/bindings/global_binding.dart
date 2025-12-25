import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_binding.dart';
import '../controllers/theme_controller.dart';
import '../controllers/localization_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/analytics_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/config_repository.dart';

final _logger = Logger();

/// GlobalBinding 用于应用启动时注入全局依赖
class GlobalBinding extends BaseBinding {

  void register() {
    _registerControllers();
    _registerServices();
    _registerRepositories();
  }

  void _registerControllers() {
    // 全局控制器
    Get.put(ThemeController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
  }

  void _registerServices() {
    // 全局服务
    Get.put(ApiService(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.put(NotificationService(), permanent: true);
    Get.put(AnalyticsService(), permanent: true);
  }

  void _registerRepositories() {
    // 全局仓库
    Get.put(UserRepository(), permanent: true);
    Get.put(ConfigRepository(), permanent: true);
  }

  /// 初始化全局依赖
  static Future<void> init() async {
    final binding = GlobalBinding();
    binding.dependencies();

    // 异步初始化关键服务
    try {
      await Get.find<ApiService>().init();
      await Get.find<StorageService>().init();
      _logger.i('✅ 全局依赖注入完成');
    } catch (e) {
      _logger.e('❌ 全局依赖初始化失败: $e');
    }
  }
}