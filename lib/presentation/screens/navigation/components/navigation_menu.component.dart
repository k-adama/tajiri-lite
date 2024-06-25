import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class NavigationMenuComponent extends StatelessWidget {
  final bool isPos;
  final Function()? onPressed;
  final Function()? OrdersOnPressed;
  const NavigationMenuComponent(
      {super.key, this.isPos = false, this.onPressed, this.OrdersOnPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          //width: 320,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFA800),
                Color(0xFFFFA800),
                Color(0xFFFFC300),
              ],
            ),
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
            /* heroTag: 'new order',
            backgroundColor: Colors.transparent,*/
            onPressed: onPressed,
            child: Row(
              children: [
                isPos ? 5.horizontalSpace : 60.horizontalSpace,
                isPos
                    ? SvgPicture.asset("assets/svgs/new_order.svg")
                    : const SizedBox(),
                isPos ? 5.horizontalSpace : 0.horizontalSpace,
                Text(
                  isPos ? 'Voir le panier' : 'Nouvelle Commande',
                  style: Style.interBold(),
                ),
                isPos ? 100.horizontalSpace : 10.horizontalSpace,
                isPos
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Style.brandBlue950),
                        child: Text(
                          "1",
                          style: Style.interBold(
                            color: Style.white,
                          ),
                        ))
                    : Image.asset('assets/images/mage_edit-pen-fill.png'),
                isPos ? 10.horizontalSpace : 60.horizontalSpace,
              ],
            ),
          ),
        ),
        10.horizontalSpace,
        FloatingActionButton(
          backgroundColor: Style.brandBlue950,
          onPressed: OrdersOnPressed,
          child: Image.asset(
              'assets/images/icon-park-solid_transaction-order.png'),
        ),
      ],
    );
    ;
  }
}
