import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class TPEPaiementScreen extends StatefulWidget {
  const TPEPaiementScreen({super.key});

  @override
  State<TPEPaiementScreen> createState() => _TPEPaiementScreenState();
}

class _TPEPaiementScreenState extends State<TPEPaiementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Paiement via TPE",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
    );
  }
}
