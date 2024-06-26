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
          color: Style.brandBlue50,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Style.brandColor500 : Colors.transparent,
              width: 2.0,
            ),
          ),

          /* boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                    spreadRadius: 2, // Distance de diffusion de l'ombre
                    blurRadius: 5, // Flou de l'ombre
                    offset: Offset(0, 3), // Position de l'ombre (x, y)
                  ),
                ]
              : null,*/
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
