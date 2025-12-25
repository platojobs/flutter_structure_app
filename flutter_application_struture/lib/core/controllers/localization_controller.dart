import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 国际化/本地化控制器
class LocalizationController extends GetxController {
  final _locale = Locale('zh', 'CN').obs;

  Locale get locale => _locale.value;

  /// 支持的语言列表
  static const List<String> languages = ['中文', 'English'];
  static const List<String> languageCodes = ['zh', 'en'];

  /// 改变语言
  void changeLanguage(String languageCode) {
    final locale = _getLocaleFromCode(languageCode);
    _locale.value = locale;
    Get.updateLocale(locale);
  }

  /// 从语言代码获取 Locale
  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case 'zh':
        return const Locale('zh', 'CN');
      case 'en':
        return const Locale('en', 'US');
      default:
        return const Locale('zh', 'CN');
    }
  }

  /// 获取当前语言代码
  String get currentLanguageCode => _locale.value.languageCode;
}
