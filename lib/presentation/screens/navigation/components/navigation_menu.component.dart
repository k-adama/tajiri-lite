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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFFA800),
                Color(0xFFFFC300),
                Color(0xFFFFC300),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: FloatingActionButton.extended(
            heroTag: 'new order',
            backgroundColor: Style.transparent,
            onPressed: onPressed,
            label: Row(
              children: [
                isPos ? 0.horizontalSpace : 20.horizontalSpace,
                isPos
                    ? SvgPicture.asset("assets/svgs/new_order.svg")
                    : const SizedBox(),
                Text(
                  isPos ? 'Voir le panier' : 'Nouvelle Commande',
                  style: Style.interBold(),
                ),
                isPos ? 30.horizontalSpace : 10.horizontalSpace,
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
                isPos ? 0.horizontalSpace : 20.horizontalSpace,
              ],
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: 'orders historic',
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
