import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class OrderStatusMessageComponent extends StatelessWidget {
  final String status;
  final Color textColor;
  const OrderStatusMessageComponent(
      {super.key, required this.status, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Commande",
            style: Style.interRegular(
              size: 15,
              color: textColor,
            ),
          ),
          Text(
            status,
            style: Style.interRegular(
              size: 15,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
