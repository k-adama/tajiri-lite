import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';

class OrderListEmptyComponent extends StatelessWidget {
  OrderListEmptyComponent({super.key});

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
      child: Column(
        children: [
          18.verticalSpace,
          Image.asset("assets/images/notFound.png"),
          Text(
            "Pas de resultats",
            style: Style.interSemi(size: 14.sp),
          ),
        ],
      ),
    );
  }
}
