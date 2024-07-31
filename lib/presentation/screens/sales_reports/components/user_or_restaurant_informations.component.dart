import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class UserOrRestaurantInformationComponent extends StatelessWidget {
  final String restaurantName;
  final String contactPhone;
  final String userName;
  const UserOrRestaurantInformationComponent({
    super.key,
    required this.restaurantName,
    required this.contactPhone,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurantName,
          style: Style.interBold(size: 20, color: Style.black),
        ),
        10.verticalSpace,
        Row(
          children: [
            Flexible(
              child: userInformation(
                "${TrKeysConstant.svgPath}ic_round-phone.svg",
                contactPhone,
              ),
            ),
            10.horizontalSpace,
            Flexible(
              child: userInformation(
                "${TrKeysConstant.svgPath}ph_user-fill.svg",
                userName,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget userInformation(String svgPath, String content) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(svgPath),
        5.horizontalSpace,
        Flexible(
          child: Text(
            content,
            // overflow: TextOverflow.ellipsis,
            style: Style.interNormal(size: 14, color: Style.black),
          ),
        ),
      ],
    );
  }
}
