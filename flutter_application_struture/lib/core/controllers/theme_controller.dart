import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// 主题控制器（全局单例）
class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
    );
  }

  /// 切换主题
  void toggleTheme() {
    _isDarkMode.toggle();
  }

  /// 设置深色模式
  void setDarkMode(bool dark) {
    _isDarkMode.value = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
}
