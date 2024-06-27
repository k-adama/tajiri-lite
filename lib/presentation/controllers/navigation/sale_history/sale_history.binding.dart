import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/sale_history/sale_history.controller.dart';

class SaleHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SaleHistoryController());
  }
}
