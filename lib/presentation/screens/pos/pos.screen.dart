import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/category_list.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/product_list.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/see_cart_button.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/select_table.component.dart';
import 'package:upgrader/upgrader.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final user = AppHelpersCommon.getUserInLocalStorage();
  final backScreenIsOrderHistory = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final restaurantName =
        "${user != null && user?.restaurantUser != null ? user?.restaurantUser![0].restaurant?.name : ""}";
    return UpgradeAlert(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: GetBuilder<PosController>(builder: (posController) {
            final hasTableManagement = posController.hasTableManagement;
            return hasTableManagement &&
                    posController.selectbag.waitressId == null
                ? const SelectTableComponent()
                : Text(
                    restaurantName,
                    style: const TextStyle(color: Style.brandBlue950),
                  );
          }),
          iconTheme: const IconThemeData(color: Style.brandBlue950),
          backgroundColor: Style.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Style.brandBlue950,
              ),
              onPressed: () {
                Get.toNamed(Routes.SEARCH_PRODUCT);
              },
            ),
          ],
        ),
        backgroundColor: Style.bodyNewColor,
        body: Container(
          padding: const EdgeInsets.only(left: 1),
          child: const Column(
            children: [
              CategoryListComponent(),
              Expanded(child: ProductsListComponent())
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SeeCartButtonComponent(
          backScreenIsOrderHistory: backScreenIsOrderHistory == true,
        ),
      ),
    );
  }
}
