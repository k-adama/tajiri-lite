import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class FoodDetailFormField extends StatelessWidget {
  final String? hint;
  final Function(String)? onChanged;
  const FoodDetailFormField({super.key, this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
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
          onChanged: onChanged,
          decoration: InputDecoration(
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
