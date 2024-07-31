import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/services/api_pdf.service.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/left_sales_report_result.component.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/pdf_report.component.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/right_sales_report_result.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom_with_icon.button.dart';

class SaleReportsResultScreen extends StatelessWidget {
  const SaleReportsResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Rapport de vente",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body:
          GetBuilder<SalesReportsController>(builder: (salesReportController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              TopSaleReportResultComponent(
                salesReportController: salesReportController,
              ),
              16.verticalSpace,
              BottomSalesReportResultComponent(
                data: salesReportController.sales,
              ),
              16.verticalSpace,
              CustomButtonWithIcon(
                textColor: Style.brandColor500,
                background: Style.brandColor50.withOpacity(.3),
                title: "Partager le rapport",
                imagePath: "assets/svgs/share.svg",
                onPressed: () async {
                  final pdfFile = await PdfReportComponent.generate(
                      salesReportController
                          .getDataForShareReport(salesReportController.sales),
                      salesReportController.startDate,
                      salesReportController.endDate);
                  ApiPdfService.shareFile(pdfFile);
                },
              ),
              (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
            ],
          ),
        );
      }),
    );
  }
}
