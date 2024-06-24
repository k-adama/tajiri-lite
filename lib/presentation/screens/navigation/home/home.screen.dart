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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectPeriodeDropdownComponent(),
                    20.verticalSpace,
                    CartItemRowComponent(
                      dashboardController: homeController,
                    ),
                    20.verticalSpace,
                    const ChartBarComponent(),
                    20.verticalSpace,
                    Text(
                      "Ventes/catégorie",
                      style: Style.interBold(),
                    ),
                    20.verticalSpace,
                    SaleByCategoriyComponent(
                      orders: homeController.orders,
                    ),
                    20.verticalSpace,
                    BestSaleComponent(
                      /* orders: dashboardController.getDishOrDrinkOrders(
                          dashboardController.orders, DISHESID),*/
                      saleHeaderTitle: 'Meilleures ventes cuisine',
                    ),
                    20.verticalSpace,
                    BestSaleComponent(
                      /* orders: dashboardController
                                        .getDishOrDrinkOrders(
                                            dashboardController.orders,
                                            DRINKSID),*/
                      saleHeaderTitle: 'Meilleures ventes bar',
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
