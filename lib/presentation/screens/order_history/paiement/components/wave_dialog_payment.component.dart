import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/info_card.extension.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class WaveDialogComponent extends StatelessWidget {
  const WaveDialogComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Numéro de téléphone",
            style: Style.interBold(),
          ),
          Text(
            "Veuillez saisir le numéros de téléphone du client.",
            style: Style.interNormal(size: 13, color: Style.grey500),
          ),
          12.verticalSpace,
          TextFormField(
            controller: TextEditingController(),
            cursorColor: Style.brandColor500,
            style: Style.interNormal(
              size: 13,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              focusedBorder: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Style.grey100,
                  width: .5,
                ),
              ),
            ),
          ),
          24.verticalSpace,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'En faisant ',
                  style: Style.interNormal(
                    size: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '"suivant" ',
                  style: Style.interNormal(
                    size: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      'un lien de validation sera envoyé au numéro du client.',
                  style: Style.interNormal(
                    size: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ).infoCardBg(),
          24.verticalSpace,
          CustomButton(
            title: "Valider le paiement",
            textColor: Style.white,
            background: Style.brandColor500,
            radius: 4,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
