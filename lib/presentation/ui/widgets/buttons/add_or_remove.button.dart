import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class AddOrRemoveButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  const AddOrRemoveButton(
      {super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Style.brandBlue50,
          borderRadius: BorderRadius.circular(20)
        ),
        width: 30,
        height: 30,
        child: Center(
          child: Icon(
            iconData,
            color: Style.black,
          ),
        ),
      ),
    );
  }
}
