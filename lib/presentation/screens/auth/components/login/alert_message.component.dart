import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/round_back_button.dart';

class AuthAlertMessageComponent extends StatelessWidget {
  final Function()? onTap;
  const AuthAlertMessageComponent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 400.w,
        child: Stack(
          children: [
            Positioned(
              right: -5,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                // width: 60,
                child: InkWell(
                    onTap: onTap,
                    child: const SizedBox(
                        //width: 30,
                        child: RoundBackButton(
                            svgPath: "assets/svgs/loginVector.svg",
                            color: Style.transparent))),
              ),
            ),
            Column(
              children: [
                35.verticalSpace,
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 30,
                    child: Text('Identifiants incorrects',
                        textAlign: TextAlign.center,
                        style: Style.interBold(
                          color: Style.black,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Veuillez saisir le numéro et le mot de passe transmis à la souscription au service ou vous rapprocher de l’administrateur.',
                    textAlign: TextAlign.center,
                    style: Style.interNormal(size: 14),
                  ),
                ),
                25.verticalSpace,
              ],
            ),
          ],
        ));
  }
}
