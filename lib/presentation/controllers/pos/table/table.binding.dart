import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/table/table.controller.dart';

class TableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TableController());
  }
}
