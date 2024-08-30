import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

extension InfoCardExtension on Widget {
  Widget infoCardBg() {
    return Container(
      decoration: BoxDecoration(
          color: Style.brandYellow50,
          border: Border.all(
            color: Style.brandYellow500,
          ),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/svgs/info.svg"),
          const SizedBox(width: 8),
          Expanded(
            child: this,
          ),
        ],
      ),
    );
  }
}
