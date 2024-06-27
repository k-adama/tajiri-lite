import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/add_or_remove.button.dart';

class FoodDetailUpdateQuantityComponent extends StatelessWidget {
  final int qty;
  final VoidCallback add;
  final VoidCallback remove;
  final double sizeButton;
  final double iconsize;
  const FoodDetailUpdateQuantityComponent(
      {super.key,
      required this.add,
      required this.remove,
      required this.qty,
      this.sizeButton = 30,
      this.iconsize = 24});

  @override
  Widget build(BuildContext context) {
    final qtyIsZero = qty == 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        //color: Style.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: qtyIsZero ? .3 : 1,
            child: AddOrRemoveButton(
              onTap: qtyIsZero ? null : remove,
              iconData: Icons.remove,
              sizeButton: sizeButton,
              iconsize: iconsize,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              qty.toString(),
              style: Style.interBold(
                size: 14,
                color: Style.black,
              ),
            ),
          ),
          AddOrRemoveButton(
            onTap: add,
            iconData: Icons.add,
            sizeButton: sizeButton,
            iconsize: iconsize,
          ),
        ],
      ),
    );
  }
}
