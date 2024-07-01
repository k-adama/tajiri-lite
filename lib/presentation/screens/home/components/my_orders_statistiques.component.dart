import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class MyOrdersStatistiquesComponent extends StatelessWidget {
  final String asset;
  final String title;
  final int value;
  const MyOrdersStatistiquesComponent(
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
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Style.brandBlue50,
              ),
              child: Center(
                child: SvgPicture.asset(asset),
              ),
            ),
            14.verticalSpace,
            Text(title),
            14.verticalSpace,
             Text(
              '$value',
              style: GoogleFonts.inter(
                  fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
           
          ],
        ),
      ),
    );
  }
}
