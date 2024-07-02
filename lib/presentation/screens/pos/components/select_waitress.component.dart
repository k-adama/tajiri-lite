import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/select_dropdown.button.dart';

class SelectTableComponent extends StatefulWidget {
  const SelectTableComponent({super.key});

  @override
  State<SelectTableComponent> createState() => _SelectTableComponentState();
}

class _SelectTableComponentState extends State<SelectTableComponent> {
  final List<String?> tables = ['Table 1', 'Table 2', null];
  String? selectedTable;
  @override
  Widget build(BuildContext context) {
    return SelectDropDownButton<String?>(
      containerColor: Style.grey50,
      borderColor: Style.grey100,
      value: selectedTable,
      hinText: 'Choix de la table',
      onChanged: (String? newValue) {
        setState(() {
          selectedTable = newValue;
        });
      },
      items: tables.map((String? server) {
        return DropdownMenuItem<String?>(
          value: server,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(server ?? "Aucune table"),
          ),
        );
      }).toList(),
    );
  }
}
