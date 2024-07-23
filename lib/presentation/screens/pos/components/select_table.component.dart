import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/table/table.controller.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/select_dropdown.button.dart';
import 'package:tajiri_sdk/src/models/table.model.dart' as taj_sdk;

class SelectTableComponent extends StatefulWidget {
  const SelectTableComponent({super.key});

  @override
  State<SelectTableComponent> createState() => _SelectTableComponentState();
}

class _SelectTableComponentState extends State<SelectTableComponent> {
  final TableController waitressController = Get.find();
  final PosController posController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SelectDropDownButton<taj_sdk.Table?>(
        containerColor: Style.grey50,
        borderColor: Style.grey100,
        value: posController.selectedTable.value,
        hinText: 'Choix de la table',
        onChanged: (taj_sdk.Table? newValue) {
          posController.selectedTable.value = newValue;
        },
        items: waitressController.tableListData.map((taj_sdk.Table? table) {
          return DropdownMenuItem<taj_sdk.Table?>(
            value: table,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(table?.name ?? "Aucune table"),
            ),
          );
        }).toList(),
      );
    });
  }
}
