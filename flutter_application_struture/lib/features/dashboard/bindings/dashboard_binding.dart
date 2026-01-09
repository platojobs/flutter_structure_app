import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      // Dashboard控制器
      Bind.lazyPut<DashboardController>(() => DashboardController()),
    ];
  }
}