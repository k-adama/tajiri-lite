import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/custom_pos_roundedButton.component.dart';

class SeeCartButtonComponent extends StatelessWidget {
  const SeeCartButtonComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomPosRoundedButtonComponent(
                onTap: () {
                  Get.toNamed(Routes.CART);
                },
                text: posController.quantityProduct(),
              ),
            ),
            10.horizontalSpace,
            SizedBox(
              width: 48,
              height: 48,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Style.brandBlue950,
                  onPressed: () {
                    Get.toNamed(Routes.ORDER_HISTORY);
                  },
                  child: Image.asset(
                      'assets/images/icon-park-solid_transaction-order.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
