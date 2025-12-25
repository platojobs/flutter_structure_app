import 'package:get/get.dart';
import 'package:flutter_application_struture/core/base/base_controller.dart';
import 'package:flutter_application_struture/core/mixins/loading_mixin.dart';
import 'package:flutter_application_struture/core/mixins/message_mixin.dart';
import '../repositories/auth_repository.dart';

class LoginController extends BaseController with LoadingMixin, MessageMixin {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  final RxString email = ''.obs;
  final RxString password = ''.obs;

  Future<void> login() async {
    await safeExecute<String>(
      action: () => _authRepository.login(email.value, password.value),
      loadingText: '登录中...',
      successText: '登录成功',
      errorText: '登录失败',
      onSuccess: (token) {
        showMessage('登录成功');
        print('获得 token: $token');
            },
    );
  }
}
