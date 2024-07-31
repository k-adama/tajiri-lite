import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/sale_report_date_or_time.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

import '../../../app/config/theme/style.theme.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
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
      body: GetBuilder<SalesReportsController>(
        builder: (saleReportsController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        "Choisir une période",
                        style: Style.interBold(
                          size: 16,
                        ),
                      ),
                      Text(
                        'Définissez une plage de date et générez le rapport de vente correspondant.',
                        style:
                            Style.interNormal(size: 12, color: Style.grey600),
                      ),
                      20.verticalSpace,
                      SizedBox(
                        width: Get.width,
                        child: SalesReportDateAndTimeSelectionComponent(
                          beginOrEndTitle: 'Début',
                          dateController: saleReportsController
                              .getTextEditingControllerFormatted(
                                  saleReportsController.pickStartDate),
                          onTap: () async {
                            DateTime? pickedDate =
                                await saleReportsController.pickDate(context);
                            String? startformattedDate = saleReportsController
                                .pickDateFormatted(pickedDate);
                            if (startformattedDate == null) {
                              return;
                            }
                            saleReportsController.pickStartDate.text =
                                startformattedDate;
                            setState(() {});
                          },
                          timeOnTap: () async {
                            TimeOfDay? pickedDateTime =
                                await saleReportsController.pickTime(context);
                            String? startformattedTime = saleReportsController
                                .pickTimeFormatted(pickedDateTime);

                            if (startformattedTime == null) {
                              return;
                            }
                            saleReportsController.pickStartTime.text =
                                startformattedTime;
                          },
                          timeController: saleReportsController.pickStartTime,
                        ),
                      ),
                      32.verticalSpace,
                      SizedBox(
                        width: Get.width,
                        child: SalesReportDateAndTimeSelectionComponent(
                          beginOrEndTitle: 'Fin',
                          dateController: saleReportsController
                              .getTextEditingControllerFormatted(
                                  saleReportsController.pickEndDate),
                          onTap: () async {
                            DateTime? pickedDate =
                                await saleReportsController.pickDate(context);
                            String? endformattedDate = saleReportsController
                                .pickDateFormatted(pickedDate);
                            if (endformattedDate == null) {
                              return;
                            }
                            saleReportsController.pickEndDate.text =
                                endformattedDate;
                            setState(() {});
                          },
                          timeOnTap: () async {
                            TimeOfDay? pickedDateTime =
                                await saleReportsController.pickTime(context);
                            String? endformattedTime = saleReportsController
                                .pickTimeFormatted(pickedDateTime);
                            if (endformattedTime == null) {
                              return;
                            }
                            saleReportsController.pickEndTime.text =
                                endformattedTime;
                          },
                          timeController: saleReportsController.pickEndTime,
                        ),
                      ),
                      40.verticalSpace,
                      Text(
                        "Générer le rapport de la veille",
                        style: Style.interBold(
                          size: 16,
                        ),
                      ),
                      Text(
                        'Générez le rapport des ventes réalisées d’hier à aujourd’hui.',
                        style:
                            Style.interNormal(size: 12, color: Style.grey600),
                      ),
                      20.verticalSpace,
                      CustomButton(
                        title: "Voir le rapport d’hier",
                        textColor: Style.brandColor500,
                        isUnderline: true,
                        isLoading:
                            saleReportsController.isLoadingYesterdayReport,
                        background: Style.brandColor50,
                        radius: 4,
                        onPressed: () {
                          saleReportsController.getYesterdayDateRange();
                          saleReportsController.fetchOrdersReports(
                              isYesterday: true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                  title: "Générer le rapport",
                  textColor: Style.white,
                  background: Style.brandColor500,
                  radius: 4,
                  isLoading: saleReportsController.isLoadingReport,
                  onPressed: () {
                    saleReportsController.fetchOrdersReports();
                  }),
              (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
