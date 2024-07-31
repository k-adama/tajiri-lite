import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/order_cancel_dialog.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/order_status_message.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/orders_item.component.dart';

class OrdersListItemComponent extends StatefulWidget {
  final List<Order> orders;
  final bool isRestaurant;
  const OrdersListItemComponent(
      {super.key, required this.orders, required this.isRestaurant});

  @override
  State<OrdersListItemComponent> createState() =>
      _OrdersListItemComponentState();
}

class _OrdersListItemComponentState extends State<OrdersListItemComponent> {
  final OrderHistoryController _ordersController = Get.find();
  final RefreshController _controller = RefreshController();
  void _onRefresh() async {
    _ordersController.fetchOrders();
  }

  void _onLoading() async {
    _ordersController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _controller,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: widget.orders.length,
          itemBuilder: (BuildContext context, index) {
            Order orderData = widget.orders[index];
            return Slidable(
              enabled: orderData.status != AppConstants.orderPaid &&
                  _ordersController.canDelete == true,
              endActionPane: ActionPane(
                extentRatio: 0.35,
                motion: const ScrollMotion(),
                children: [
                  if ((orderData.status != AppConstants.orderReady) &&
                      (orderData.status != AppConstants.orderCancelled))
                    OrderSlideButton(
                      onTap: () {
                        AppHelpersCommon.showAlertDialog(
                          context: context,
                          child: OrderCancelDialogComponent(
                            noCancel: () {
                              Navigator.pop(context);
                              Slidable.of(context)?.close();
                            },
                            cancel: () {
                              _ordersController.updateOrderStatus(
                                context,
                                orderData.id.toString(),
                                AppConstants.orderCancelled,
                              );
                              Navigator.pop(context);
                              Slidable.of(context)?.close();
                            },
                          ),
                          radius: 10,
                        );
                      },
                      title: "Annuler",
                    ),
                  if (orderData.status == AppConstants.orderCancelled)
                    const OrderStatusMessageComponent(
                        status: "annulée", textColor: Style.red),
                  if (orderData.status == AppConstants.orderReady)
                    const OrderStatusMessageComponent(
                        status: "prête", textColor: Style.secondaryColor),
                ],
              ),
              child: OrdersItemComponent(
                order: orderData,
              ),
            );
          }),
    );
  }
}

class OrderSlideButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const OrderSlideButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72.r,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: const BoxDecoration(
            color: Style.red,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Style.interRegular(
              size: 15,
              color: Style.white,
            ),
          ),
        ),
      ),
    );
  }
}
