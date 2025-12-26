# flutter_structure_app
GetX 企业级完整架构

项目骨架与架构说明（示例模板）

本仓库提供一个结构清晰的 Flutter 应用模板，按分层架构组织：核心层、数据层、领域层、功能模块与共享资源。

**项目结构概览**
- **`lib/main.dart`**: 应用入口
- **`lib/app.dart`**: 应用主组件（路由、主题、根Binding等）
- **`lib/core/`**: 框架核心：基类、混入、DI、配置与工具
- **`lib/data/`**: 数据与网络（API 客户端、数据源、仓库实现）
- **`lib/domain/`**: 领域层（实体、用例、仓库接口）
- **`lib/features/`**: 按功能拆分的模块（例如 `auth`、`product`、`dashboard`）
- **`lib/shared/`**: 共享组件、样式和常量
- **`lib/routes/`**: 路由定义与守卫

**关键文件示例**
- `lib/core/di/injector.dart` ([lib/core/di/injector.dart](lib/core/di/injector.dart)): 全局依赖注入入口，使用 `GetIt`。
- `lib/core/di/dependencies.dart` ([lib/core/di/dependencies.dart](lib/core/di/dependencies.dart)): 模块依赖注册点。
- `lib/data/network/api_client.dart` ([lib/data/network/api_client.dart](lib/data/network/api_client.dart)): `Dio` 封装，包含拦截器与响应处理封装。
- `lib/core/mixins/loading_mixin.dart` ([lib/core/mixins/loading_mixin.dart](lib/core/mixins/loading_mixin.dart)): 控制器加载状态混入。

**设计原则（简要）**
- 单一职责：每个模块/文件职责单一，便于维护与测试。 
- 依赖反转：上层仅依赖抽象（接口），实现通过 DI 注入。 
- 可测试性：把网络、仓库与业务逻辑解耦，方便单元测试。

**快速开始**
- 安装依赖并获取包：
```bash
flutter pub get
```
- 初始化依赖注入（在 `main()` 或 App 启动阶段调用）：
```dart
import 'package:flutter_application_struture/core/di/injector.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Injector.init();
    runApp(const App());
}
```

在 `lib/core/di/dependencies.dart` 中你可以注册应用级依赖，例如 baseUrl、仓库实现等。`Injector.init()` 会先注册核心单例（例如 `FlutterSecureStorage`、`ApiClient`），然后调用 `registerDependencies` 让模块注册它们的实现。

**配置说明**
- 加载动画配置：`lib/core/config/loading_config.dart` ([lib/core/config/loading_config.dart](lib/core/config/loading_config.dart))，调用 `LoadingConfig().apply()` 可将配置应用到 `flutter_easyloading`。
- 网络配置：`lib/data/network/interceptors.dart` 提供 `LoggingInterceptor` 与 `AuthInterceptor`，可在 `ApiClient` 中添加或通过 DI 注入 `AuthInterceptor`。

**示例：认证模块**
- `lib/features/auth/` 包含仓库接口、实现、控制器、binding 与视图示例：
    - `features/auth/repositories/auth_repository.dart`
    - `features/auth/repositories/impl/auth_repository_impl.dart`
    - `features/auth/controllers/login_controller.dart`
    - `features/auth/views/login_page.dart`

依赖注册示例（见 `lib/core/di/dependencies.dart`），当 `ApiClient` 可用时会注册 `AuthRepository` 的实现。

**运行与测试**
- 运行应用：
```bash
flutter run
```
- 运行单元测试：
```bash
flutter test
```

**扩展与贡献**
- 添加新模块：在 `lib/features/xxx` 下按同样约定创建 `bindings/`、`controllers/`、`views/`、`repositories/` 等，并在 `lib/core/di/dependencies.dart` 中注册依赖。
- 代码风格与检查：项目默认启用了 `flutter_lints`，请在提交前运行 `flutter analyze`。

**联系方式**
- 若需定制或帮助，请在仓库中创建 issue，或直接编辑/补充 `README.md`。

---
更新于：2025-12-25




lib/

├── main.dart                          # 应用入口

├── app.dart                           # 应用主组件

│

├── core/                              # 核心层

│   ├── base/                          # 基础抽象

│   │   ├── base_controller.dart       # 控制器基类

│   │   ├── base_repository.dart       # 仓库基类

│   │   └── base_service.dart          # 服务基类

│   │

│   ├── mixins/                        # 功能混入

│   │   ├── loading_mixin.dart         # 加载状态管理

│   │   ├── message_mixin.dart         # 消息提示管理

│   │   ├── validation_mixin.dart      # 表单验证

│   │   ├── cache_mixin.dart           # 缓存管理

│   │   └── permission_mixin.dart      # 权限检查

│   │

│   ├── bindings/                      # 依赖注入配置

│   │   ├── base_binding.dart          # Binding基类

│   │   ├── global_binding.dart        # 全局依赖

│   │   └── module_binding.dart        # 模块Binding模板

│   │

│   ├── config/                        # 配置管理

│   │   ├── controller_config.dart     # 控制器配置

│   │   ├── loading_config.dart        # 加载配置

│   │   └── environment.dart           # 环境配置

│   │

│   ├── di/                            # 依赖注入

│   │   ├── injector.dart              # 注入器

│   │   └── dependencies.dart          # 依赖定义

│   │

│   ├── exceptions/                    # 异常处理

│   │   ├── app_exceptions.dart        # 应用异常

│   │   └── exception_handler.dart     # 异常处理器

│   │

│   └── utils/                         # 工具类

│       ├── logger.dart                # 日志工具

│       ├── validators.dart            # 验证工具

│       └── extensions.dart            # 扩展方法

│

├── data/                              # 数据层

│   ├── models/                        # 数据模型

│   ├── repositories/                  # 数据仓库

│   │   ├── impl/                      # 接口实现

│   │   └── interfaces/                # 接口定义

│   │

│   ├── datasources/                   # 数据源

│   │   ├── local/                     # 本地数据源

│   │   ├── remote/                    # 远程数据源

│   │   └── cache/                     # 缓存数据源

│   │

│   └── network/                       # 网络层

│       ├── api_client.dart            # API客户端

│       ├── interceptors.dart          # 拦截器

│       └── response_handler.dart      # 响应处理器

│

├── domain/                            # 领域层

│   ├── entities/                      # 领域实体

│   ├── repositories/                  # 领域仓库接口

│   ├── usecases/                      # 用例

│   └── value_objects/                 # 值对象

│

├── features/                          # 功能模块

│   ├── auth/                          # 认证模块

│   │   ├── bindings/                  # 模块Binding

│   │   │   ├── auth_binding.dart

│   │   │   └── login_binding.dart

│   │   ├── controllers/               # 控制器

│   │   │   ├── auth_controller.dart

│   │   │   └── login_controller.dart

│   │   ├── views/                     # 视图

│   │   │   ├── login_page.dart

│   │   │   └── register_page.dart

│   │   └── widgets/                   # 组件

│   │

│   ├── product/                       # 产品模块

│   │   ├── bindings/

│   │   ├── controllers/

│   │   ├── views/

│   │   └── widgets/

│   │

│   └── dashboard/                     # 仪表盘模块

│       ├── bindings/

│       ├── controllers/

│       ├── views/

│       └── widgets/

│

├── shared/                            # 共享资源

│   ├── widgets/                       # 共享组件

│   ├── styles/                        # 样式

│   └── constants/                     # 常量

│

└── routes/                            # 路由配置

├── app_pages.dart                 # 页面路由

├── app_routes.dart                # 路由定义

└── route_guards.dart              # 路由守卫