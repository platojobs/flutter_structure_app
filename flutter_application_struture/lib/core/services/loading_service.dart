import '../config/loading_config.dart';

/// LoadingService 管理多个 LoadingConfig 预设，并提供运行时切换
class LoadingService {
  final Map<String, LoadingConfig> _presets = {};
  String? _current;

  LoadingService() {
    // 默认预设
    _presets['default'] = const LoadingConfig();
    _current = 'default';
  }

  /// 注册或覆盖预设
  void registerPreset(String name, LoadingConfig config) {
    _presets[name] = config;
  }

  /// 应用指定预设到 EasyLoading
  void applyPreset(String name) {
    final cfg = _presets[name];
    if (cfg != null) {
      cfg.apply();
      _current = name;
    }
  }

  /// 获取当前预设名
  String? get currentPreset => _current;

  /// 获取已注册预设列表
  List<String> get presets => _presets.keys.toList();
}
