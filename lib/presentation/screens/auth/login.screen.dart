import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.controller.dart';
import 'package:tajiri_waitress/presentation/screens/auth/components/login/login_screen.component.dart';
import 'package:tajiri_waitress/presentation/ui/keyboard_dismisser.ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (authController) => KeyboardDismisserUi(
              child: AbsorbPointer(
                  absorbing: authController.isLoading,
                  child: Scaffold(
                     resizeToAvoidBottomInset: true,
                    backgroundColor: Style.primaryColor,
                    body: LoginScreenComponent(
                      icon: authController.password.isNotEmpty
                          ? SvgPicture.asset(
                              authController.showPassword
                                  ? '${TrKeysConstant.svgPath}fluent_eye-24-regular.svg'
                                  : '${TrKeysConstant.svgPath}tabler_eye-closed.svg',
                              height: 20.h,
                            )
                          : Container(),
                    ),
                  )),
            ));
  }
}
