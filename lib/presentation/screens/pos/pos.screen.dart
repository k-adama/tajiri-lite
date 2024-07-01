import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/main_appbar.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/product_list.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/see_cart_button.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/select_waitress.component.dart';
import 'package:upgrader/upgrader.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const SelectWaitressComponent(),
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
        floatingActionButton: const SeeCartButtonComponent(),
      ),
    );
  }
}
