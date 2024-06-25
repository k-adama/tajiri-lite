import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CustomRoundedButton extends StatelessWidget {
  final Function()? onTap;
  const CustomRoundedButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nouvelle Commande',
              style: Style.interBold(),
            ),
            10.horizontalSpace,
            Image.asset('assets/images/mage_edit-pen-fill.png'),
          ],
        ),
      ),
    );
  }
}
