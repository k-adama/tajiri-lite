import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/amount_to_paid.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/wave_dialog_payment.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/make_mobile_paiement.screen.dart';

class MobileMoneyPaiementScreen extends StatefulWidget {
  final Order? order;
  final MeansOfPaymentEntity mobileMeansOfPayment;

  const MobileMoneyPaiementScreen(
      {super.key, required this.order, required this.mobileMeansOfPayment});

  @override
  State<MobileMoneyPaiementScreen> createState() =>
      _MobileMoneyPaiementScreenState();
}

class _MobileMoneyPaiementScreenState extends State<MobileMoneyPaiementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Mobile money",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: widget.mobileMeansOfPayment.items!.map((e) {
                  // bool isSelect = currentMeansOfPayment?.id == e.id;
                  return GestureDetector(
                    onTap: () {
                      // if (e.name == "Wave") {
                      //   Get.defaultDialog(
                      //       title: "",
                      //       contentPadding:
                      //           const EdgeInsets.symmetric(horizontal: 24),
                      //       content: const WaveDialogComponent());
                      // }

                      Get.to(
                        MakeMobilePaiementScreen(
                            order: widget.order, mobileMeansOfPayment: e),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Style.grey100,
                            ),
                          ),
                          child: Center(
                            child: AppHelpersCommon.checkIsSvg(e.icon)
                                ? SvgPicture.asset(
                                    e.icon,
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.asset(
                                    e.icon,
                                    width: 40,
                                    height: 40,
                                  ),
                          ),
                        ),
                        Text(
                          e.name,
                          style: Style.interNormal(
                            color: Style.grey950,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 160),
              AmountToPaidComponent(orderDetails: widget.order?.orderProducts),
            ],
          ),
        ),
      ),
    );
  }
}
