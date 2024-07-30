import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.controller.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/sale_report_date_or_time.component.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/user_or_restaurant_informations.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom_with_icon.button.dart';

class TopSaleReportResultComponent extends StatelessWidget {
  final SalesReportsController salesReportController;
  const TopSaleReportResultComponent(
      {super.key, required this.salesReportController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UserOrRestaurantInformationComponent(
                restaurantName: salesReportController.restaurant!.name,
                contactPhone: salesReportController.restaurant!.phone,
                userName:
                    "${salesReportController.user!.lastname} ${salesReportController.user!.firstname}",
              ),
            ),
            2.horizontalSpace,
            CustomButtonWithIcon(
              textColor: Style.brandColor500,
              svgColor: Style.brandColor500,
              background: Style.brandColor50.withOpacity(.3),
              title: "Période",
              imagePath: "assets/svgs/calendar-1.svg",
              onPressed: () async {
                Get.defaultDialog(
                    title: "",
                    contentPadding: EdgeInsets.symmetric(horizontal: 24),
                    content: Column(
                      children: [
                        SalesReportDateAndTimeSelectionComponent(
                          isGrey: true,
                          beginOrEndTitle: 'Début',
                          dateController: salesReportController
                              .getTextEditingControllerFormatted(
                                  salesReportController.pickStartDate),
                          timeController: salesReportController.pickStartTime,
                        ),
                        24.verticalSpace,
                        SalesReportDateAndTimeSelectionComponent(
                          isGrey: true,
                          beginOrEndTitle: 'Fin',
                          dateController: salesReportController
                              .getTextEditingControllerFormatted(
                                  salesReportController.pickEndDate),
                          timeController: salesReportController.pickEndTime,
                        ),
                        37.verticalSpace,
                        CustomButton(
                            title: "Modifier la période",
                            textColor: Style.white,
                            background: Style.brandColor500,
                            radius: 4,
                            onPressed: () {
                              Get.close(2);
                            })
                      ],
                    ));
              },
            )
          ],
        ),
        36.verticalSpace,
        TotalReportSaleComponent(
          totalAmount: salesReportController
              .calculateTotalTurnOver(salesReportController.sales),
        ),
      ],
    );
  }
}

class TotalReportSaleComponent extends StatelessWidget {
  final int totalAmount;
  const TotalReportSaleComponent({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: Style.linearGradientBlue,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(colors: Style.gradientPlat)),
            child: const Text("Total vente"),
          ),
          const Spacer(),
          Text(
            "$totalAmount".currencyLong(),
            style: Style.interBold(size: 20, color: Style.brandColor50),
          ),
        ],
      ),
    );
  }
}
