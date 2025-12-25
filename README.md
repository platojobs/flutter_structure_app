# flutter_structure_app
GetX 企业级完整架构

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

