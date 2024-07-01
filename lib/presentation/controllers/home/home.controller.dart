import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';

class HomeController extends GetxController {
  Rx<bool> isFetching = true.obs;
  RxList<OrdersDataEntity> orders = List<OrdersDataEntity>.empty().obs;
  RxString viewSelected = TrKeysConstant.day.obs;

  final posController = Get.put(PosController());
  final orderHistoryController = Get.put(OrderHistoryController());
}
