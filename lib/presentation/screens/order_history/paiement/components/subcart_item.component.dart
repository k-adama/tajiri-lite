import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/printer_model.entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/add_or_remove_item.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/split_order.screen.dart';

class SubCartItemComponent extends StatefulWidget {
  final SubCartItem subCart;
  final int numberCart;
  final void Function(OrderPrinterProduct, SubCartItem) decrementQuantity;
  final void Function(OrderPrinterProduct) incrementQuantity;
  final void Function(DragTargetDetails<OrderPrinterProduct>)?
      onAcceptWithDetails;

  const SubCartItemComponent({
    super.key,
    required this.subCart,
    required this.decrementQuantity,
    required this.incrementQuantity,
    this.onAcceptWithDetails,
    required this.numberCart,
  });

  @override
  _SubCartItemComponentState createState() => _SubCartItemComponentState();
}

class _SubCartItemComponentState extends State<SubCartItemComponent> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<OrderPrinterProduct>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: widget.onAcceptWithDetails,
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Panier N°${widget.numberCart + 1}",
                style: Style.interBold(size: 11, color: Style.grey500),
              ),
              8.verticalSpace,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(minHeight: 90),
                decoration: BoxDecoration(
                  color: Style.grey100,
                  borderRadius: BorderRadius.circular(4),
                  border: const DashedBorder.fromBorderSide(
                    dashLength: 5,
                    side: BorderSide(color: Style.grey300, width: 1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.subCart.orderPrinterProducts.isEmpty
                      ? emptyElement()
                      : widget.subCart.orderPrinterProducts.map((orderDetails) {
                          return SubCartChildren(
                            orderPrinterProduct: orderDetails,
                            incrementQuantity: () {
                              widget.incrementQuantity(orderDetails);
                            },
                            decrementQuantity: () {
                              widget.decrementQuantity(
                                  orderDetails, widget.subCart);
                            },
                          );
                        }).toList(),
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    "Montant",
                    style: Style.interNormal(
                        size: 11, fontWeight: FontWeight.w500),
                  ),
                  8.horizontalSpace,
                  Text(
                    "${calculateTotalPrice(widget.subCart.orderPrinterProducts)}"
                        .currencyLong(),
                    style: Style.interSemi(size: 13),
                  ),
                ],
              ),
              24.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  List<Widget> emptyElement() {
    return [
      Text(
        'Glisser les commandes ici !',
        style: Style.interNormal(color: Style.grey500, size: 13),
      )
    ];
  }
}

class SubCartChildren extends StatelessWidget {
  final OrderPrinterProduct orderPrinterProduct;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;

  const SubCartChildren(
      {super.key,
      required this.orderPrinterProduct,
      required this.incrementQuantity,
      required this.decrementQuantity});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
            5.horizontalSpace,
            AddOrRemoveItemComponent(
                add: incrementQuantity, remove: decrementQuantity),
          ],
        ),
      ),
    );
  }
}
