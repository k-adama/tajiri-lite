import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';

class MainAppbarComponent extends StatefulWidget {
  const MainAppbarComponent({super.key});

  @override
  State<MainAppbarComponent> createState() => _MainAppbarComponentState();
}

class _MainAppbarComponentState extends State<MainAppbarComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 15.r),
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(10.r)),
        ),
      ),
    );
  }
}
