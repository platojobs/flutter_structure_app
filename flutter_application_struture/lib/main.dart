import 'package:flutter/material.dart';
import 'core/config/loading_config.dart';
import 'core/di/injector.dart';
import 'app.dart';
export 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖注入
  await Injector.init();

  // 应用默认 Loading 配置
  const LoadingConfig().apply();

  runApp(const MyApp());
}
 