import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/order_card_item.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/components/order_list_empty.component.dart';
import 'package:tajiri_waitress/presentation/ui/custom_tab_bar.ui.dart';
import 'package:tajiri_waitress/presentation/ui/loading.ui.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.rounded.button.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);
  final UserEntity? user = AppHelpersCommon.getUserInLocalStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Historique de commande",
          style: Style.interBold(size: 20, color: Style.brandBlue950),
        ),
        iconTheme: const IconThemeData(color: Style.secondaryColor),
        backgroundColor: Style.white,
      ),
      backgroundColor: Style.bodyNewColor,
      body: GetBuilder<OrderHistoryController>(
          builder: (orderHistoryController) => Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          20.verticalSpace,
                          CustomTabBarUi(
                            tabController: _tabController,
                            tabs: tabs,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                orderHistoryController.isProductLoading == true
                                    ? const LoadingUi()
                                    : orderHistoryController.orders.isEmpty
                                        ? const OrderListEmptyComponent()
                                        : OrderCardItemComponent(
                                            orders:
                                                orderHistoryController.orders,
                                            isRestaurant: user != null &&
                                                user?.restaurantUser != null &&
                                                user?.restaurantUser![0]
                                                        .restaurant?.type ==
                                                    AppConstants
                                                        .clientTypeRestaurant,
                                            //widget.mainController,
                                          ),
                                orderHistoryController.isProductLoading == true
                                    ? const LoadingUi()
                                    : orderHistoryController.orders
                                            .where((item) => AppConstants
                                                .getStatusOrderInProgressOrDone(
                                                    item, "IN_PROGRESS"))
                                            .isEmpty
                                        ? OrderListEmptyComponent()
                                        : OrderCardItemComponent(
                                            orders: orderHistoryController
                                                .orders
                                                .where((item) => AppConstants
                                                    .getStatusOrderInProgressOrDone(
                                                        item, "IN_PROGRESS"))
                                                .toList(),
                                            isRestaurant: user != null &&
                                                user?.restaurantUser != null &&
                                                user?.restaurantUser![0]
                                                        .restaurant?.type ==
                                                    AppConstants
                                                        .clientTypeRestaurant,
                                            //widget.mainController,
                                          ),
                                orderHistoryController.isProductLoading == true
                                    ? const LoadingUi()
                                    : orderHistoryController.orders
                                            .where((item) => AppConstants
                                                .getStatusOrderInProgressOrDone(
                                                    item, "DONE"))
                                            .isEmpty
                                        ? OrderListEmptyComponent()
                                        : OrderCardItemComponent(
                                            orders: orderHistoryController
                                                .orders
                                                .where((item) => AppConstants
                                                    .getStatusOrderInProgressOrDone(
                                                        item, "DONE"))
                                                .toList(),
                                            isRestaurant: user != null &&
                                                user?.restaurantUser != null &&
                                                user?.restaurantUser![0]
                                                        .restaurant?.type ==
                                                    AppConstants
                                                        .clientTypeRestaurant,
                                            //widget.mainController,
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomRoundedButton(
          onTap: () {
            Get.toNamed(Routes.POS);
          },
        ),
      ),
    );
  }
}
