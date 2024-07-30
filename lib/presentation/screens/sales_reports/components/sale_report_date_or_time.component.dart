import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/select_date_time_picker.component.dart';

class SalesReportDateAndTimeSelectionComponent extends StatelessWidget {
  final String beginOrEndTitle;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final VoidCallback? onTap;
  final VoidCallback? timeOnTap;
  final bool? isGrey;

  const SalesReportDateAndTimeSelectionComponent({
    super.key,
    required this.beginOrEndTitle,
    required this.dateController,
    this.onTap,
    this.timeOnTap,
    required this.timeController,
    this.isGrey,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.height;

    if (screenWidth >= 700) {
      screenWidth = 100;
    } else if (screenWidth >= 600) {
      screenWidth = 150;
    } else {
      screenWidth = 200;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          beginOrEndTitle,
          style: Style.interBold(
            size: 14,
            color: Style.grey950,
          ),
        ),
        4.verticalSpace,
        Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: .5, color: Style.grey500))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jour",
                          style: Style.interNormal(
                            color: Style.grey600,
                            fontWeight: FontWeight.w400,
                            size: 12,
                          ),
                        ),
                        10.verticalSpace,
                        SelectDateTimePickerComponent(
                          isGrey: isGrey,
                          readonly: true,
                          labelText: "",
                          iconData: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SvgPicture.asset(
                              "assets/svgs/calendar-1.svg",
                              width: 16,
                              height: 16,
                            ),
                          ),
                          dateTimeController: dateController,
                          onTap: onTap,
                        ),
                      ],
                    ),
                  ),
                  15.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Heure",
                          style: Style.interNormal(
                            color: Style.grey600,
                            fontWeight: FontWeight.w400,
                            size: 12,
                          ),
                        ),
                        10.verticalSpace,
                        SelectDateTimePickerComponent(
                          isGrey: isGrey,
                          readonly: true,
                          width: screenWidth.w,
                          labelText: "",
                          iconData: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SvgPicture.asset(
                              "assets/svgs/heures.svg",
                            ),
                          ),
                          dateTimeController: timeController,
                          onTap: timeOnTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
