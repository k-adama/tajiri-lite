import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/pos_search_bar.component.dart';

class PosSearchProductScreen extends StatefulWidget {
  const PosSearchProductScreen({super.key});

  @override
  State<PosSearchProductScreen> createState() => _PosSearchProductScreenState();
}

class _PosSearchProductScreenState extends State<PosSearchProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
       /* title: Text(
          "Recherche produit",
          style: Style.interBold(
            size: 20,
            color: Style.brandBlue950,
          ),
        ),*/
        iconTheme: const IconThemeData(color: Style.secondaryColor),
        backgroundColor: Style.white,
      ),
      backgroundColor: Style.bodyNewColor,
      body: GetBuilder<PosController>(
        builder: (posController) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosSearchComponent(posController: posController),
          ],
        ),
      ),
    );
  }
}
