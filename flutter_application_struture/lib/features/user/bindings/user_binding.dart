import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => UserController()),
    ];
  }
}