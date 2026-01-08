import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Dashboard控制器的简单实现
  final RxInt currentIndex = 0.obs;
  
  void changeTab(int index) {
    currentIndex.value = index;
  }
}