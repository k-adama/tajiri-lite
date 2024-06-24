import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosController());
  }
}
