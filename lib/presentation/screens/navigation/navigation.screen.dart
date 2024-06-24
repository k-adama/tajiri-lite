import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/navigation.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/components/drawer_page.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/components/navigation_menu.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/home.screen.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/pos.screen.dart';
import 'package:tajiri_waitress/presentation/ui/keyboard_dismisser.ui.dart';
import 'package:upgrader/upgrader.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navigationController = Get.find<NavigationController>();
  final user = AppHelpersCommon.getUserInLocalStorage();

  late List<IndexedStackChild> list;
  void handleBottomNavBarTap(int index) {
    navigationController.selectIndexFunc(index);
  }

  @override
  void initState() {
    list = [
      IndexedStackChild(child: const HomeScreen()),
      IndexedStackChild(child: const PosScreen()),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (navigationController) => UpgradeAlert(
        child: KeyboardDismisserUi(
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
                iconTheme: const IconThemeData(color: Style.secondaryColor),
                backgroundColor: Style.white,
              ),
            ),
            drawer: const Drawer(
              backgroundColor: Style.white,
              child: DrawerPageComponent(),
            ),
            body: ProsteIndexedStack(
              index: navigationController.selectIndex,
              children: list,
            ),
            floatingActionButton: NavigationMenuComponent(
              onPressed: () {
                Get.toNamed(Routes.POS);
              },
              OrdersOnPressed: () {
                //Go to orders
              },
            ),
          ),
        ),
      ),
    );
  }
}
