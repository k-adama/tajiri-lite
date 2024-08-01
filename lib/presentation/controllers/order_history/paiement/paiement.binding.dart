import 'package:get/get.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/paiement/paiement.controller.dart';

class PaiementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaiementController());
  }
}
