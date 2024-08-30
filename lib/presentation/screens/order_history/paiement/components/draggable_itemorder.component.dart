import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/printer_model.entity.dart';

class DraggableItemOrderComponent extends StatelessWidget {
  final OrderPrinterProduct orderPrinterProduct;

  const DraggableItemOrderComponent(
      {super.key, required this.orderPrinterProduct});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      print(c.maxWidth);
      return Draggable<OrderPrinterProduct>(
        data: orderPrinterProduct,
        feedback: Material(
          type: MaterialType.transparency,
          child: ItemOrderCard(
            orderPrinterProduct: orderPrinterProduct,
            width: c.maxWidth,
          ),
        ),
        childWhenDragging: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 68,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ItemOrderCard(orderPrinterProduct: orderPrinterProduct),
        ),
      );
    });
  }
}

class ItemOrderCard extends StatelessWidget {
  final OrderPrinterProduct orderPrinterProduct;
  final double? width;
  const ItemOrderCard(
      {super.key, required this.orderPrinterProduct, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${orderPrinterProduct.quantity}x  ${orderPrinterProduct.productName}',
                      style: Style.interBold(size: 13),
                    ),
                    5.verticalSpace,
                    Text(
                      '${orderPrinterProduct.totalPrice}'.currencyLong(),
                      style: Style.interBold(size: 10, color: Style.grey600),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Style.brandColor500,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/scinder_itemorder.png",
                    width: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
