import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/add_or_remove_food_detail_modal_quantity.component.dart';

class SelectDishFoodComponent extends StatefulWidget {
  final String dishFoodName;
  final String text;
  final VoidCallback add;
  final VoidCallback remove;
  const SelectDishFoodComponent({
    super.key,
    required this.dishFoodName,
    required this.add,
    required this.remove,
    required this.text,
  });

  @override
  State<SelectDishFoodComponent> createState() =>
      _SelectDishFoodComponentState();
}

class _SelectDishFoodComponentState extends State<SelectDishFoodComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(widget.dishFoodName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Style.interBold(
                        size: 14,
                      )),
                ),
                10.horizontalSpace,
                Text(
                  "O FCFA",
                  style: Style.interNormal(size: 10),
                ),
              ],
            ),
          ),
          AddOrRemoveFoodDteailModalQauntityComponent(
            add: widget.add,
            remove: widget.remove,
            text: widget.text,
          ),
        ],
      ),
    );
  }
}
