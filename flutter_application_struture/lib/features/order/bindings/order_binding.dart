import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class OrderBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<OrderController>(() => OrderController()),
    ];
  }
}