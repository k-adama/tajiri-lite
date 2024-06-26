import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class PosButtonComponent extends StatelessWidget {
  final Function()? onTap;
  const PosButtonComponent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
      child: RawMaterialButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/svgs/new_order.svg"),
                5.horizontalSpace,
                Text(
                  'Voir le panier',
                  style: Style.interBold(),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Style.brandBlue950),
              child: Text(
                "1",
                style: Style.interBold(
                  color: Style.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
