import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/best_sale.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/cart_item_row.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/chart_bar.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/sale_by_category.component..dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/select_periode_dropdown.component.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  String dropdownValue = 'Ajourd\'hui';
  late RefreshController _smartRefreshController;

  @override
  void initState() {
    super.initState();
    _smartRefreshController = RefreshController();
  }

  @override
  void dispose() {
    _smartRefreshController.dispose();
    super.dispose();
  }

  void _onLoading() async {
    _smartRefreshController.loadComplete();
  }

  void _onRefresh() async {
    _smartRefreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
          backgroundColor: Style.bodyNewColor,
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            physics: const BouncingScrollPhysics(),
            controller: _smartRefreshController,
            header: WaterDropMaterialHeader(
              distance: 160.h,
              backgroundColor: Style.white,
              color: Style.light,
            ),
            onLoading: () => _onLoading(),
            onRefresh: () => _onRefresh(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: SelectPeriodeDropdownComponent(),
                    ),
                    24.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: CartItemRowComponent(
                        dashboardController: homeController,
                      ),
                    ),
                    24.verticalSpace,
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12),
                      child: ChartBarComponent(),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Text(
                        "Ventes/catégorie",
                        style: Style.interBold(),
                      ),
                    ),
                    8.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4),
                      child: SaleByCategoriyComponent(
                        orders: homeController.orders,
                      ),
                    ),
                    14.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 6),
                      child: BestSaleComponent(
                        /* orders: dashboardController.getDishOrDrinkOrders(
                            dashboardController.orders, DISHESID),*/
                        saleHeaderTitle: 'Meilleures ventes cuisine',
                      ),
                    ),
                    24.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 6),
                      child: BestSaleComponent(
                        /* orders: dashboardController
                                          .getDishOrDrinkOrders(
                                              dashboardController.orders,
                                              DRINKSID),*/
                        saleHeaderTitle: 'Meilleures ventes bar',
                      ),
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
