import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';

class CartItemRowComponent extends StatelessWidget {
  final HomeController dashboardController;
  const CartItemRowComponent({super.key, required this.dashboardController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              width: 300,
              margin: const EdgeInsets.only(right: 12),
              child: CartItemComponent(
                value: 0,
                asset: index == 0
                    ? 'assets/svgs/revenue.svg'
                    : 'assets/svgs/dashboard_order.svg',
                title: index == 0
                    ? AppHelpersCommon.getTranslation(TrKeysConstant.revenue)
                    : "Nombre de Commandes",
                valuePercent: 50,
                isNumber: index != 0,
              ),
            );
            /* Row(
        children: [
          Expanded(
            child: CartItemComponent(
              value: 0,
              //dashboardController.totalAmount.value.toDouble(),
              asset: 'assets/svgs/revenue.svg',
              title: AppHelpersCommon.getTranslation(TrKeysConstant.revenue),
              valuePercent: 50,
              /*dashboardController.percentRevenueComparaison.value.isFinite
                      ? dashboardController.percentRevenueComparaison.value
                          .floor()
                          .toDouble()
                      : dashboardController.percentRevenueComparaison.value,*/
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: CartItemComponent(
              value: 0,
              //dashboardController.totalOrders.value.toDouble(),
              isNumber: true,
              asset: 'assets/svgs/dashboard_order.svg',
              title: "Nombre total de Commandes",
              valuePercent: 50,
              /*dashboardController.percentNbrOrderComparaison.value.isFinite
                      ? dashboardController.percentNbrOrderComparaison.value
                          .floor()
                          .toDouble()
                      : dashboardController.percentNbrOrderComparaison.value,*/
            ),
          ),
        ],
      );*/
          }),
    );
  }
}

class CartItemComponent extends StatelessWidget {
  final double valuePercent;
  final String title;
  final double value;
  final bool isNumber;

  final String asset;

  const CartItemComponent(
      {super.key,
      required this.valuePercent,
      required this.title,
      required this.value,
      required this.asset,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Style.white,
          ),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
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
              13.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Style.grey700,
                    ),
                  ),
                  Text(
                    isNumber
                        ? formatNumber(value)
                        : intl.NumberFormat.currency(
                                locale: 'fr_FR',
                                symbol: 'FCFA',
                                decimalDigits: 0)
                            .format(value),
                    style: GoogleFonts.inter(
                        fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                valuePercent > 0
                    ? Icon(
                        Icons.arrow_drop_up_outlined,
                        color: Style.green,
                        size: 20.r,
                      )
                    : Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Style.red,
                        size: 20.r,
                      ),
                4.horizontalSpace,
                Text(
                  "${valuePercent > 0 ? "+" : ""}$valuePercent%",
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Style.black,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
