import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
