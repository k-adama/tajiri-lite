import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/constants/user.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';

import 'dart:ui' as ui;

import 'package:tajiri_waitress/app/services/http.service.dart';
import 'package:tajiri_waitress/app/services/local_storage.service.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppHelpersCommon {
  AppHelpersCommon._();

  static UserEntity? getUserInLocalStorage() {
    final userEncoding = LocalStorageService.instance.get(UserConstant.keyUser);
    if (userEncoding == null) {
      logoutApi();
      return null;
    }
    final user = UserEntity.fromJson(jsonDecode(userEncoding));
    return user;
  }

  static logoutApi() async {
    HttpService server = HttpService();
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      await client.get(
        '/auth/logout/',
      );
      Mixpanel.instance
          .track("Logout", properties: {"Date": DateTime.now().toString()});
      Mixpanel.instance.reset();
      LocalStorageService.instance.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('==> login failure: $e');
    }
  }

  static showBottomSnackBar(BuildContext context, Widget content,
      Duration duration, bool isShowSnackBar) {
    final snackBar = SnackBar(
      content: content,
      backgroundColor: Style.secondaryColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
    );

    if (isShowSnackBar) {
      removeCurrentSnackBar(context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      removeCurrentSnackBar(context);
    }
  }

  static removeCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static bool checkIsSvg(String? url) {
    if (url == null || (url.length) < 3) {
      return false;
    }
    final length = url.length;
    return url.substring(length - 3, length) == 'svg';
  }

  // MODAL

  static Future<dynamic> showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    required bool isDarkMode,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
  }) {
    return showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Style.transparent,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: modal,
      ),
    );
  }

  // CHECH SNACK BAR

  static showCheckTopSnackBarInfoForm(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: text,
      ),
      onTap: onTap,
    );
  }

  static showCheckTopSnackBar(BuildContext context, String text) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: "$text. Please check your credentials and try again",
      ),
    );
  }

  // ALERT DIALOG

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    bool canPop = true,
    bool isTransparent = false,
    double radius = 16,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: isTransparent ? Style.transparent : Style.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius.r),
        ),
      ),
      contentPadding: EdgeInsets.all(20.r),
      iconPadding: EdgeInsets.zero,
      content: PopScope(
        canPop: canPop,
        child: child,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: canPop,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String getTranslation(String trKey) {
    /*    final Map<String, dynamic> translations =
        LocalStorage.instance.getTranslations();
    for (final key in translations.keys) {
      if (trKey == key) {
        return translations[key];
      }
    } */
    return trKey;
  }

  static showCheckTopSnackBarInfo(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: text,
        ),
        onTap: onTap);
  }

  static double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection.ltr for left-to-right text
    )..layout(minWidth: 0, maxWidth: double.infinity);
    if (text.length <= 6) return textPainter.width + 22;
    return textPainter.width + 80;
  }

  static void showAlertVideoDemoDialog({
    required BuildContext context,
    required Widget child,
  }) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: child,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}

getMaxItemChart(List<OrdersDataEntity> orders, String viewSelected) {
  final List<Map<String, dynamic>> ordersForChart =
      getReportChart(orders, viewSelected);

  return ordersForChart.length - 1;
}

getMaxYChart(List<OrdersDataEntity> orders, String viewSelected) {
  final List<Map<String, dynamic>> ordersForChart =
      getReportChart(orders, viewSelected);
  double maxY = ordersForChart
      .map((entry) => entry['y'].toDouble())
      .reduce((max, current) => max > current ? max : current);

  return maxY + 10.0;
}

getReportChart(List<OrdersDataEntity> orders, String viewSelected) {
  List<Map<String, dynamic>> ordersForChart;

  if (viewSelected == TrKeysConstant.day) {
    Map<int, Map<String, dynamic>> ordersByHours = orders.fold(
      {},
      (Map<int, Map<String, dynamic>> acc, OrdersDataEntity order) {
        DateTime createdAt = DateTime.parse(order.createdAt!);

        int hour = createdAt.hour;

        acc[hour] = acc[hour] ?? {"count": 0, "grandTotal": 0};
        acc[hour]?["count"]++;
        acc[hour]?["grandTotal"] += order.grandTotal;

        return acc;
      },
    );

    ordersForChart = ordersByHours.entries.map(
      (MapEntry<int, Map<String, dynamic>> entry) {
        int hour = entry.key;
        int grandTotal = entry.value["grandTotal"];
        return {"x": "${hour}:00", "y": grandTotal};
      },
    ).toList();
    ordersForChart.sort((a, b) {
      final int hourA = int.parse(a['x'].split(':')[0]);
      final int hourB = int.parse(b['x'].split(':')[0]);
      return hourA.compareTo(hourB);
    });
  } else {
    Map<String, Map<String, dynamic>> ordersByTime = {
      "x": {"time": "0", "total": 45},
    };
    if (viewSelected == TrKeysConstant.week) {
      ordersByTime = calculateTotalSalesByDayOfWeek(orders);
    } else if (viewSelected == TrKeysConstant.month) {
      ordersByTime = calculateClassAndGrandTotalByWeek(orders);
      List<String> sortedKeys = ordersByTime.keys.toList()..sort();
      Map<String, Map<String, dynamic>> sortedData = {};
      for (String key in sortedKeys) {
        sortedData[key] = ordersByTime[key]!;
      }

      ordersByTime = sortedData;
    }
    ordersForChart = ordersByTime.entries.map((entry) {
      return {"x": entry.key, "y": entry.value["grandTotal"]};
    }).toList();
  }

  return ordersForChart;
}

