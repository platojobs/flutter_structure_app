# Flutter Clean Architecture 架构文档

## 概述

本项目采用 Clean Architecture（干净架构）模式进行设计，确保代码的可维护性、可测试性和可扩展性。架构分为多个层次，每一层都有明确的职责和依赖关系。

## 架构层次

### 1. 核心层 (Core Layer)
**路径**: `lib/core/`
**职责**: 提供框架级别的功能，包括基类、混入、依赖注入、配置和工具类

**主要组件**:
- `di/`: 依赖注入配置
  - `injector.dart`: 全局依赖注入入口，使用 GetIt
  - `dependencies.dart`: 模块依赖注册点
- `config/`: 应用配置
  - `loading_config.dart`: 加载动画配置
- `mixins/`: 混入类
  - `loading_mixin.dart`: 控制器加载状态混入
- `utils/`: 工具类
- `constants/`: 常量定义

### 2. 数据层 (Data Layer)
**路径**: `lib/data/`
**职责**: 负责数据获取、存储和网络通信

**主要组件**:
- `network/`: 网络相关
  - `api_client.dart`: Dio 封装，包含拦截器与响应处理
  - `interceptors.dart`: 网络拦截器（LoggingInterceptor、AuthInterceptor）
- `repositories/`: 数据仓库实现
- `datasources/`: 数据源实现（本地、远程）
- `models/`: 数据模型

### 3. 领域层 (Domain Layer)
**路径**: `lib/domain/`
**职责**: 包含业务逻辑的核心定义，独立于框架和具体实现

**主要组件**:
- `entities/`: 业务实体
- `repositories/`: 仓库接口定义
- `usecases/`: 用例（业务逻辑单元）

### 4. 特性层 (Features Layer)
**路径**: `lib/features/`
**职责**: 按功能模块组织的具体业务功能实现

**已实现模块**:
- `auth/`: 用户认证模块
- `product/`: 产品相关功能
- `cart/`: 购物车功能
- `user/`: 用户相关功能

**每个特性模块结构**:
```
features/{feature_name}/
├── controllers/         # 控制器（GetX）
├── views/              # 视图组件
├── repositories/       # 仓库接口和实现
├── entities/           # 特性相关的实体
├── usecases/           # 特性相关的用例
└── bindings/           # 依赖注入绑定
```

### 5. 共享层 (Shared Layer)
**路径**: `lib/shared/`
**职责**: 跨模块共享的组件、样式和工具

**主要组件**:
- `widgets/`: 共享UI组件
- `styles/`: 样式定义
- `utils/`: 共享工具
- `extensions/`: 扩展方法
- `constants/`: 共享常量

### 6. 路由层 (Routes Layer)
**路径**: `lib/routes/`
**职责**: 统一管理应用路由

**主要组件**:
- `app_pages.dart`: 路由页面定义
- `app_routes.dart`: 路由常量
- `guards/`: 路由守卫

## 核心设计原则

### 1. 依赖倒置原则
- 上层模块不依赖下层模块的具体实现
- 所有依赖都指向抽象（接口）
- 具体实现通过依赖注入提供

### 2. 单一职责原则
- 每个类只有一个变化的原因
- 每个模块只负责一个特定功能
- 代码复用和模块化

### 3. 开闭原则
- 对扩展开放，对修改封闭
- 通过接口和抽象实现可扩展性

### 4. 里氏替换原则
- 子类可以替换父类使用
- 确保接口一致性

## 数据流向

```
View (UI) → Controller → UseCase → Repository Interface
                                  ↓
                            Repository Implementation
                                  ↓
                            DataSource (Local/Remote)
```

## 状态管理

使用 **GetX** 进行状态管理：

### 1. 控制器 (Controller)
- 管理UI状态和业务逻辑
- 处理用户交互
- 与用例交互

### 2. 响应式状态
- 使用 Rx 变量
- Obx 观察者模式
- 自动更新UI

### 3. 依赖注入
- 控制器通过 Bindings 进行依赖注入
- 统一管理依赖关系

## 错误处理

### 1. 网络错误处理
- 统一错误拦截器
- 错误码映射
- 用户友好的错误提示

### 2. 业务错误处理
- 用例级别的错误处理
- 控制器错误状态管理
- 错误UI组件

## 性能优化

### 1. 内存管理
- 及时释放资源
- 避免内存泄漏
- 合理使用缓存

### 2. 渲染优化
- 合理使用 const 构造函数
- 避免不必要的重建
- 使用 RepaintBoundary

### 3. 网络优化
- 请求缓存
- 图片懒加载
- 预加载关键数据

## 测试策略

### 1. 单元测试 (Unit Tests)
**路径**: `test/unit_tests/`
- 测试业务逻辑
- 测试用例
- 测试仓库

### 2. 小部件测试 (Widget Tests)
**路径**: `test/widget_tests/`
- 测试UI组件
- 测试交互逻辑

### 3. 集成测试 (Integration Tests)
**路径**: `test/integration_tests/`
- 测试完整用户流程
- 测试端到端功能

## 项目规范

### 1. 命名规范
- 文件名：snake_case
- 类名：PascalCase
- 变量名：camelCase
- 常量：SCREAMING_SNAKE_CASE

### 2. 导入规范
- Dart内置库
- 第三方库
- 项目内部库（相对路径）

### 3. 代码格式化
- 使用 `flutter format`
- 遵循 Dart 风格指南
- 合理的注释和文档

## 扩展指南

### 添加新功能模块

1. 在 `lib/features/` 下创建新模块目录
2. 创建标准的模块结构（controllers、views、repositories、entities、usecases、bindings）
3. 在 `lib/core/di/dependencies.dart` 中注册依赖
4. 在 `lib/routes/app_pages.dart` 中添加路由
5. 编写相应的测试

### 添加新依赖

1. 更新 `pubspec.yaml`
2. 运行 `flutter pub get`
3. 在依赖注入中注册新依赖
4. 更新相关配置

## 维护建议

1. **定期审查代码**：确保遵循架构原则
2. **及时更新依赖**：保持依赖库的最新版本
3. **编写测试**：为新功能编写完整的测试
4. **文档更新**：架构变更时及时更新文档
5. **性能监控**：定期检查应用性能指标

---

最后更新时间：2025-12-26