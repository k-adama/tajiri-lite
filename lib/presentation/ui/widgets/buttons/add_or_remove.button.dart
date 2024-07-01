import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class AddOrRemoveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData iconData;
  final double sizeButton;
  final double iconsize;

  const AddOrRemoveButton(
      {super.key,
      required this.onTap,
      required this.iconData,
      this.sizeButton = 30,
      this.iconsize = 24});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Style.brandBlue50, borderRadius: BorderRadius.circular(20)),
        width: sizeButton,
        height: sizeButton,
        child: Center(
          child: Icon(
            iconData,
            size: iconsize,
            color: Style.black,
          ),
        ),
      ),
    );
  }
}
