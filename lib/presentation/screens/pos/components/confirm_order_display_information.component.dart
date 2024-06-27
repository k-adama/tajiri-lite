import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class ConfirmOrderDisplayInformationComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget widget;
  const ConfirmOrderDisplayInformationComponent(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Style.brandBlue50.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Style.interBold(
                size: 16.sp,
                color: Style.grey950
              ),
            ),
            Text(
              subTitle,
              style: Style.interNormal(
                size: 10.sp,
                color: Style.grey500
              ),
            ),
            20.verticalSpace,
            widget
          ],
        ),
      ),
    );
  }
}
