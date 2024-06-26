import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/splash/splash.controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController splashController = Get.find();

  final inboxInitialized = false;
  bool _firstSplashImage = false;
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    _loadSplashImages();
    initPlatformState();
  }

  void _loadSplashImages() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _firstSplashImage = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    splashController.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return _firstSplashImage
        ? Scaffold(
            backgroundColor: Style.white,
            body: Center(
              child: Image.asset(
                "assets/images/logo tajiri.png",
                fit: BoxFit.fill,
              ),
            ),
          )
        : Image.asset(
            "assets/images/Launcher.png",
            fit: BoxFit.fill,
          );
  }
}
