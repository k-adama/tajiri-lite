import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/select_dish_food.component.dart';

class DishFoodComponent extends StatefulWidget {
  const DishFoodComponent({super.key});

  @override
  State<DishFoodComponent> createState() => _DishFoodComponentState();
}

class _DishFoodComponentState extends State<DishFoodComponent> {
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
            style: Style.interBold(size: 20, color: Style.brandBlue950),
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
            itemCount: 28,
            itemBuilder: (context, index) {
              return SelectDishFoodComponent(
                dishFoodName: 'Riz',
                add: () {},
                remove: () {},
                text: '0',
              );
            },
          ),
        ],
      ),
    );
  }
}
