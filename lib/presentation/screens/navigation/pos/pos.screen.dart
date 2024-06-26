import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/custom_pos_roundedButton.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/main_appbar.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/product_list.component.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/select_waitress.component.dart';
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
          title: SelectWaitressComponent(),
          iconTheme: const IconThemeData(color: Style.secondaryColor),
          backgroundColor: Style.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Style.brandBlue950,
              ),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Style.bodyNewColor,
        body: Container(
          padding: const EdgeInsets.only(left: 1),
          child: const Column(
            children: [
              MainAppbarComponent(),
              Expanded(child: ProductsListComponent())
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: customPosRoundedButtonComponent(
                  onTap: () {},
                  text: '1',
                ),
              ),
              10.horizontalSpace,
              SizedBox(
                width: 48,
                height: 48,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Style.brandBlue950,
                    onPressed: () {},
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
