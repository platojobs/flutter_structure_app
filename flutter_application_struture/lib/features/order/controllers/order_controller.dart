import 'package:get/get.dart';

class OrderController extends GetxController {
  // Order控制器的简单实现
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  
  Future<void> loadOrders() async {
    // 模拟加载订单数据
    await Future.delayed(const Duration(seconds: 1));
    orders.assignAll([]);
  }
}