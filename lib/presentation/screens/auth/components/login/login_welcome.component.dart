import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/constants/tr_keys.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/auth/components/login/alert_message.component.dart';

class LoginWelcomeComponent extends StatelessWidget {
  final bool showError;
  final Function()? onTap;
  const LoginWelcomeComponent({super.key, this.showError = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        25.verticalSpace,
        SvgPicture.asset("assets/svgs/logo_tajiri.svg", height: 200.h),
        showError
            ? const SizedBox()
            : RichText(
                text: TextSpan(
                  text: TrKeysConstant.welcomeText,
                  style:
                      Style.interBold(size: 30.sp, color: Style.secondaryColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: " !",
                        style: Style.interNormal(
                            size: 30.sp, color: Style.secondaryColor)),
                  ],
                ),
              ),
        20.verticalSpace,
        showError
            ? const SizedBox()
            : SizedBox(
                width: 320.w,
                child: Text(
                  TrKeysConstant.descriptionAppText,
                  textAlign: TextAlign.center,
                  style: Style.interNormal(
                      size: 15.sp, color: Style.secondaryColor),
                ),
              ),
        40.verticalSpace,
        showError
            ? AuthAlertMessageComponent(
                onTap: onTap,
              )
            : Container(),
        40.verticalSpace,
      ],
    );
  }
}
