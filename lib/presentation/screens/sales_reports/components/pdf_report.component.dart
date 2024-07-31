import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/services/api_pdf.service.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/right_sales_report_result.component.dart';

class PdfReportComponent {
  static final user = AppHelpersCommon.getUserInLocalStorage();
  static final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  static Future<File> generate(
      Map<String, dynamic> data, String startDate, String endDate) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                buildAppBar(user),
                SizedBox(height: 29),
                buildHeader(startDate, endDate, user),
                SizedBox(height: 15),
                buildInvoice(data),
                SizedBox(height: 15),
                // buildTotal(total)
              ]),
    );
    return ApiPdfService.saveDocument(name: 'my_order_report.pdf', pdf: pdf);
  }

  static Widget buildAppBar(Staff? user) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Text(restaurant?.name ?? "", style: const TextStyle(fontSize: 14)),
            Text(
              restaurant?.phone ?? "",
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildHeader(String startDate, String endDate, Staff? user) =>
      Container(
        width: double.infinity,
        child: Center(
            child: Column(
          children: [
            information("Date de début: ", startDate),
            information("Date de fin: ", endDate),
            information("Personne : ", "${user?.firstname} ${user?.lastname}"),
          ],
        )),
      );

  static Widget buildInvoice(Map<String, dynamic> data) {
    List<Widget> sections = [];

    data.forEach((category, items) {
      sections.add(
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
      );
      sections.add(SizedBox(height: 10));
      print("-------------items $items------type ${items.runtimeType}----");

      if (items.runtimeType != List<ModelBalancePerServer>) {
        if (items == null) {
          return;
        }
        final section = customReportTablePdf(items);
        sections.addAll(section);

        sections.add(SizedBox(height: 15));
      } else {
        for (var e in items as List<ModelBalancePerServer>) {
          sections.add(
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  e.waitressName ?? "Serveur non trouvé",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );

          final section = customReportTablePdf(e.salesDetails);
          sections.addAll(section);
        }
      }
      sections.add(SizedBox(height: 15));
    });

    return Column(children: sections);
  }

  static List<Widget> customReportTablePdf(
      List<Map<String, dynamic>> salesDetails) {
    var totalqty = 0;
    var totalturnover = 0.0;
    return [
      itemRow(
        isHeader: true,
        name: "Désignation",
        quantity: "Quantité",
        turnOver: "CA",
      ),
      ...List.generate(salesDetails.length, (index) {
        final item = salesDetails[index];
        final qtyItem = int.tryParse("${item['quantity']}") ?? 0;
        final priceItem = num.tryParse("${item['totalPrice']}") ?? 0;

        totalqty += qtyItem;
        totalturnover += priceItem;
        return itemRow(
          isEven: index.isEven,
          name: item['productName'].toString(),
          quantity: qtyItem.toString(),
          turnOver: priceItem.toString(),
        );
      }),
      itemRowFooter(
          name: "Total", quantity: "$totalqty", turnOver: "$totalturnover"),
    ];
  }

  static Widget itemRow({
    required String name,
    required String quantity,
    required String turnOver,
    bool? isHeader = false,
    bool? isEven = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader == true
            ? PdfColors.grey400
            : isEven == true
                ? PdfColors.grey200
                : null,
        border: const Border.symmetric(
          horizontal: BorderSide(
            color: PdfColors.grey200,
            width: .25,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(name, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(quantity, style: const TextStyle(fontSize: 12)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(turnOver, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget itemRowFooter({
    required String name,
    required String quantity,
    required String turnOver,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: PdfColors.grey500,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: PdfColors.grey200,
            width: .25,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                color: PdfColors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(quantity,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(turnOver,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  static Widget information(String title, String body) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
          body,
        )
      ],
    );
  }

  // static Widget buildTotal(int total) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 15.0),
  //     child: Container(
  //       width: double.infinity,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             height: 120,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 totalCommand("Total", total ?? 0, true),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // static Widget totalCommand(String name, int price, bool isBold) {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text("$price".currencyShort(),
  //               style: TextStyle(
  //                   fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
  //         ],
  //       ),
  //       Divider(),
  //     ],
  //   );
  // }
}
