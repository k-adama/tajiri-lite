import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/navigation_menu.component.dart';
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
          title: Text(
            "POS",
            style: Style.interBold(size: 20, color: Style.brandBlue950),
          ),
          iconTheme: const IconThemeData(color: Style.secondaryColor),
          backgroundColor: Style.white,
        ),
        backgroundColor: Style.bodyNewColor,
        body: const Center(
          child: Text("POS"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(child: PosButtonComponent()),
              10.horizontalSpace,
              FloatingActionButton(
                backgroundColor: Style.brandBlue950,
                onPressed: () {},
                child: Image.asset(
                  'assets/images/icon-park-solid_transaction-order.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
