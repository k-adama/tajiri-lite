import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SaleHeaderComponent extends StatelessWidget {
  final String title;
  final String rigthItemTitle;

  const SaleHeaderComponent(
      {super.key, required this.title, required this.rigthItemTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Style.interBold(size: 19,)),
        20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              rigthItemTitle,
              style: Style.interNormal(
                size: 12,
              ),
            ),
            Text(
              "Nbre de ventes",
              style: Style.interNormal(
                size: 12,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
