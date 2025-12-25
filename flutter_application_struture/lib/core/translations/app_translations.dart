import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': 'Welcome',
        },
        'zh_CN': {
          'welcome': '欢迎',
        },
      };
}