Map<String, Map<String, dynamic>> calculateTotalSalesByDayOfWeek(
    List<OrdersDataEntity> orders) {
  Map<String, Map<String, dynamic>> dayOfWeekTotals = {
    "lun": {"grandTotal": 0},
    "mar": {"grandTotal": 0},
    "mer": {"grandTotal": 0},
    "jeu": {"grandTotal": 0},
    "ven": {"grandTotal": 0},
    "sam": {"grandTotal": 0},
    "dim": {"grandTotal": 0},
  };

  List<String> days = ["lun", "mar", "mer", "jeu", "ven", "sam", "dim"];

  for (OrdersDataEntity order in orders) {
    DateTime createdAtDate = DateTime.parse(order.createdAt!);
    String dayOfWeek = days[createdAtDate.weekday - 1];

    if (dayOfWeekTotals.containsKey(dayOfWeek)) {
      dayOfWeekTotals[dayOfWeek]!["grandTotal"] += order.grandTotal;
    }
  }

  return dayOfWeekTotals;
}

Map<String, Map<String, dynamic>> calculateClassAndGrandTotalByWeek(
    List<OrdersDataEntity> orders) {
  Map<String, Map<String, dynamic>> result = {};

  for (OrdersDataEntity order in orders) {
    DateTime createdAt = DateTime.parse(order.createdAt!);
    String weekNumber =
        'S ${getWeekNumber(createdAt).toString()}'; // Function to get the week number
    int grandTotal = order.grandTotal!;

    if (!result.containsKey(weekNumber)) {
      result[weekNumber] = {
        "grandTotal": grandTotal,
      };
    } else {
      result[weekNumber]!["grandTotal"] += grandTotal;
    }
  }

  return result;
}

int getWeekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  const millisecondsInWeek = 604800000;
  return ((date.millisecondsSinceEpoch -
              firstDayOfYear.millisecondsSinceEpoch +
              1) /
          millisecondsInWeek)
      .ceil();
}

getMinYChart(List<OrdersDataEntity> orders, String viewSelected) {
  final List<Map<String, dynamic>> ordersForChart =
      getReportChart(orders, viewSelected);
  double minY = ordersForChart
      .map((entry) => entry['y'].toDouble())
      .reduce((min, current) => min < current ? min : current);

  return minY;
}

getTextChart(List<OrdersDataEntity> orders, double value, String viewSelected) {
  final List<Map<String, dynamic>> ordersForChart =
      getReportChart(orders, viewSelected);
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  if (value >= 0 && value < ordersForChart.length) {
    return Text(ordersForChart[value.toInt()]['x'], style: style);
  }
  return const Text("error", style: style);
}

List<LineChartBarData> getFlatSpot(
    List<OrdersDataEntity> orders, String viewSelected) {
  final List<Map<String, dynamic>> ordersForChart =
      getReportChart(orders, viewSelected);
  List<Color> gradientColors = [
    Style.brandColor500.withOpacity(.3),
    Style.brandColor500.withOpacity(.1),
  ];

  final List<DataPoint> dataPoints = ordersForChart.map((item) {
    int index = ordersForChart.indexOf(item);

    return DataPoint(index.toDouble(), (item["y"] as int).toDouble());
  }).toList();

  final List<FlSpot> flSpots = dataPoints.map((dataPoint) {
    return FlSpot(dataPoint.x, dataPoint.y);
  }).toList();

  List<LineChartBarData> lineChartBarData = [
    LineChartBarData(
      color: Style.brandColor500,
      isCurved: false,
      spots: flSpots,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
    ),
  ];
  debugPrint(ordersForChart.toString());
  return lineChartBarData;
}
