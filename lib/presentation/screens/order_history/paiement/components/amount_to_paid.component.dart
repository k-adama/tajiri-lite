import 'package:flutter/material.dart';

import 'package:tajiri_sdk/src/models/order.model.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';

class AmountToPaidComponent extends StatelessWidget {
  final List<OrderProduct>? orderDetails;
  const AmountToPaidComponent({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Montant à payer",
          style: Style.interNormal(size: 13, color: Style.grey500),
        ),
        Container(
          width: 280,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: const BoxDecoration(
            color: Style.grey100,
          ),
          child: Center(
            child: Text(
              "${orderDetails != null ? grandTotalPrice(orderDetails!) : 0}"
                  .currencyLong(),
              style: Style.interBold(
                color: Style.grey500,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 55),
      ],
    );
  }
}

class TotalCardComponent extends StatelessWidget {
  final int? total;
  const TotalCardComponent({super.key, this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
        color: Style.grey50,
        border: Border.all(color: Style.grey200, width: .5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Total"),
          Text(
            "$total".currencyLong(),
            style: Style.interBold(size: 15),
          ),
        ],
      ),
    );
  }
}
