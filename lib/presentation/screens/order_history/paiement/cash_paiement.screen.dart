import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/amount_to_paid.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class CashPaiementScreen extends StatefulWidget {
  final Order? order;
  const CashPaiementScreen({super.key, required this.order});

  @override
  State<CashPaiementScreen> createState() => _CashPaiementScreenState();
}

class _CashPaiementScreenState extends State<CashPaiementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Paiement Cash",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Saisir le montant reçu',
                      style: Style.interNormal(size: 12, color: Style.grey500),
                    ),
                    Expanded(
                      child: Container(
                        width: 150,
                        height: 40,
                        child: TextFormField(
                          controller: TextEditingController(),
                          cursorColor: Style.brandColor500,
                          style: Style.interBold(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Style.brandColor500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Rendu monnaie',
                      style: Style.interNormal(size: 12, color: Style.grey500),
                    ),
                    Container(
                      width: 200,
                      child: const Divider(),
                    ),
                    Text(
                      '1.500 F CFA',
                      style: Style.interBold(size: 15, color: Style.grey950),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1.5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: "valider",
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
