import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/home/home.controller.dart';

class ChartBarComponent extends StatefulWidget {
  const ChartBarComponent({super.key});

  @override
  State<ChartBarComponent> createState() => _ChartBarComponentState();
}

class _ChartBarComponentState extends State<ChartBarComponent> {
  final HomeController _incomePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 233,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Style.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 30,
          left: 30,
          top: 0.2,
          bottom: 2,
        ),
        child: SizedBox(
          width: (size.width - 20),
          height: 160,
          child: Obx(() => _incomePageController.isFetching.isFalse &&
                  _incomePageController.orders.isNotEmpty
              ? LineChart(
                  mainData(_incomePageController.orders,
                      _incomePageController.viewSelected.value),
                )
              : const SizedBox()),
        ),
      ),
    );
  }

  LineChartData mainData(List<OrdersDataEntity> orders, String viewSelected) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = Style.interNormal(color: Style.white, size: 10);
              return LineTooltipItem(
                  "${NumberFormat("#,##0", "fr_FR").format(touchedSpot.y)} F",
                  textStyle);
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            if (spot.x == 0 || spot.x == 6) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                color: Style.brandColor500,
                strokeWidth: 4,
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  if (index.isEven) {
                    return FlDotCirclePainter(
                      radius: 8,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: Style.brandColor500,
                    );
                  } else {
                    return FlDotSquarePainter(
                      size: 16,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: Style.brandColor500,
                    );
                  }
                },
              ),
            );
          }).toList();
        },
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Style.black,
            strokeWidth: 0.6,
            dashArray: [3, 3],
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Style.primaryColor,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Style.brandColor500),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 0.5,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              return bottomTitleWidgets(value, meta, orders, viewSelected);
            },
          ),
        ),
      ),
      minX: 0,
      maxX: getMaxItemChart(orders, viewSelected)?.toDouble() ?? 0,
      minY: getMinYChart(orders, viewSelected)?.toDouble() ?? 0.0,
      maxY: getMaxYChart(orders, viewSelected)?.toDouble(),
      lineBarsData: getFlatSpot(orders, viewSelected),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta,
      List<OrdersDataEntity> orders, String viewSelected) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: getTextChart(orders, value, viewSelected),
    );
  }
}
