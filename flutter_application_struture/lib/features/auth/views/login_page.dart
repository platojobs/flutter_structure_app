import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../controllers/login_controller.dart';
import '../repositories/auth_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: Get.put(LoginController(GetIt.instance<AuthRepository>())),
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(title: const Text('登录')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => ctrl.email.value = v,
                  decoration: const InputDecoration(labelText: '邮箱'),
                ),
                TextField(
                  onChanged: (v) => ctrl.password.value = v,
                  decoration: const InputDecoration(labelText: '密码'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ctrl.isLoading ? null : () => ctrl.login(),
                  child: ctrl.isLoading ? const CircularProgressIndicator() : const Text('登录'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
