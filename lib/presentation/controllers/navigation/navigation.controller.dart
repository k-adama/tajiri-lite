import 'package:get/get_state_manager/get_state_manager.dart';

class NavigationController extends GetxController {
  int selectIndex = 0;
  void selectIndexFunc(int index) {
    selectIndex = index;
    update();
  }
}
