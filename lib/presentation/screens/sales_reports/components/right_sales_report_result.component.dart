import 'dart:developer';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart' as taj;
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/extral_sale.extension.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.controller.dart';

class BottomSalesReportResultComponent extends StatefulWidget {
  final List<taj.SaleItem> data;
  const BottomSalesReportResultComponent({super.key, required this.data});

  @override
  State<BottomSalesReportResultComponent> createState() =>
      _BottomSalesReportResultComponentState();
}

class _BottomSalesReportResultComponentState
    extends State<BottomSalesReportResultComponent> {
  var swithValue = 0;

  final listCategorieFilter = [
    "Accompagnement",
    "Boisson",
    "Cuisine",
    "Divers",
    "Balance par serveur"
  ];

  getCollectionIdCategorieBySwitchValue() {
    switch (swithValue) {
      case 0:
        return "";
      case 1:
        return DRINKSID;
      case 2:
        return DISHESID;
      case 3:
        return DIVERSID;
      default:
        return "";
    }
  }

  changedSwitch(int value) {
    swithValue = value;
    setState(() {});
  }

  @override
  void initState() {
    final e = widget.data.map((e) => e.toJson()).toList();
    log("---------$e");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesReportsController>(builder: (saleReportController) {
      return Expanded(
        flex: 4,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CustomSlidingSegmentedControl<int>(
                initialValue: swithValue,
                customSegmentSettings: CustomSegmentSettings(
                  radius: 64,
                  borderRadius: BorderRadius.circular(64),
                ),
                children: {
                  for (var categorie in listCategorieFilter)
                    listCategorieFilter.indexOf(categorie): Center(
                      child: Text(
                        categorie,
                        style: (swithValue ==
                                listCategorieFilter.indexOf(categorie))
                            ? Style.interBold(color: Style.white, size: 14)
                            : Style.interNormal(size: 14),
                      ),
                    )
                },
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    64,
                  ),
                ),
                thumbDecoration: BoxDecoration(
                  color: Style.brandColor500,
                  borderRadius: BorderRadius.circular(40),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear,
                onValueChanged: changedSwitch,
              ),
            ),
            27.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: swithValue != (listCategorieFilter.length - 1)
                      ? Builder(builder: (context) {
                          List<taj.SaleItem> currentSalesData = swithValue == 0
                              ? saleReportController.extraSales
                                  .map((element) => element.toSaleItem())
                                  .toList()
                              : saleReportController.filterSalesDataByMainCatId(
                                  widget.data,
                                  getCollectionIdCategorieBySwitchValue(),
                                );

                          print(currentSalesData);
                          return CustomReportTable(
                            showTotal: true,
                            salesDataList: currentSalesData
                                .map((e) => {
                                      "productName": e.itemName,
                                      "quantity": e.qty,
                                      "totalPrice": e.totalAmount,
                                    })
                                .toList(),
                            totalQty: saleReportController
                                .calculateTotalQuantity(currentSalesData),
                            totalTurnOver: saleReportController
                                .calculateTotalTurnOver(currentSalesData),
                          );
                        })
                      : Builder(builder: (context) {
                          final salesDataList = saleReportController
                              .generateWaitressReport(widget.data)
                              .values
                              .toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                salesDataList.length,
                                (index) {
                                  final element = salesDataList[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Tooltip(
                                        message: element.waitressName == null
                                            ? "Id Serveur ${element.waitressId}"
                                            : "Serveur ${element.waitressName}",
                                        child: Text(
                                          element.waitressName ??
                                              "Serveur non trouvé",
                                          style: Style.interBold(size: 16),
                                        ),
                                      ),
                                      7.verticalSpace,
                                      CustomReportTable(
                                        salesDataList: element.salesDetails,
                                        showTotal: index ==
                                            saleReportController
                                                    .generateWaitressReport(
                                                        widget.data)
                                                    .values
                                                    .toList()
                                                    .length -
                                                1,
                                        totalQty: saleReportController
                                            .calculeQuantityForSaleByWaitress(
                                                salesDataList),
                                        totalTurnOver: saleReportController
                                            .calculeTurnOverForSaleByWaitress(
                                                salesDataList),
                                      ),
                                      27.verticalSpace,
                                    ],
                                  );
                                },
                              )
                            ],
                          );
                        }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CustomReportTable extends StatelessWidget {
  final bool showTotal;
  final List<Map<String, dynamic>> salesDataList;
  final int? totalQty;
  final int? totalTurnOver;
  const CustomReportTable({
    super.key,
    this.showTotal = false,
    required this.salesDataList,
    this.totalQty,
    this.totalTurnOver,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        1: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        getHeaderSaleReportTable(),
        ...List.generate(
          salesDataList.length,
          (index) {
            final element = salesDataList[index];
            return getBodySaleReportTable(
                id: "${index + 1}",
                name: element["productName"] ?? "",
                quantity: element["quantity"].toString(),
                turnOver: element["totalPrice"].toString(),
                isEven: !index.isEven);
          },
        ),
        if (showTotal) getEmptySaleReportTable(),
        if (showTotal)
          getFooterSaleReportTable(
              quantity: totalQty.toString(),
              turnOver: totalTurnOver.toString()),
      ],
    );
  }
}

TableRow getHeaderSaleReportTable() {
  return getBodySaleReportTable(
    id: "ID",
    name: "Désignation",
    quantity: "Quantité",
    turnOver: "Chiffre d’affaires (en F CFA)",
    isHeader: true,
  );
}

TableRow getEmptySaleReportTable() {
  const padding = 10.0;
  return TableRow(
    children: List.generate(
      4,
      (index) => const TableCell(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(""),
        ),
      ),
    ),
  );
}

TableRow getBodySaleReportTable({
  required String id,
  required String name,
  required String quantity,
  required String turnOver,
  bool? isHeader = false,
  bool? isEven = false,
}) {
  const padding = 10.0;
  return TableRow(
    decoration: isHeader!
        ? const BoxDecoration(color: Style.grey200)
        : BoxDecoration(
            color: isEven! ? Style.grey50 : null,
            border: const DashedBorder.symmetric(
              horizontal: BorderSide(
                color: Style.grey500,
                width: .25,
              ),
              dashLength: 3,
            ),
          ),
    children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            id,
            style: isHeader ? Style.interBold(size: 12) : null,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            name,
            style: isHeader ? Style.interBold(size: 12) : null,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            quantity,
            textAlign: TextAlign.center,
            style: isHeader ? Style.interBold(size: 12) : null,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            turnOver,
            style: isHeader ? Style.interBold(size: 12) : null,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    ],
  );
}

TableRow getFooterSaleReportTable({
  required String quantity,
  required String turnOver,
}) {
  const padding = 10.0;
  return TableRow(
    decoration: const BoxDecoration(color: Style.grey500),
    children: [
      const TableCell(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            "",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            "Total",
            style: Style.interBold(size: 14, color: Colors.white),
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            quantity,
            textAlign: TextAlign.center,
            style: Style.interBold(size: 14, color: Colors.white),
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            turnOver,
            textAlign: TextAlign.end,
            style: Style.interBold(size: 14, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

class ModelBalancePerServer {
  final String? waitressName;
  final String? waitressId;

  final List<Map<String, dynamic>> salesDetails;

  ModelBalancePerServer(
      {required this.waitressName,
      required this.salesDetails,
      this.waitressId});
}
