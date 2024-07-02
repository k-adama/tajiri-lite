import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/data/order_history/order_history.repository.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';

class OrderHistoryController extends GetxController {
  bool isProductLoading = true;
  DateTime? startRangeDate;
  DateTime? endRangeDate;
  final OrdersRepository _ordersRepository = OrdersRepository();
  List<OrdersDataEntity> orders = List<OrdersDataEntity>.empty().obs;
  List<OrdersDataEntity> ordersInit = List<OrdersDataEntity>.empty().obs;
  final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();

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
    String startDate =
        DateFormat("yyyy-MM-dd").format(startRangeDate ?? sevenDaysAgo);
    String endDate = DateFormat("yyyy-MM-dd").format(endRangeDate ?? today);
    String? ownerId = (user?.role?.permissions?[0].dashboardUnique ?? false)
        ? user?.id
        : null;
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final response =
          await _ordersRepository.getOrders(startDate, endDate, ownerId);
      response.when(
        success: (data) async {
          final json = data as List<dynamic>;
          final orderData =
              json.map((item) => OrdersDataEntity.fromJson(item)).toList();

          final reOrderDataByUpdatedAt = orderListByRecentUpdateDate(orderData);
          orders.assignAll(reOrderDataByUpdatedAt);
          ordersInit.assignAll(reOrderDataByUpdatedAt);
          isProductLoading = false;
          update();
        },
        failure: (failure, status) {
          isProductLoading = false;
          update();
        },
      );
    }
  }

  List<OrdersDataEntity> orderListByRecentUpdateDate(
      List<OrdersDataEntity> orders) {
    orders.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    return orders;
  }

  tableOrWaitessNoNullOrNotEmpty(OrdersDataEntity orderItem) {
    if (user?.restaurantUser![0].restaurant?.listingType == "TABLE") {
      return orderItem.tableId != null ? true : false;
    } else {
      return orderItem.waitressId != null ? true : false;
    }
  }

  String tableOrWaitressName(OrdersDataEntity orderItem) {
    if (checkListingType(user) == ListingType.waitress) {
      return orderItem.waitressId != null ? orderItem.waitress?.name ?? "" : "";
    } else {
      return orderItem.tableId != null ? orderItem.table?.name ?? "" : "";
    }
  }
}
