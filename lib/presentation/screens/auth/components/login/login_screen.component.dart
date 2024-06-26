import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.controller.dart';
import 'package:tajiri_waitress/presentation/screens/auth/components/login/login_welcome.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/text/forgot_button.text.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';

class LoginScreenComponent extends StatefulWidget {
  final Widget icon;
  const LoginScreenComponent({super.key, required this.icon});

  @override
  State<LoginScreenComponent> createState() => _LoginScreenComponentState();
}

class _LoginScreenComponentState extends State<LoginScreenComponent> {
  bool showError = false;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/background_pattern.png",
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          //reverse: true,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
              child: Column(
                children: [
                  LoginWelcomeComponent(
                    showError: showError,
                    onTap: () {
                      setState(() {
                        showError = false;
                      });
                    },
                  ),
                  OutlinedBorderTextFormField(
                      labelText: TrKeysConstant.phoneOrEmailLabelText,
                      onChanged: authController.setEmail,
                      isError: authController.isEmailNotValid,
                      descriptionText: authController.isEmailNotValid
                          ? TrKeysConstant.phoneOrEmailDescriptionText
                          : (authController.isLoginError ? "Pas valide" : null),
                      haveBorder: true,
                      isFillColor: true,
                      borderRaduis: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      hintColor: Style.dark),
                  1.verticalSpace,
                  OutlinedBorderTextFormField(
                    labelText: TrKeysConstant.passwordLabelText,
                    obscure: authController.showPassword,
                    hintColor: Style.dark,
                    haveBorder: true,
                    isFillColor: true,
                    borderRaduis: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      splashRadius: 25,
                      padding: const EdgeInsets.only(right: 4),
                      icon: widget.icon,
                      onPressed: () => authController
                          .setShowPassword(!authController.showPassword),
                    ),
                    onChanged: authController.setPassword,
                    isError: authController.isPasswordNotValid,
                    descriptionText: authController.isPasswordNotValid
                        ? TrKeysConstant.passwordDescriptionText
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      ForgotTextButton(
                        title: TrKeysConstant.forgetPasswordText,
                        fontColor: Style.brandBlue950,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  80.verticalSpace,
                  SizedBox(
                      width: 400.w,
                      child: CustomButton(
                        isLoading: authController.isLoading,
                        background: Style.secondaryColor,
                        textColor: Style.white,
                        isLoadingColor: Style.white,
                        title: TrKeysConstant.connexionButtonLoginText,
                        radius: 5,
                        onPressed: () {
                            authController.login(context).then((success) {
                                if (authController.isLoginError ||
                                    authController.isPasswordNotValid ||
                                    authController.isEmailNotValid) {
                                  setState(() {
                                    showError = true;
                                  });
                                }
                              });
                        },
                      )),
                  100.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
