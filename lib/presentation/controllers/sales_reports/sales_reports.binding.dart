import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.controller.dart';

class SalesReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SalesReportsController());
  }
}
