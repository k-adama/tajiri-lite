import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CategoryCardComponent extends StatelessWidget {
  //final CategorySupabaseEntity selectCategorie;
  //final List<Color> colors;
  final VoidCallback onTap;
  final bool isSelected;
  const CategoryCardComponent(
      {super.key,
      //required this.selectCategorie,
      //required this.colors,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 120,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Color(0xFF9999FF),
                    Color(0xFF6666FF),
                  ],
                )
              : null,
          color: isSelected ? null : Style.brandBlue50,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Style.brandColor500 : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 20.verticalSpace,
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Style.white,
              ),
            ),
            // 40.verticalSpace,
            const Spacer(),
            Text(
              "Poisson",
              style: Style.interBold(size: 13.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
