import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'core/translations/app_translations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '企业级Flutter应用',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('zh', 'CN'),
      translations: AppTranslations(),
      builder: EasyLoading.init(),
    );
  }
}
