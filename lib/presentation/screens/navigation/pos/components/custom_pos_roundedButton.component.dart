import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class customPosRoundedButtonComponent extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const customPosRoundedButtonComponent({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: Style.btnlinearGradiant,
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 8),
              blurRadius: 16.r,
              color: Style.brandBlue950.withOpacity(0.25),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svgs/new_order.svg"),
            5.horizontalSpace,
            Text(
              'Voir le panier',
              style: Style.interBold(),
            ),
            100.horizontalSpace,
            Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Style.brandBlue950),
                child: Text(
                  '1',
                  style: Style.interBold(
                    color: Style.white,
                  ),
                )),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
