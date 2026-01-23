import 'package:get/get.dart';

class OrderController extends GetxController {
  // Order控制器的简单实现
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  
  Future<void> loadOrders() async {
    // 模拟加载订单数据
    await Future.delayed(const Duration(seconds: 1));
    orders.assignAll([
      {
        'id': 'order_001',
        'orderNumber': 'ORD-20240501-001',
        'status': 'pending',
        'totalAmount': 3497.0,
        'itemsCount': 2,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'items': [
          {'productName': 'iPhone 14 Pro', 'quantity': 1, 'price': 3299.0},
          {'productName': 'AirPods Pro', 'quantity': 1, 'price': 198.0},
        ],
      },
      {
        'id': 'order_002',
        'orderNumber': 'ORD-20240428-002',
        'status': 'shipped',
        'totalAmount': 2499.0,
        'itemsCount': 1,
        'createdAt': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'items': [
          {'productName': 'Sony WH-1000XM5', 'quantity': 1, 'price': 2499.0},
        ],
      },
      {
        'id': 'order_003',
        'orderNumber': 'ORD-20240425-003',
        'status': 'delivered',
        'totalAmount': 999.0,
        'itemsCount': 1,
        'createdAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'items': [
          {'productName': 'Nike Air Max 270', 'quantity': 1, 'price': 999.0},
        ],
      },
    ]);
  }
}