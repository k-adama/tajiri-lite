import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart' as mt;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/extensions/staff.extension.dart';
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
    streamOrdersChange();
    Future.wait([
      fetchOrders(),
    ]);

    super.onReady();
  }

  streamOrdersChange() async {
    final supabase = Supabase.instance.client;

    supabase
        .channel("orderUpdate")
        .onPostgresChanges(
            table: 'orders',
            event: PostgresChangeEvent.all,
            schema: 'public',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'restaurantId',
                value: user?.restaurantId ?? ""),
            callback: (value) async {
              final eventType = value.eventType;
              final oldOrderReceveid = value.oldRecord;
              final newOrderReceveid = value.newRecord;

              final player = AudioPlayer();
              await player.play(UrlSource(urlSound),
                  mode: PlayerMode.mediaPlayer);

              if (newOrderReceveid['status'] == AppConstants.ORDER_NEW) {
                final player = AudioPlayer();
                await player.play(UrlSource(urlSound),
                    mode: PlayerMode.mediaPlayer);
              }
              try {
                final idOrder = newOrderReceveid['id'];
                if (idOrder == null) {
                  throw "ID NULL";
                }
                fetchOrderById(idOrder);
              } catch (e) {
                print("Erreur channel.listen $e");
                fetchOrders();
              }

              update();
            })
        .subscribe();
  }

  Future<void> fetchOrders() async {
    final DateTime today = DateTime.now();
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 2));
    final ownerId = user?.idOwnerForGetOrder;
    final GetOrdersDto dto = GetOrdersDto(
      startDate: startRangeDate ?? sevenDaysAgo,
      endDate: endRangeDate ?? today,
      ownerId: ownerId,
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

  Future<void> fetchOrderById(String idOrder) async {
    print("====Fetch Order by id==");
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        final order = await tajiriSdk.ordersService.getOrder(idOrder);
        print(
            "====Fetch Order=by id=${order.grandTotal}=${order.orderNumber}=");

        updateOrderList(order);
        update();
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          mt.Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
      }
    }
  }

  void updateOrderList(Order newOrder) {
    final indexInit = ordersInit.indexWhere((order) => order.id == newOrder.id);
    print("update order list $indexInit");
    if (indexInit != -1) {
      // Replace the old order with the new order in ordersInit
      ordersInit[indexInit] = newOrder;
    } else {
      // Add the new order to ordersInit if it doesn't exist
      ordersInit.insert(0, newOrder);
    }

    orders.assignAll(ordersInit);
  }

  List<Order> orderListByRecentUpdateDate(List<Order> orders) {
    orders.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return orders;
  }
}
