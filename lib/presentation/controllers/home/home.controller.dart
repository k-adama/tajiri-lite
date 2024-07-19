import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class HomeController extends GetxController {
  Rx<bool> isFetching = true.obs;
  RxList<PaymentValueDto> paymentsMethodAmount =
      List<PaymentValueDto>.empty().obs;

  final posController = Get.put(PosController());
  final orderHistoryController = Get.put(OrderHistoryController());
  final user = AppHelpersCommon.getUserInLocalStorage();

  static final dateTimeNow = DateTime.now();

  DateTime startDate = DateTime.now().obs.value;
  DateTime endDate = DateTime.now().obs.value;
  RxList<Order> orders = List<Order>.empty().obs;
  Rx<int> ordersPaid = 0.obs;
  Rx<int> ordersSave = 0.obs;
  Rx<double> posProviderPercent = 0.0.obs;
  RxInt countPosProvider = 0.obs;
  Rx<double> tajiriProviderPercent = 0.0.obs;
  RxInt countTajiriProvider = 0.obs;
  Rx<double> yangoProviderPercent = 0.0.obs;
  RxInt countYangoProvider = 0.obs;
  Rx<double> cancelStatusPercent = 0.0.obs;
  RxInt countCancelStatus = 0.obs;
  Rx<double> deliveredStatusPercent = 0.0.obs;
  RxInt countDeliveredStatus = 0.obs;
  Rx<double> onWayStatusPercent = 0.0.obs;
  RxInt countOnWayStatusProvider = 0.obs;
  Rx<double> readyStatusPercent = 0.0.obs;
  RxInt countReadyStatusProvider = 0.obs;
  Rx<double> accepetedSatusPercent = 0.0.obs;
  RxInt countAccepetedSatus = 0.obs;

  int ordersDeliveredCount = 0;
  int ordersOnPlaceCount = 0;
  int ordersTakeAwayCount = 0;
  int ordersCancelledCount = 0;

  // statistiques
  Rx<double> percentRevenueComparaison = 0.0.obs;
  Rx<double> percentNbrOrderComparaison = 0.0.obs;

  Rx<int> totalAmount = 0.obs;
  Rx<int> totalOrders = 0.obs;

  List<String> filterItems = [
    TrKeysConstant.day,
    // TrKeysConstant.week,
    // TrKeysConstant.month,
  ];

  RxString selectFiler = TrKeysConstant.day.obs;
  bool get hasWaitressPermission => user?.role == "OWNER";

  final tajiriSdk = TajiriSDK.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDataForReports();
  }

  void changeDateFilter(String status) {
    selectFiler.value = status;
    update();

    switch (status) {
      case TrKeysConstant.day:
        handleDaySelection();
        break;
      case TrKeysConstant.week:
        handleWeekSelection();
        break;
      default:
        handleDefaultSelection();
        break;
    }

    isFetching.value = true;
    update();
    fetchDataForReports();
  }

  fetchDataForReports() async {
    final indexFilter = getIndexFilter();
    isFetching.value = true;
    update();

    final params = getDatesForComparison();

    DateTime startDateComparaison = params['startDate']!;
    DateTime endDateComparaison = params['endDate']!;

    String? ownerId = user?.role == "OWER"
        ? user?.id
        : null; // user?.role?.permissions?[0].dashboardUnique == true ? user?.id : null;
    final GetOrdersDto dto = GetOrdersDto(
        startDate: startDateComparaison,
        endDate: endDateComparaison,
        ownerId: ownerId);
    final GetOrdersDto dtoStart =
        GetOrdersDto(startDate: startDate, endDate: endDate, ownerId: ownerId);

    try {
      final [ordersResponse, comparaisonOders] = await Future.wait([
        tajiriSdk.ordersService.getOrders(dtoStart),
        tajiriSdk.ordersService.getOrders(dto),
      ]);

      final ordersComparaison = comparaisonOders;
      var ordersData = ordersResponse;

      // Supprime les commandes annulees
      ordersData =
          ordersData.where((item) => item.status != 'CANCELLED').toList();

      final groupedByPaymentMethodValue = groupedByPaymentMethod(ordersData);
      paymentsMethodAmount
          .assignAll(paymentMethodsData(groupedByPaymentMethodValue));

      ordersPaid.value = getTotalAmount(
          ordersData.where((item) => item.status == 'PAID').toList());
      ordersSave.value = getTotalAmount(
          ordersData.where((item) => item.status == "NEW").toList());

      final int ordersComparaisonsAmount = getTotalAmount(ordersComparaison);
      totalAmount.value = getTotalAmount(ordersData);

      // calcule percentComparaison en fonction du montant de commandes
      percentRevenueComparaison.value =
          ((totalAmount.value - ordersComparaisonsAmount) /
                  ordersComparaisonsAmount) *
              100;

      totalOrders.value = ordersData.length;

      // calcule percentComparaison en fonction du nombre de commandes

      percentNbrOrderComparaison.value =
          ((totalOrders.value - ordersComparaison.length) /
                  ordersComparaison.length) *
              100;

      isFetching.value = false;
      update();

      orders.assignAll(ordersData);

      countPosProvider.value = countProviderInOrders(orders, "");
      posProviderPercent.value =
          calculatePercentage(countPosProvider.value, orders.length);

      countTajiriProvider.value = countProviderInOrders(orders, "TAJIRI");
      tajiriProviderPercent.value =
          calculatePercentage(countTajiriProvider.value, orders.length);

      countYangoProvider.value = countProviderInOrders(orders, "YANGO");
      yangoProviderPercent.value =
          calculatePercentage(countYangoProvider.value, orders.length);

      countDeliveredStatus.value = countStatusInOrders(orders, "PAID");
      deliveredStatusPercent.value =
          calculatePercentage(countDeliveredStatus.value, orders.length);

      ordersDeliveredCount = orders
          .where((element) => element.orderType == AppConstants.ORDER_DELIVRED)
          .toList()
          .length;

      ordersOnPlaceCount = orders
          .where((element) => element.orderType == AppConstants.orderOnPLace)
          .toList()
          .length;

      ordersTakeAwayCount = orders
          .where((element) => element.orderType == AppConstants.orderTakeAway)
          .toList()
          .length;

      ordersCancelledCount = orders
          .where((element) => element.orderType == AppConstants.ORDER_CANCELED)
          .toList()
          .length;

      isFetching.value = false;
      update();
      eventFilter(indexFilter: indexFilter, status: "Succes");
    } catch (e) {
      eventFilter(indexFilter: indexFilter, status: "Failure");
      isFetching.value = false;
      update();
      print("================> e $e");
    }
    isFetching.value = false;
    update();
  }

  double calculatePercentage(int providerLength, int orderLength) {
    if (orderLength == 0) {
      return 0.0;
    }

    return (providerLength / orderLength) * 100;
  }

  int countProviderInOrders(List<Order> orders, String provider) {
    if (provider.isEmpty) {
      return orders.where((item) => item.provider == null).length;
    }
    return orders.where((item) => item.provider == provider).length;
  }

  int countStatusInOrders(List<Order> orders, String status) {
    if (status.isEmpty) {
      return orders.where((item) => item.status == null).length;
    }
    return orders.where((item) => item.status == status).length;
  }

  Map<String, List<Order>> groupedByPaymentMethod(List<Order> data) {
    Map<String, List<Order>> result = {};

    for (var item in data) {
      String payment = "Cash";
      //item.payments.name ?? "Cash";

      if (!result.containsKey(payment)) {
        result[payment] = [];
      }

      result[payment]!.add(item);
    }

    return result;
  }

  List<PaymentValueDto> paymentMethodsData(
      Map<String, List<Order>> groupedByPaymentMethod) {
    return groupedByPaymentMethod.entries
        .map((MapEntry<String, List<Order>> entry) {
      String key = entry.key;
      List<Order> items = entry.value;

      if (key != "Carte bancaire") {
        int total = items.fold(
            0, (count, item) => count + (item.grandTotal as num).toInt());
        String id = (items.isNotEmpty && items[0].payments.isNotEmpty
                ? items[0].payments[0].paymentMethodId
                : null) ??
            PAIEMENTS.firstWhere((item) => item['name'] == "Cash",
                orElse: () => {'id': ''})['id'];

        return PaymentValueDto(paymentMethodId: id, status: key, amount: total);
      }

      return PaymentValueDto(paymentMethodId: "", status: "", amount: 0);
    })
        // .where((element) => element != null)
        .toList();
  }

  Map<String, DateTime> getDatesForComparison() {
    DateTime now = DateTime.now();
    Map<String, DateTime> params = {
      "startDate": now,
      "endDate": now,
    };

    if (selectFiler.value == TrKeysConstant.week) {
      Map<String, DateTime> lastWeekDates = getLastWeekDates();
      params["startDate"] = lastWeekDates["start"]!;
      params["endDate"] = lastWeekDates["end"]!;
    } else if (selectFiler.value == TrKeysConstant.month) {
      // String item = getLastMonths()[selectedMonth.toInt() - 1];
      // comparisonDate.value = item;
      int monthIndex = getCurrentMonth();
      Map<String, DateTime> selectedMonthDates =
          getFirstAndLastDayOfMonth(monthIndex);
      params["startDate"] = selectedMonthDates["start"]!;
      params["endDate"] = selectedMonthDates["end"]!;
      // comparisonDate.value = monthNames[monthIndex - 1];
    } else if (selectFiler.value == TrKeysConstant.day) {
      DateTime newDate = DateTime.parse(dateTimeNow.toIso8601String());

      newDate = newDate.subtract(const Duration(days: 7));

      params["startDate"] = newDate;
      params["endDate"] = newDate;
    }

    return params;
  }

  int getTotalAmount(List<Order> orders) {
    return orders.fold(
        0, (count, item) => count + (item.grandTotal as num).toInt());
  }

  int getIndexFilter() {
    switch (selectFiler.value) {
      case TrKeysConstant.day:
        return 0;
      case TrKeysConstant.week:
        return 1;
      default:
        handleDefaultSelection();
        return 2;
    }
  }

  void handleDaySelection() {
    startDate = dateTimeNow;
    endDate = dateTimeNow;
  }

  void handleWeekSelection() {
    final Map<String, DateTime> currentWeekDates = getCurrentWeekDates();
    final DateTime start = currentWeekDates['start']!;
    final DateTime end = currentWeekDates['end']!;
    startDate = start;
    endDate = end;
    update();
  }

  void handleDefaultSelection() {
    int currentMonth = getCurrentMonth();
    final dateRange = getFirstAndLastDayOfMonth(currentMonth);
    startDate = dateRange['start']!;
    endDate = dateRange['end']!;
  }

  Map<String, DateTime> getCurrentWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate.subtract(Duration(days: dayOfWeek - 1));
    DateTime endOfWeek = currentDate.add(Duration(days: 7 - dayOfWeek));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  int getCurrentMonth() {
    int currentMonth = dateTimeNow.month;
    return currentMonth - 1;
  }

  Map<String, DateTime> getLastWeekDates() {
    DateTime currentDate = DateTime.now();
    int dayOfWeek = currentDate.weekday;

    DateTime startOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 7 - (dayOfWeek == 7 ? 0 : 1)));
    DateTime endOfWeek = currentDate
        .subtract(Duration(days: dayOfWeek + 1 - (dayOfWeek == 7 ? 0 : 1)));

    return {"start": startOfWeek, "end": endOfWeek};
  }

  Map<String, DateTime> getFirstAndLastDayOfMonth(int monthIndex) {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    DateTime firstDay = DateTime(currentYear, monthIndex + 1, 1);
    DateTime lastDay = DateTime(currentYear, monthIndex + 2, 0);

    return {"start": firstDay, "end": lastDay};
  }

  void eventFilter({int indexFilter = 0, required String status}) {
    try {
      switch (indexFilter) {
        case 0:
          Mixpanel.instance.track('Dashboard Reports filter',
              properties: {"Periode used": "Day", "Status": status});
          break;
        case 1:
          Mixpanel.instance.track('Dashboard Reports filter',
              properties: {"Periode used": "Week", "Status": status});
          break;
        default:
          Mixpanel.instance.track('Dashboard Reports filter',
              properties: {"Periode used": "Month", "Status": status});
      }
    } catch (e) {
      print("Mixpanel error : $e");
    }
  }
}
