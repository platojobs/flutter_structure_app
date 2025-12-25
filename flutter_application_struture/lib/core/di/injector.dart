import 'package:flutter_application_struture/core/config/loading_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

import 'dependencies.dart';
import '../../data/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/token_service.dart';
import '../services/loading_service.dart';


/// 全局依赖注入入口
/// 使用示例：
///   await Injector.init();
class Injector {
  static final GetIt getIt = GetIt.instance;

  /// 初始化依赖注入
  /// 如果 [reset] 为 true，会先清空已注册的依赖
  static Future<void> init({bool reset = false}) async {
    if (reset) {
      await getIt.reset();
    }

    _registerCore();
    _registerModules();
  }

  static void _registerCore() {
    // 在此注册核心单例（logger、api client、storage 等）
    // 注册持久化安全存储
    if (!getIt.isRegistered<FlutterSecureStorage>()) {
      getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
    }

    // 确保有默认的 baseUrl（若未在模块中注册），避免依赖顺序问题
    if (!getIt.isRegistered<String>()) {
      getIt.registerLazySingleton<String>(() => 'https://api.example.com');
    }

    // 注册 ApiClient，使用已注册的 baseUrl（示例中注册为 String）
    if (!getIt.isRegistered<ApiClient>()) {
      final baseUrl = getIt<String>();
      getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl));
    }
    // 注册 TokenService
    if (!getIt.isRegistered<TokenService>()) {
      getIt.registerLazySingleton<TokenService>(() => TokenService(getIt<FlutterSecureStorage>()));
    }
    // 注册 LoadingService 并添加一个示例预设
    if (!getIt.isRegistered<LoadingService>()) {
      final ls = LoadingService();
      // 示例：添加一个浅色主题预设
      ls.registerPreset(
        'light',
        const LoadingConfig(
          loadingStyle: EasyLoadingStyle.light,
          indicatorType: EasyLoadingIndicatorType.fadingCircle,
          maskType: EasyLoadingMaskType.clear,
          userInteractions: true,
        ),
      );
      getIt.registerLazySingleton<LoadingService>(() => ls);
    }
  }

  static void _registerModules() {
    registerDependencies(getIt);
  }
}
