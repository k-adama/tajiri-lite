import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

class OnPlaceInformationComponent extends StatefulWidget {
  const OnPlaceInformationComponent({super.key});

  @override
  State<OnPlaceInformationComponent> createState() =>
      _OnPlaceInformationComponentState();
}

class _OnPlaceInformationComponentState
    extends State<OnPlaceInformationComponent> {
  PosController posController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...SETTLE_ORDERS.map(
          (e) => InkWell(
            onTap: () {
              setState(() {
                posController.settleOrderId.value = e["id"];
              });
              print(posController.settleOrderId.value);
            },
            child: AnimationButtonEffect(
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Column(
                  children: [
                    Container(
                        width: 75.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: posController.settleOrderId.value == e["id"]
                              ? Style.brandColor500
                              : Style.white,
                          borderRadius: BorderRadius.circular(5),
                          border: posController.settleOrderId.value == e["id"]
                              ? Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Style.brandColor500)
                              : Border.all(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Style.brandBlue200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 10.w,
                            height: 10.h,
                            child: SvgPicture.asset(
                              e["icon"],
                              color: Style.brandBlue200,
                              /* posController.bags[posController.selectedBagIndex.value].settleOrderId == e["id"]
                                      ? Style.white
                                      : Style.brandBlue200,*/
                            ),
                          ),
                        )),
                    Text(
                      e["name"],
                      style: Style.interNormal(
                        color: Style.brandColor500,
                        size: 15.sp,
                      ),
                      /*posController.bags[posController.selectedBagIndex.value].settleOrderId == e["id"]
                          ? Style.interBold(
                              color: Style.brandColor500,
                              size: 18.sp,
                            )
                          : Style.interNormal(
                              color: Style.brandColor500,
                              size: 15.sp,
                            ),*/
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
