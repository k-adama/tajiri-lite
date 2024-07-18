import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/data/repositories/order_history/order_history.repository.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/payment_method_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';

class HomeController extends GetxController {
  Rx<bool> isFetching = true.obs;
  RxList<OrdersDataEntity> orders = List<OrdersDataEntity>.empty().obs;
  RxList<PaymentMethodDataEntity> paymentsMethodAmount =
      List<PaymentMethodDataEntity>.empty().obs;

  final posController = Get.put(PosController());
  final orderHistoryController = Get.put(OrderHistoryController());

  //
  final OrdersRepository _ordersRepository = OrdersRepository();
  final user = AppHelpersCommon.getUserInLocalStorage();

  static final dateTimeNow = DateTime.now();

  DateTime startDate = DateTime.now().obs.value;
  DateTime endDate = DateTime.now().obs.value;

  Rx<int> ordersPaid = 0.obs;
  Rx<int> ordersSave = 0.obs;

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
  bool get hasWaitressPermission =>
      user?.role == "OWNER";//user?.role?.permissions?[0].dashboardUnique == true;

  @override
  void onInit() {
    super.onInit();
    fetchDataForReports();
    //getCurrentMonth();
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
    final dateFormat = DateFormat("yyyy-MM-dd");
    isFetching.value = true;
    update();

    final params = getDatesForComparison();

    String startDateComparaison = dateFormat.format(params['startDate']!);
    String endDateComparaison = dateFormat.format(params['endDate']!);

    String? ownerId = hasWaitressPermission ? user?.id : null;

    final [ordersResponse, comparaisonOders] = await Future.wait([
      _ordersRepository.getOrders(
          dateFormat.format(startDate), dateFormat.format(endDate), ownerId),
      _ordersRepository.getOrders(
        startDateComparaison,
        endDateComparaison,
        ownerId,
      )
    ]);

    ordersResponse.when(success: (data) {
      final ordersComparaison = comparaisonOders.data != null
          ? (comparaisonOders.data as List<dynamic>)
              .map((item) => OrdersDataEntity.fromJson(item))
              .toList()
          : <OrdersDataEntity>[];

      var ordersData = data != null
          ? (data as List<dynamic>)
              .map((item) => OrdersDataEntity.fromJson(item))
              .toList()
          : <OrdersDataEntity>[];

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
                          ordersComparaison.length ==
                      0
                  ? 1
                  : ordersComparaison.length) *
              100;

      isFetching.value = false;
      update();

      orders.assignAll(ordersData);

      isFetching.value = false;
      update();
      eventFilter(indexFilter: indexFilter, status: "Succes");
    }, failure: (status, _) {
      eventFilter(indexFilter: indexFilter, status: "Failure");
      isFetching.value = false;
      update();
    });
    isFetching.value = false;
    update();
  }

  Map<String, List<OrdersDataEntity>> groupedByPaymentMethod(
      List<OrdersDataEntity> data) {
    Map<String, List<OrdersDataEntity>> result = {};

    for (var item in data) {
      String payment = item.paymentMethod?.name ?? "Cash";

      if (!result.containsKey(payment)) {
        result[payment] = [];
      }

      result[payment]!.add(item);
    }

    return result;
  }

  List<PaymentMethodDataEntity> paymentMethodsData(
      Map<String, List<OrdersDataEntity>> groupedByPaymentMethod) {
    return groupedByPaymentMethod.entries
        .map((MapEntry<String, List<OrdersDataEntity>> entry) {
      String key = entry.key;
      List<OrdersDataEntity> items = entry.value;

      if (key != "Carte bancaire") {
        int total = items.fold(
            0, (count, item) => count + (item.grandTotal as num).toInt());
        dynamic id = items[0].paymentMethod?.id ??
            PAIEMENTS.firstWhere((item) => item['name'] == "Cash",
                orElse: () => {'id': null})['id'];

        return PaymentMethodDataEntity(id: id, name: key, total: total);
      }

      return PaymentMethodDataEntity(id: "", name: "", total: 0);
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

  int getTotalAmount(List<OrdersDataEntity> orders) {
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

    log("Date when jour is select :   $startDate  $endDate");
  }

  void handleWeekSelection() {
    final Map<String, DateTime> currentWeekDates = getCurrentWeekDates();
    final DateTime start = currentWeekDates['start']!;
    final DateTime end = currentWeekDates['end']!;
    startDate = start;
    endDate = end;

    log("Date when semaine is select:   $startDate  $endDate");
    update();
  }

  void handleDefaultSelection() {
    int currentMonth = getCurrentMonth();
    final dateRange = getFirstAndLastDayOfMonth(currentMonth);
    startDate = dateRange['start']!;
    endDate = dateRange['end']!;

    log("Date when mois is select :   $startDate  $endDate");
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
