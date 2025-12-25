import 'base_binding.dart';

/// ModuleBinding 提供给功能模块的模板实现，方便在模块内部集中注册依赖
class ModuleBinding extends BaseBinding {
  final void Function() onRegister;

  ModuleBinding({required this.onRegister});

  void register() {
    onRegister();
  }
}