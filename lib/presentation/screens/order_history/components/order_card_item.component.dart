import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/orders_item.component.dart';

class OrderCardItemComponent extends StatefulWidget {
  final List<OrdersDataEntity> orders;
  final bool isRestaurant;
  const OrderCardItemComponent(
      {super.key, required this.orders, required this.isRestaurant});

  @override
  State<OrderCardItemComponent> createState() => _OrderCardItemComponentState();
}

class _OrderCardItemComponentState extends State<OrderCardItemComponent> {
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
            OrdersDataEntity orderData = widget.orders[index];
            return OrdersItemComponent(
              order: orderData,
            );
          }),
    );
  }
}
