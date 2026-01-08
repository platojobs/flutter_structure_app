// lib/core/bindings/base_binding.dart
import 'package:get/get.dart';

/// Binding 生命周期
enum BindingLifecycle {
  transient,    // 临时，页面销毁时清理
  scoped,       // 作用域内，如 Tab
  singleton,    // 单例
  permanent,    // 永久
}

/// 基础 Binding 抽象类
abstract class BaseBinding {
  final BindingLifecycle lifecycle;
  final String? tag;
  final bool fenix;
  
  BaseBinding({
    this.lifecycle = BindingLifecycle.transient,
    this.tag,
    this.fenix = false,
  });
  
  /// 注册依赖
  void registerDependencies() {
    _registerControllers();
    _registerServices();
    _registerRepositories();
  }
  
  /// 注册控制器
  void _registerControllers();
  
  /// 注册服务
  void _registerServices();
  
  /// 注册仓库
  void _registerRepositories();
  
  /// 智能注册方法
  void put<T>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
    bool fenix = false,
  }) {
    switch (lifecycle) {
      case BindingLifecycle.transient:
        Get.lazyPut(builder, tag: tag ?? this.tag, fenix: fenix || this.fenix);
        break;
      case BindingLifecycle.scoped:
        Get.lazyPut(builder, tag: tag ?? this.tag);
        break;
      case BindingLifecycle.singleton:
        Get.put(builder(), tag: tag ?? this.tag, permanent: true);
        break;
      case BindingLifecycle.permanent:
        Get.put(builder(), tag: tag ?? this.tag, permanent: true);
        break;
    }
  }
  
  /// 清理 Binding
  void dispose() {
    if (lifecycle == BindingLifecycle.transient) {
      // 自动清理，GetX 会自动处理
    }
  }
}