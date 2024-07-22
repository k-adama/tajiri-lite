import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/select_dish_food.component.dart';

class SideDishFoodListComponent extends StatefulWidget {
  final Product productData;
  final Product? product;
  final List<Product> dishes;
  const SideDishFoodListComponent({
    super.key,
    required this.product,
    required this.dishes,
    required this.productData,
  });

  @override
  State<SideDishFoodListComponent> createState() =>
      _SideDishFoodListComponentState();
}

class _SideDishFoodListComponentState extends State<SideDishFoodListComponent> {
  final posController = Get.find<PosController>();
  List<String?> disheSelected = [];

  @override
  void initState() {
    /* setState(() {
      if (widget.initSelectDish != null) {
        disheSelected = widget.initSelectDish!;
      }
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accompagnement & garniture",
            style: Style.interBold(size: 14, color: Style.brandBlue950),
          ),
          Text(
            "Veuillez sélectionner une cuisson",
            style: Style.interNormal(size: 10, color: Style.grey500),
          ),
          5.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dishes.length,
            itemBuilder: (context, index) {
              final sideDishFood = widget.dishes[index];
              final sidDishFoodEntity = SideDishFoodEntity(
                sideDish: SideDishEntity(
                    id: sideDishFood.id,
                    name: sideDishFood.name,
                    price: sideDishFood.price),
              );

              final qty = posController.getSideDishAddQuantity(sideDishFood.id);

              return SelectDishFoodComponent(
                dishFoodName: sideDishFood.name,
                add: () {
                  posController.setIncrementSideDish(
                    sidDishFoodEntity,
                  );
                  setState(() {});
                },
                remove: () {
                  posController.setDecrementSideDish(sidDishFoodEntity,
                      removeDish: qty == 1 ? true : false);
                  setState(() {});
                },
                qty: qty,
              );
            },
          ),
        ],
      ),
    );
  }
}
