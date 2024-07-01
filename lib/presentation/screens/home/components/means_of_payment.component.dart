import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class MeansOfPaymentComponent extends StatelessWidget {
  final String asset;
  final String title;
  final int value;
  const MeansOfPaymentComponent(
      {super.key,
      required this.asset,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: Style.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppHelpersCommon.checkIsSvg(asset)
                    ? SvgPicture.asset(
                        asset,
                        width: 30,
                        height: 30,
                      )
                    : Image.asset(asset),
                5.horizontalSpace,
                Text(title),
              ],
            ),
            14.verticalSpace,
            Text(
              intl.NumberFormat.currency(
                      locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0)
                  .format(value),
              style: GoogleFonts.inter(
                  fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
