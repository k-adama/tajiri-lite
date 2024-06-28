import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class OrdersItemComponent extends StatefulWidget {
  final OrdersDataEntity order;
  const OrdersItemComponent({super.key, required this.order});
  @override
  State<OrdersItemComponent> createState() => _OrdersItemComponentState();
}

class _OrdersItemComponentState extends State<OrdersItemComponent> {
  final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();
  final OrderHistoryController orderController = Get.find();

  bool isPaid = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.r),
        child: Container(
          padding: orderController.isExpanded
              ? null
              : const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            backgroundColor: Style.white,
            trailing: const Icon(
              Icons.expand_more,
              color: Style.brandBlue950,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      orderTypeOrOrderStatusComponent(
                        AppConstants.getOrderTypeInFrench(widget.order),
                        true,
                      ),
                      10.horizontalSpace,
                      orderTypeOrOrderStatusComponent(
                          AppConstants.getStatusInFrench(widget.order), false),
                    ],
                  ),
                ),
                10.verticalSpace,
                orderController.tableOrWaitessNoNullOrNotEmpty(widget.order)
                    ? Text(
                        orderController.tableOrWaitressName(widget.order),
                        style: Style.interNormal(
                          color: Style.grey500,
                        ),
                      )
                    : Text(
                        "${widget.order.createdUser?.firstname ?? ""} ${widget.order.createdUser?.lastname ?? ""}",
                        style: Style.interNormal(
                          color: Style.grey500,
                        ),
                      ),
                8.verticalSpace,
                Text(
                  "${widget.order.grandTotal}".currencyLong(),
                  style: Style.interBold(
                    size: 16.sp,
                  ),
                ),
                8.verticalSpace,
              ],
            ),
            subtitle: orderController.isExpanded
                ? null
                : Row(
                    children: [
                      for (int i = 0; i < 2; i++)
                        if (widget.order.orderDetails != null &&
                            i < widget.order.orderDetails!.length)
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 2),
                              child: Text(
                                "${widget.order.orderDetails?[i].quantity ?? ''}x ${getNameFromOrderDetail(widget.order.orderDetails?[i])}",
                                style: Style.interNormal(color: Style.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                    ],
                  ),
            onExpansionChanged: (value) {
              setState(() {
                orderController.isExpanded = value;
              });
            },
            children: [
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.order.orderDetails?.map((orderDetail) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Style.brandColor50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                                "${getNameFromOrderDetail(orderDetail)} x ${orderDetail.quantity ?? ''}",
                                style: Style.interNormal(
                                  color: Style.brandBlue950,
                                )),
                          );
                        }).toList() ??
                        [],
                  )),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: CustomButton(
                  background: Style.brandColor50,
                  title: "Modifier la commande",
                  textColor: Style.brandColor500,
                  haveBorder: false,
                  radius: 5,
                  onPressed: () {
                    print(widget.order.waitressId);
                  },
                  isUnderline: true,
                ),
              ),
              10.verticalSpace,
            ],
          ),
        ));
  }

  Widget orderTypeOrOrderStatusComponent(String text, bool haveImage) {
    return Container(
        decoration: BoxDecoration(
            color: Style.grey50,
            border: Border.all(
              color: Style.grey100,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 6.w),
          child: Center(
            child: Row(
              children: [
                if (haveImage) ...[
                  if (widget.order.orderType == 'ON_PLACE')
                    Image.asset(
                        'assets/images/ic_baseline-table-restaurant.png'),
                  if (widget.order.orderType == 'TAKE_AWAY')
                    Image.asset('assets/images/Type_commande.png'),
                  if (widget.order.orderType == 'DELIVERED')
                    Image.asset('assets/images/mdi_delivery-dining.png'),
                ] else
                  Container(),
                haveImage ? 8.horizontalSpace : 0.horizontalSpace,
                Text(
                  text,
                  style: Style.interBold(size: 14, color: Style.brandBlue950),
                ),
              ],
            ),
          ),
        ));
  }
}
