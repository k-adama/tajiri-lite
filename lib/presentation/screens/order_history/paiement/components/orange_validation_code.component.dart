import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class OrangeValidationCodeComponent extends StatefulWidget {
  const OrangeValidationCodeComponent({super.key});

  @override
  State<OrangeValidationCodeComponent> createState() =>
      _OrangeValidationCodeComponentState();
}

class _OrangeValidationCodeComponentState
    extends State<OrangeValidationCodeComponent> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      margin: const EdgeInsets.only(left: 1),
      textStyle: Style.interNormal(size: 22.sp, color: Style.black),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Style.white)),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Code de confirmation Orange Money",
          style: Style.interBold(),
        ),
        Text(
          "Veuillez saisir le code à quatre chiffres reçu par le client.",
          style: Style.interNormal(size: 13, color: Style.grey500),
        ),
        12.verticalSpace,
        Pinput(
          length: 4,
          onChanged: (value) {},
          defaultPinTheme: defaultPinTheme.copyWith(
            width: 40,
            height: 40,
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(
                color: Style.grey200,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onCompleted: (pin) {
            // checkoutController.otpEnters = pin;
          },
        ),
        25.verticalSpace,
      ],
    );
  }
}
