import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/staff.extension.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/right_sales_report_result.component.dart';

class SalesReportsController extends GetxController {
  TextEditingController pickStartDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickEndDate = TextEditingController(
      text: customFormatForRequest.format(DateTime.now()));
  TextEditingController pickStartTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  TextEditingController pickEndTime =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));

  RxList<SaleItem> sales = List<SaleItem>.empty().obs;
  RxList<ExtraSale> extraSales = List<ExtraSale>.empty().obs;

  Staff? get user => AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  String? get restaurantId => user?.restaurantId;

  final tajiriSdk = TajiriSDK.instance;

  bool isLoadingReport = false;
  bool isLoadingYesterdayReport = false;

  final total = 0.obs;

//Categorie Supabase
  final mainCategories = List<MainCategory>.empty().obs;
  List<Waitress> waitresses = List<Waitress>.empty().obs;

  // final data = generateFakeSalesDataList(); // fake SalesDataEntity

  @override
  onReady() async {
    await Future.wait([
      fetchMainCategories(),
      fetchWaitresses(),
    ]);
    super.onReady();
  }

  Future<void> fetchOrdersReports({bool isYesterday = false}) async {
    final startDate = "${pickStartDate.text} ${pickStartTime.text}";
    final endDate = "${pickEndDate.text} ${pickEndTime.text}";
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      if (isYesterday) {
        isLoadingYesterdayReport = true;
      } else {
        isLoadingReport = true;
      }
      update();
      print("======================> startDate $startDate");
      print("======================> endDate $endDate");

      DateTime formattedStartDate = convertToDateTime(startDate);
      DateTime formattedEndDate = convertToDateTime(endDate);

      try {
        final GetOrdersDto dto = GetOrdersDto(
          startDate: formattedStartDate,
          endDate: formattedEndDate,
          ownerId: user?.idOwnerForGetOrder,
        );

        final toJson = dto.toJson();
        print("======================> toJson $toJson");
        SalesReport reportsData = await tajiriSdk.ordersService.getReports(dto);

        for (var element in reportsData.sales) {
          print(
              "======================> element ${element.itemName}  qty : ${element.qty}");
        }

        List<SaleItem> salesData = reportsData.sales;

        List<ExtraSale> extraSaleData = reportsData.extraSales;
        total.value = reportsData.total.toInt();
        sales.assignAll(salesData);
        extraSales.assignAll(extraSaleData);

        if (isYesterday) {
          isLoadingYesterdayReport = false;
        } else {
          isLoadingReport = false;
        }
        update();
        Get.toNamed(
          Routes.SALES_REPORT_RESULT,
          arguments: [startDate, endDate],
        );
      } catch (e) {
        print("==========================> error $e");
        if (isYesterday) {
          isLoadingYesterdayReport = false;
        } else {
          isLoadingReport = false;
        }
        update();
      }
    }
  }

  Future<void> fetchMainCategories() async {
    if (restaurantId == null) {
      AppHelpersCommon.showBottomSnackBar(
        Get.context!,
        const Text("Impossible de recuperer l'id du restaurant"),
        const Duration(seconds: 2),
        true,
      );
    }

    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      update();
      try {
        final result =
            await tajiriSdk.mainCategoriesService.getMainCategories();
        mainCategories.assignAll(result);
        update();
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
        update();
      }
    }
  }

  TextEditingController getTextEditingControllerFormatted(
      TextEditingController controller) {
    return TextEditingController(
      text: convertTofrenchDate(controller.text),
    );
  }

  DateTime convertToDateTime(String dateTimeString) {
    List<String> parts = dateTimeString.split(' ');
    if (parts.length < 3) {
      throw const FormatException("Invalid date time format");
    }

    String datePart = parts[0];
    String timePart = parts[2];

    String combinedDateTimeString = "$datePart $timePart:00";

    print("=========+> combinedDateTimeString $combinedDateTimeString");

    DateTime dateTime = DateTime.parse(combinedDateTimeString);
    return dateTime;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Style.secondaryColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return null;
    return picked;
  }

  String? pickDateFormatted(DateTime? pickedDate) {
    if (pickedDate != null) {
      debugPrint('$pickedDate');
      String formattedDate = customFormatForRequest.format(pickedDate);
      debugPrint(formattedDate);

      return formattedDate;
    } else {
      debugPrint("pickedDate is null");
      return null;
    }
  }

  String? pickTimeFormatted(TimeOfDay? timeOfDay) {
    if (timeOfDay != null) {
      DateTime now = DateTime.now();
      DateTime date = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      String formattedTime = DateFormat('HH:mm').format(date);
      debugPrint(formattedTime);

      return formattedTime;
    } else {
      return null;
    }
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    // Locale myLocale = const Locale('fr', 'FR');
    DateTime? pickedDate = await showDatePickerDialog(
      context: context,
      initialDate: DateTime.now(),
      minDate: DateTime(2023),
      maxDate: DateTime(2100),
      width: 400.w,
      height: 400.h,
      currentDate: DateTime.now(),
      selectedDate: DateTime.now(),
      currentDateDecoration: const BoxDecoration(),
      currentDateTextStyle: const TextStyle(),
      daysOfTheWeekTextStyle: const TextStyle(),
      //disbaledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: const TextStyle(),
      enabledCellsDecoration: const BoxDecoration(),
      enabledCellsTextStyle: const TextStyle(),
      initialPickerType: PickerType.days,
      selectedCellDecoration: const BoxDecoration(),
      selectedCellTextStyle: const TextStyle(),
      leadingDateTextStyle: const TextStyle(),
      // slidersColor: Style.brandColor,
      // highlightColor: Style.brandColor,
      // slidersSize: 20,
      // splashColor: Style.brandColor,
      splashRadius: 40,
      centerLeadingDate: true,
    );

    return pickedDate;
  }

  getYesterdayDateRange() {
    print("======getYesterdayDateRange=======");
    final now = DateTime.now();
    final yesterdayStart = DateTime(now.year, now.month, now.day - 1);
    final yesterdayEnd = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
    //
    pickStartDate.text = customFormatForRequest.format(yesterdayStart);
    pickStartTime.text = DateFormat('HH:mm').format(yesterdayStart);

    //
    pickEndDate.text = customFormatForRequest.format(yesterdayEnd);
    pickEndTime.text = DateFormat('HH:mm').format(yesterdayEnd);
  }

  List<SaleItem> filterSalesDataByMainCatId(
      List<SaleItem> salesDataList, String mainCatId) {
    // recuperer les id des categories de supabase liées au plat ou a la boisson (les 2 types de categories present pour l'instant)
    final catSupabase = mainCategories
        .where((cat) => cat.collectionId == mainCatId)
        .map((e) => e.id)
        .toList();
    final res = salesDataList.where((salesData) {
      return catSupabase.contains(salesData.mainCategoryId);
    }).toList();
    return res;
  }

  Map<String, dynamic> getDataForShareReport(List<SaleItem> salesDataList) {
    Map<String, dynamic> result = {};

    final accompaniementSalesdata = transformExtraData(extraSales);
    final drinkSalesdata = transformSalesData(sales, DRINKSID);
    final dishesSalesdata = transformSalesData(sales, DISHESID);
    final diversSalesdata = transformSalesData(sales, DIVERSID);

    final balancePerServer = generateWaitressReport(sales).values.toList();

    result.addAll({
      "Accompagnement": accompaniementSalesdata,
      "Boisson": drinkSalesdata,
      "Cuisine": dishesSalesdata,
      "Divers": diversSalesdata,
      "Balance par serveur": balancePerServer
    });
    return result;
  }

  List<Map<String, dynamic>> transformSalesData(
      List<SaleItem> data, String categoryId) {
    return filterSalesDataByMainCatId(data, categoryId)
        .map((e) => {
              "productName": e.itemName,
              "quantity": e.qty,
              "totalPrice": e.totalAmount,
            })
        .toList();
  }

  List<Map<String, dynamic>> transformExtraData(List<ExtraSale> data) {
    return data
        .map((e) => {
              "productName": e.name,
              "quantity": e.qtySales,
              "totalPrice": 0,
            })
        .toList();
  }

  int calculateTotalQuantity(List<SaleItem> salesDataList) {
    int totalQuantity = 0;
    for (var salesData in salesDataList) {
      totalQuantity += salesData.qty;
    }
    return totalQuantity;
  }

  int calculateTotalTurnOver(List<SaleItem> salesDataList) {
    int totalTurnOver = 0;
    for (var salesData in salesDataList) {
      totalTurnOver += salesData.totalAmount.toInt();
    }
    return totalTurnOver;
  }

  Map<String, ModelBalancePerServer> generateWaitressReport(
      List<SaleItem> salesDataList) {
    Map<String, ModelBalancePerServer> waitressReport = {};

    for (var salesData in salesDataList) {
      for (WaitressSale waitressSale in salesData.waitresses) {
        String waitressId = waitressSale.id;
        String? waitressName = getWaitressNameByOrder(waitressId);
        String productName = salesData.itemName;
        int qtySale = waitressSale.qtySales;
        int totalPriceSale = waitressSale.totalPrice.toInt();

        if (!waitressReport.containsKey(waitressId)) {
          waitressReport[waitressId] = ModelBalancePerServer(
            waitressId: waitressId,
            waitressName: waitressName,
            salesDetails: [],
          );
        }

        waitressReport[waitressId]!.salesDetails.add({
          "productName": productName,
          "quantity": qtySale,
          "totalPrice": totalPriceSale,
        });
      }
    }

    return waitressReport;
  }

  int calculeTurnOverForSaleByWaitress(List<ModelBalancePerServer> data) {
    int total = 0;

    data.forEach((element) {
      element.salesDetails.forEach((sale) {
        total += int.tryParse("${sale["totalPrice"]}") ?? 0;
      });
    });

    return total;
  }

  int calculeQuantityForSaleByWaitress(List<ModelBalancePerServer> data) {
    int qty = 0;

    data.forEach((element) {
      element.salesDetails.forEach((sale) {
        qty += int.tryParse("${sale["quantity"]}") ?? 0;
      });
    });

    return qty;
  }

  String? getWaitressNameByOrder(String? waitressId) {
    try {
      final waitress = waitresses.firstWhere((w) => w.id == waitressId);
      return waitress.name;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchWaitresses() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      try {
        update();
        final result = await tajiriSdk.waitressesService.getWaitresses();
        waitresses.assignAll(result);
        update();
      } catch (e) {
        print("===========================> e $e");
        update();
      }
    }
  }
}
