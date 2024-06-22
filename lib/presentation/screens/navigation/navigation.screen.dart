import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/navigation.controller.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navigationController = Get.find<NavigationController>();
  // final user = AppHelpersCommon.getUserInLocalStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
