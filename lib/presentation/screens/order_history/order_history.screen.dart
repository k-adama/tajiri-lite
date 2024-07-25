import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
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
  final homeController = Get.find<HomeController>();
  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

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
        iconTheme: const IconThemeData(color: Style.brandBlue950),
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
                                _buildOrderTab(
                                  isLoading:
                                      orderHistoryController.isProductLoading,
                                  orders: orderHistoryController.orders,
                                  filter: (order) =>
                                      true, // No filter for the first tab
                                  restaurant: restaurant,
                                ),
                                _buildOrderTab(
                                  isLoading:
                                      orderHistoryController.isProductLoading,
                                  orders: orderHistoryController.orders,
                                  filter: (order) => AppConstants
                                      .getStatusOrderInProgressOrDone(
                                          order, "IN_PROGRESS"),
                                  restaurant: restaurant,
                                ),
                                _buildOrderTab(
                                  isLoading:
                                      orderHistoryController.isProductLoading,
                                  orders: orderHistoryController.orders,
                                  filter: (order) => AppConstants
                                      .getStatusOrderInProgressOrDone(
                                          order, "DONE"),
                                  restaurant: restaurant,
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
        child: Obx(() {
          final selectBagProductsLength =
              homeController.posController.selectbagProductsLength.value;
          return selectBagProductsLength == 0
              ? CustomRoundedButton(
                  title: 'Nouvelle Commande',
                  asset: SvgPicture.asset("assets/svgs/edit-pen-fill.svg"),
                  onTap: () {
                    Get.toNamed(Routes.POS, arguments: true);
                  },
                )
              : CustomRoundedButton(
                  title: 'Commande en cours',
                  asset: Container(
                    width: 25,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Style.brandBlue950),
                    child: Center(
                      child: Text(
                        selectBagProductsLength.toString(),
                        style: Style.interBold(
                          color: Style.yellowLigther,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.POS, arguments: true);
                  },
                );
        }),
      ),
    );
  }

  bool _isRestaurantUser(Restaurant? restaurant) {
    if (restaurant == null) {
      return false;
    }
    return restaurant.name.isNotEmpty &&
        restaurant.type == AppConstants.clientTypeRestaurant;
  }

  Widget _buildOrderTab({
    required bool isLoading,
    required List<Order> orders,
    required bool Function(Order) filter,
    required Restaurant? restaurant,
  }) {
    if (isLoading) {
      return const LoadingUi();
    }

    final filteredOrders = orders.where(filter).toList();
    if (filteredOrders.isEmpty) {
      return OrderListEmptyComponent();
    }

    return OrdersListItemComponent(
      orders: filteredOrders,
      isRestaurant: _isRestaurantUser(restaurant),
    );
  }
}
