import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/best_sale.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/cart_item_row.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/chart_bar.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/drawer_page.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/sale_by_category.component..dart';
import 'package:tajiri_waitress/presentation/screens/home/components/select_periode_dropdown.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.rounded.button.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  String dropdownValue = 'Aujourd\'hui';
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
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              "Tableau de bord",
              style: Style.interBold(size: 20, color: Style.brandBlue950),
            ),
            iconTheme: const IconThemeData(color: Style.brandBlue950),
            backgroundColor: Style.white,
          ),
        ),
        drawer: const Drawer(
          backgroundColor: Style.white,
          child: DrawerPageComponent(),
        ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: SelectDropdownComponent<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        print('Selected value: $newValue');
                        setState(() {
                          if (newValue == null) {
                            return;
                          }
                          dropdownValue = newValue;
                        });
                      },
                      items: const ['Aujourd\'hui', 'Demain', 'Hier'],
                      itemAsString: (String value) => value,
                    ),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 6),
                    child: BestSaleComponent(
                      /* orders: dashboardController.getDishOrDrinkOrders(
                            dashboardController.orders, DISHESID),*/
                      saleHeaderTitle: 'Meilleures ventes cuisine',
                    ),
                  ),
                  24.verticalSpace,
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 6),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                final selectBagProductsLength =
                    homeController.posController.selectbagProductsLength.value;
                return Expanded(
                  child: selectBagProductsLength == 0
                      ? CustomRoundedButton(
                          title: 'Nouvelle Commande',
                          asset:
                              SvgPicture.asset("assets/svgs/edit-pen-fill.svg"),
                          onTap: () {
                            Get.toNamed(Routes.POS);
                          },
                        )
                      : CustomRoundedButton(
                          title: 'Commande en cours',
                          asset: Container(
                            width: 25,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Style.brandBlue950),
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
                            Get.toNamed(Routes.POS);
                          },
                        ),
                );
              }),
              10.horizontalSpace,
              SizedBox(
                width: 48,
                height: 48,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Style.brandBlue950,
                    onPressed: () {
                      Get.toNamed(Routes.ORDER_HISTORY);
                    },
                    child: Image.asset(
                        'assets/images/icon-park-solid_transaction-order.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
