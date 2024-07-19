import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
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
            return OrdersItemComponent(
              order: orderData,
            );
          }),
    );
  }
}
