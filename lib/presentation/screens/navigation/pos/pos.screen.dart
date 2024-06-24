import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/components/navigation_menu.component.dart';
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
        body: Center(
          child: Text("POS"),
        ),
        floatingActionButton:  NavigationMenuComponent(
          isPos: true,
          onPressed: () {
         
          },
        ),
      ),
    );
  }
}
