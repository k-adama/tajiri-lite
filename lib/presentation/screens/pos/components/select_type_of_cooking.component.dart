import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class TypeOfCookingSelectionComponent extends StatefulWidget {
  final String text;
  final Function() onTap;
  final bool isSelected;

  const TypeOfCookingSelectionComponent({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<TypeOfCookingSelectionComponent> createState() =>
      _GenderSelectionState();
}

class _GenderSelectionState extends State<TypeOfCookingSelectionComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 130.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.circular(5.0),
          border: widget.isSelected
              ? Border.all(
                  color: Style.brandBlue950,
                  width: 2.0.w,
                )
              : Border.all(
                  color: Style.grey100,
                  width: 2.0.w,
                ),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: widget.isSelected
                  ? Style.interBold(size: 14, color: Style.brandBlue950)
                  : Style.interNormal(size: 12, color: Style.grey500),
            ),
            widget.isSelected
                ? Image.asset(
                    'assets/images/lets-icons_check-fill.png',
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
