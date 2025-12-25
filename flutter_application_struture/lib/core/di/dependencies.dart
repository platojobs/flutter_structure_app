import 'package:get_it/get_it.dart';
import 'package:flutter_application_struture/features/auth/repositories/auth_repository.dart';
import 'package:flutter_application_struture/features/auth/repositories/impl/auth_repository_impl.dart';
import 'package:flutter_application_struture/data/network/api_client.dart';
import 'package:flutter_application_struture/core/services/token_service.dart';

/// 注册具体模块与服务的示例入口
void registerDependencies(GetIt getIt) {
  // 在此注册应用的具体依赖
  // String baseUrl 已由 Injector._registerCore 注册，避免重复注册
  // ApiClient 由 Injector._registerCore 根据注册的 baseUrl 创建
  if (getIt.isRegistered<ApiClient>() && getIt.isRegistered<TokenService>()) {
    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<ApiClient>(), getIt<TokenService>()));
    }
  }
}
