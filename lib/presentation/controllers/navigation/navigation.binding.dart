import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';

class NavigationBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
     Get.lazyPut(() => HomeController());
     Get.lazyPut(() => PosController());
  }
}
