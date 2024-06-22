import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/splash/splash.controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
