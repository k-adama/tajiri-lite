import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/add_or_remove_food_detail_modal_quantity.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/food_detail_formField.component.dart';

class FoodDetailModalComponent extends StatefulWidget {
  const FoodDetailModalComponent({super.key});

  @override
  State<FoodDetailModalComponent> createState() =>
      _FoodDetailModalComponentState();
}

class _FoodDetailModalComponentState extends State<FoodDetailModalComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Text(
            "Côte de porc",
            style: Style.interBold(size: 20),
          ),
          Text(
            "En cas de besoin modifiez manuellement le prix du produit.",
            style: Style.interNormal(size: 10),
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
          16.verticalSpace,
          const Divider(
            thickness: 2,
          ),
          12.verticalSpace,
          Text(
            "Type de cuisson",
            style: Style.interBold(size: 20),
          ),
          Text(
            "Veuillez sélectionner une cuisson",
            style: Style.interNormal(size: 10),
          ),
        ],
      )),
    );
  }
}
