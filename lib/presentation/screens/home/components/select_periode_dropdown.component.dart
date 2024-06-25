import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SelectPeriodeDropdownComponent extends StatefulWidget {
  const SelectPeriodeDropdownComponent({
    super.key,
  });

  @override
  State<SelectPeriodeDropdownComponent> createState() =>
      _SelectPeriodeDropdownComponentState();
}

class _SelectPeriodeDropdownComponentState
    extends State<SelectPeriodeDropdownComponent> {
  String dropdownValue = 'Ajourd\'hui';

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 120,
      height: 30,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          color: Style.black,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['Ajourd\'hui'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Style.white),
              ),
            );
          }).toList(),
          dropdownColor: Colors.black,
          style: const TextStyle(color: Style.white),
        ),
      ),
    );
  }
}
