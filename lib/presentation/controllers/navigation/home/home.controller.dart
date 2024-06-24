import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';

class HomeController extends GetxController {
   Rx<bool> isFetching = true.obs;
    RxList<OrdersDataEntity> orders = List<OrdersDataEntity>.empty().obs;
    RxString viewSelected = TrKeysConstant.day.obs;

}