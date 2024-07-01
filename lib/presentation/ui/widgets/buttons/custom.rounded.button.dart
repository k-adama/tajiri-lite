import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CustomRoundedButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Widget? asset;

  const CustomRoundedButton({
    super.key,
    this.onTap,
    required this.title,
    this.asset,
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
            Text(
              title,
              style: Style.interBold(),
            ),
            if (asset != null) ...[
              10.horizontalSpace,
              asset!,
            ],
          ],
        ),
      ),
    );
  }
}
