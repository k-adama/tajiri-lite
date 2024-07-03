import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
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
  final homeController = Get.find<HomeController>();
  bool isExpanded = false;

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
          padding: isExpanded ? null : const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: Style.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              collapsedIconColor: Style.black,
              iconColor: Style.black,
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
                          orderType: widget.order.orderType,
                        ),
                        10.horizontalSpace,
                        orderTypeOrOrderStatusComponent(
                            AppConstants.getStatusInFrench(widget.order)),
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
                      size: 18.sp,
                    ),
                  ),
                  8.verticalSpace,
                ],
              ),
              subtitle: isExpanded
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
                  isExpanded = value;
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
                                color: Style.brandBlue50.withOpacity(.5),
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
                    background: Style.brandBlue50,
                    title: "Modifier la commande",
                    isGrised: AppHelpersCommon.getUserInLocalStorage()
                            ?.canUpdateOrCanceledOrder() ==
                        false, // grised add product button if user can't update or cancel
                    textColor: Style.brandColor500,
                    haveBorder: false,
                    radius: 5,
                    onPressed: () {
                      homeController.posController
                          .addItemsFromOrderToCart(widget.order);
                      Get.toNamed(Routes.POS, arguments: true);
                    },
                    isUnderline: true,
                  ),
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ));
  }

  Widget orderTypeOrOrderStatusComponent(String text, {String? orderType}) {
    return Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Style.grey50,
            border: Border.all(
              color: Style.grey100,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Row(
            children: [
              if (orderType != null) ...[
                if (orderType == 'ON_PLACE')
                  imageContainer(
                    SvgPicture.asset(
                      onPlaceSvg,
                      width: 10,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                if (orderType == 'TAKE_AWAY')
                  imageContainer(SvgPicture.asset(
                    takeAwaySvg,
                    color: Colors.white,
                  )),
                if (orderType == 'DELIVERED')
                  imageContainer(SvgPicture.asset(
                    deliveredSvg,
                    color: Colors.white,
                  )),
              ],
              orderType != null ? 8.horizontalSpace : 0.horizontalSpace,
              Text(
                text,
                style: Style.interBold(size: 14, color: Style.brandBlue950),
              ),
            ],
          ),
        ));
  }

  Widget imageContainer(Widget asset) {
    return Container(
      width: 22,
      height: 22,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Style.brandBlue950,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: asset,
      ),
    );
  }
}
