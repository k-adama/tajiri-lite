import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';

class DisplaySideDishOrTypeCooking extends StatelessWidget {
  final List<SideDishAndQuantityEntity>? sideDishes;
  const DisplaySideDishOrTypeCooking({super.key, required this.sideDishes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23.h,
      child: ListView.builder(
          itemCount: sideDishes!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final sideDishFood = sideDishes![index];
            return Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Style.brandColorBlue100,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: Text(
                      "${sideDishFood.quantity} x ${sideDishFood.sideDish?.name} ",
                      style: Style.interBold(size: 10.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
