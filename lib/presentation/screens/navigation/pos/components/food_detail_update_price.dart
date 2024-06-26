import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/add_or_remove_food_detail_modal_quantity.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/food_detail_formField.component.dart';

class FoodDetailUpdatePrice extends StatefulWidget {
  const FoodDetailUpdatePrice({super.key});

  @override
  State<FoodDetailUpdatePrice> createState() => _FoodDetailUpdatePriceState();
}

class _FoodDetailUpdatePriceState extends State<FoodDetailUpdatePrice> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Côte de porc",
              style: Style.interBold(size: 20, color: Style.brandBlue950),
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
                  hint: '15000',
                  //widget.product?.price.toString(),
                ),
                AddOrRemoveFoodDteailModalQauntityComponent(
                  add: () {},
                  remove: () {},
                  text: '1',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
