import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PosController extends GetxController {
  String? selectedOfCooking;

 void setSelectTypeOfCooking(String? typOfCooking) {
    selectedOfCooking = typOfCooking;
    update();
  }
}
