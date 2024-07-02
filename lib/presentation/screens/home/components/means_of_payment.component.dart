import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class MeansOfPaymentComponent extends StatelessWidget {
  final Map<String, dynamic> meansOfpayment;
  final int value;
  const MeansOfPaymentComponent(
      {super.key, required this.value, required this.meansOfpayment});

  @override
  Widget build(BuildContext context) {
    final asset = meansOfpayment['icon'];
    final title = meansOfpayment['name'];
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
                        width: 32,
                        height: 32,
                      )
                    : Image.asset(
                        asset,
                        width: 32,
                        height: 32,
                      ),
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
