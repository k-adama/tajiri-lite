import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
        ...SETTLE_ORDERS.map((e) {
          return Obx(() {
            final isSelect = posController.settleOrderId.value == e["id"];

            return InkWell(
              onTap: () {
                posController.settleOrderId.value = e["id"];
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
                            color: isSelect ? Style.brandColor500 : Style.white,
                            borderRadius: BorderRadius.circular(5),
                            border: isSelect
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
                              ),
                            ),
                          )),
                      Text(
                        e["name"],
                        style: Style.interNormal(
                          color: Style.brandColor500,
                          size: 15.sp,
                          fontWeight:
                              isSelect ? FontWeight.w700 : FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        }),
      ],
    );
  }
}
