import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/means_paiement_entity.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/paiement/paiement.controller.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/amount_to_paid.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/split_order.screen.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/split_paiement.screen.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class PaiementScreen extends StatefulWidget {
  const PaiementScreen({super.key});

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final controller = Get.find<PaiementController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Encaisser un paiement",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Text(
                    "Moyens de Paiement",
                    style: Style.interBold(
                      size: 16,
                    ),
                  ),
                  Text(
                    'Veuillez sélectionner un moyen de paiement.',
                    style: Style.interNormal(size: 12, color: Style.grey600),
                  ),
                  20.verticalSpace,
                  ...MEANS_OF_PAYEMENT
                      .map((e) => GestureDetector(
                            onTap: () {
                              controller.selectPaiement(e);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Style.grey200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: AppHelpersCommon.checkIsSvg(e.icon)
                                          ? SvgPicture.asset(
                                              e.icon,
                                              width: 30,
                                              height: 30,
                                              color: Style.grey300,
                                            )
                                          : Image.asset(
                                              e.icon,
                                              width: 30,
                                              height: 30,
                                              color: Style.grey300,
                                            ),
                                    ),
                                  ),
                                  Text(
                                    e.name,
                                    style: Style.interNormal(
                                        color: Style.grey800, size: 13),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: Style.grey500,
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1.5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                CustomButton(
                  title: "Scinder la commande",
                  textColor: Style.brandColor500,
                  isUnderline: true,
                  background: Style.brandColor50,
                  radius: 4,
                  onPressed: () {
                    final copyOrderData =
                        controller.currentOrder; //receveidOrderOrder
                    final copyOrderDetails = copyOrderData!.orderProducts;
                    Get.to(
                      SplitOrderScreen(
                        orderProduct: copyOrderDetails,
                        orderData: copyOrderData,
                      ),
                    );
                  },
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: "Diviser le paiement",
                        textColor: Style.white,
                        background: Style.brandColor500,
                        radius: 4,
                        onPressed: () {
                          Get.to(SplitPaiementScreen(
                            order: controller.currentOrder,
                          ));
                        },
                      ),
                    ),
                    12.horizontalSpace,
                    TotalCardComponent(
                      total: controller.currentOrder?.grandTotal,
                    )
                  ],
                ),
              ],
            ),
          ),
          (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
        ],
      ),
    );
  }
}
