import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/category.entity.dart';

class CategoryCardComponent extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final CategoryEntity category;
  const CategoryCardComponent(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 120,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: Style.gradientEntreDessert,
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
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Style.white,
              ),
              child: Center(
                child: Text(category.imageUrl ?? ""),
              ),
            ),
            const Spacer(),
            Text(
              category.name ?? "_",
              style: Style.interBold(size: 13.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
