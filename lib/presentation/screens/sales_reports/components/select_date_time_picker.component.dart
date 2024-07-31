import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/components/outline_bordered_pick_date.component.dart';

class SelectDateTimePickerComponent extends StatelessWidget {
  final String labelText;
  final Widget iconData;
  final TextEditingController dateTimeController;
  final VoidCallback? onTap;
  final double width;
  final bool? isGrey;
  final bool readonly;
  const SelectDateTimePickerComponent({
    super.key,
    required this.labelText,
    required this.iconData,
    required this.dateTimeController,
    this.onTap,
    this.width = 180,
    this.readonly = false,
    this.isGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Style.grey300, width: .5),
        color: isGrey == true ? Style.grey100 : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 36,
      child: OutlineBorderedPickDateAndTimeComponent(
        labelText: labelText,
        isGrey: isGrey,
        iconData: iconData,
        dateTimeController: dateTimeController,
        onTap: onTap,
        readonly: readonly,
      ),
    );
  }
}
