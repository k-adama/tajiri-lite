import 'package:flutter/material.dart' as mt;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';

class OrderHistoryController extends GetxController {
  bool isProductLoading = true;
  DateTime? startRangeDate;
  DateTime? endRangeDate;
  List<Order> orders = List<Order>.empty().obs;
  List<Order> ordersInit = List<Order>.empty().obs;
  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() {
    Future.wait([
      fetchOrders(),
    ]);

    super.onReady();
  }

  Future<void> fetchOrders() async {
    final DateTime today = DateTime.now();
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 2));
    final GetOrdersDto dto = GetOrdersDto(
      startDate: startRangeDate ?? sevenDaysAgo,
      endDate: endRangeDate ?? today,
    );
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();

      try {
        final result = await tajiriSdk.ordersService.getOrders(dto);
        orders.assignAll(result);
        ordersInit.assignAll(result);
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          mt.Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
      }
      isProductLoading = false;
      update();
    }
  }

  List<Order> orderListByRecentUpdateDate(List<Order> orders) {
    orders.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return orders;
  }
}
