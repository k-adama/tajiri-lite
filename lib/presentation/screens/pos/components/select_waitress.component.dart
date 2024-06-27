import 'package:flutter/material.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/select_dropdown.button.dart';

class SelectWaitressComponent extends StatefulWidget {
  const SelectWaitressComponent({super.key});

  @override
  State<SelectWaitressComponent> createState() =>
      _SelectWaitressComponentState();
}

class _SelectWaitressComponentState extends State<SelectWaitressComponent> {
  final List<String> servers = ['Serveur 1', 'Serveur 2'];
  String? selectedServer;
  @override
  Widget build(BuildContext context) {
    return SelectDropDownButton<String>(
      containerColor: Colors.grey[300]!,
      value: selectedServer,
      hinText: 'Choix du serveur',
      onChanged: (String? newValue) {
        setState(() {
          selectedServer = newValue;
        });
      },
      items: servers.map((String server) {
        return DropdownMenuItem<String>(
          value: server,
          child: Text(server),
        );
      }).toList(),
    );
  }
}
