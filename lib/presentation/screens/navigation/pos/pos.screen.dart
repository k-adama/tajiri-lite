import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
