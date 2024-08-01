import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/info_card.extension.dart';
import 'package:tajiri_waitress/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/amount_to_paid.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class MakeMobilePaiementScreen extends StatefulWidget {
  final Order? order;
  final MeansOfPaymentEntity mobileMeansOfPayment;
  const MakeMobilePaiementScreen(
      {super.key, this.order, required this.mobileMeansOfPayment});

  @override
  State<MakeMobilePaiementScreen> createState() =>
      _MakeMobilePaiementScreenState();
}

class _MakeMobilePaiementScreenState extends State<MakeMobilePaiementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Paiement via ${widget.mobileMeansOfPayment.name}",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
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
                    Divider(),
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
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: "Suivant",
                          textColor: Style.white,
                          background: Style.brandColor500,
                          radius: 4,
                          onPressed: () {},
                        ),
                      ),
                      12.horizontalSpace,
                      TotalCardComponent(
                        total: widget.order?.grandTotal,
                      )
                    ],
                  ),
                ],
              ),
            ),
            (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
          ],
        ),
      ),
    );
  }
}
