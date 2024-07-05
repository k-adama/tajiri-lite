import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/cart_item_row.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/chart_bar.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/drawer_page.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/my_orders.component.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/select_periode_dropdown.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.rounded.button.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _onRefresh(HomeController homeController) async {
    await homeController.fetchDataForReports();
    _smartRefreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: GetBuilder<HomeController>(builder: (homeController) {
        return Scaffold(
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
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  AppHelpersCommon.showCustomModalBottomSheet(
                    context: context,
                    modal: Text("dd"),
                    isDarkMode: false,
                    isDrag: true,
                    radius: 12,
                  );
                },
              ),
              iconTheme: const IconThemeData(color: Style.brandBlue950),
              backgroundColor: Style.white,
            ),
          ),

          /* drawer: InkWell(
            onTap: () {
              print("bfhfhjfhfhff");
            },
            child: const Drawer(
              backgroundColor: Style.white,
              // child: DrawerPageComponent(),
            ),
          ),*/
          backgroundColor: Style.bodyNewColor,
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: SelectDropdownComponent<String?>(
                    value: homeController.selectFiler.value,
                    onChanged: null,
                    /*(String? newValue) {
                      setState(() {
                        if (newValue == null) {
                          return;
                        }
                        homeController.changeDateFilter(newValue);
                      });
                    },*/
                    items: homeController.filterItems,
                    itemAsString: (String? value) {
                      return value ?? "Aucun element";
                    },
                  ),
                ),
                24.verticalSpace,
                homeController.isFetching.value
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SmartRefresher(
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
                          onRefresh: () {
                            _onRefresh(homeController);
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: CartItemRowComponent(
                                    homeController: homeController,
                                  ),
                                ),
                                24.verticalSpace,
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.0, right: 12),
                                  child: ChartBarComponent(),
                                ),
                                20.verticalSpace,
                                Padding(
                                  padding: const EdgeInsets.only(left: 14.0),
                                  child: Text(
                                    "Mes commandes",
                                    style: Style.interBold(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4),
                                  child: MyOrdersComponent(
                                    orders: homeController.orders,
                                  ),
                                ),
                                20.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final selectBagProductsLength = homeController
                      .posController.selectbagProductsLength.value;
                  return Expanded(
                    child: selectBagProductsLength == 0
                        ? CustomRoundedButton(
                            title: 'Nouvelle Commande',
                            asset: SvgPicture.asset(
                                "assets/svgs/edit-pen-fill.svg"),
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
        );
      }),
    );
  }
}
