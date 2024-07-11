import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/table/table.controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TableController(), fenix: true);
  }
}
