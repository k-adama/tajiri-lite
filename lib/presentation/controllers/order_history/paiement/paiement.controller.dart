import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/cash_paiement.screen.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/mobile_money.paiement_screen.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/tpe_paiement.screen.dart';

class PaiementController extends GetxController {
  Order? currentOrder = Get.arguments[0];

  selectPaiement(MeansOfPaymentEntity e) {
    print("select Paiement $e");
    if (e.name == "Cash") {
      Get.to(
        CashPaiementScreen(
          order: currentOrder,
        ),
      );
    } else if (e.name == "TPE") {
      Get.to(
        const TPEPaiementScreen(),
      );
    } else if (e.name == "Mobile") {
      Get.to(
        MobileMoneyPaiementScreen(
          order: currentOrder,
          mobileMeansOfPayment: e,
        ),
      );
    } else if (e.name == "Autre") {}
  }
}
