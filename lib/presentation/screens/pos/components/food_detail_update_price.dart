import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/fooddetail_update_quantity.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/food_detail_formField.component.dart';

class FoodDetailUpdatePrice extends StatefulWidget {
  final Product? product;
  const FoodDetailUpdatePrice({
    super.key,
    this.product,
  });

  @override
  State<FoodDetailUpdatePrice> createState() => _FoodDetailUpdatePriceState();
}

class _FoodDetailUpdatePriceState extends State<FoodDetailUpdatePrice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(builder: (posController) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.product?.name}',
              style: Style.interBold(size: 18, color: Style.brandBlue950),
            ),
            Text(
              "En cas de besoin modifiez manuellement le prix du produit.",
              style: Style.interNormal(size: 10, color: Style.grey500),
            ),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FoodDetailFormField(
                  hint: posController.priceAddFood.value != 0
                      ? posController.priceAddFood.toString()
                      : widget.product?.price.toString(),
                  onChanged: (String value) {
                    posController.setPriceAddFood(int.tryParse(value) ?? 0);
                  },
                ),
                FoodDetailUpdateQuantityComponent(
                  add: () {
                    print(posController.priceAddFood);
                    posController.setIncrementQuantityAddFood(widget.product);
                  },
                  iconsize: 20,
                  remove: posController.quantityAddFood == 1
                      ? () {}
                      : () {
                          posController
                              .setDecrementQuantityAddFood(widget.product);
                        },
                  qty: posController.quantityAddFood,
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
