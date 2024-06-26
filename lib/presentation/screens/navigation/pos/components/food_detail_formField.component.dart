import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';

class FoodDetailFormField extends StatelessWidget {
  final String? hint;
  const FoodDetailFormField({super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    final PosController posController = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: 200.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Style.white,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: Style.grey200,
        ),
      ),
      child: Center(
        child: TextFormField(
          style: Style.interBold(
            size: 13,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.left,
          onChanged: (String value) {
            // posController.setPriceAddFood(int.tryParse(value) ?? 0);
          },
          decoration: InputDecoration(
            /*  hintText: posController.priceAddFood != 0
                      ? posController.priceAddFood.toString()
                      : */
            hintText: hint,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
