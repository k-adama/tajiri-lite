import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/main_item.entity.dart';

class OrdersInformationsDisplayComponent extends StatelessWidget {
  final MainCartEntity? cart;
  final VoidCallback? add;
  final VoidCallback? remove;
  final VoidCallback? delete;
  const OrdersInformationsDisplayComponent({
    super.key,
    this.add,
    this.remove,
    this.cart,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Style.white, borderRadius: BorderRadius.circular(2)),
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${cart?.name}",
                        // "${cart?.name} ${(cart?.typeOfCooking?.isNotEmpty ?? false) ? '(${cart?.typeOfCooking})' : ''}",
                        style: Style.interNormal(size: 13.sp),
                      ),
                      2.verticalSpace,
                      /* cart!.sideDishes!.isEmpty
                          ? const SizedBox()
                          : DisplaySideDishOrTypeCooking(
                              sideDishes: cart!.sideDishes),*/
                      2.verticalSpace,
                      Text(
                        "${cart?.price}".currencyLong(),
                        style: Style.interBold(
                          size: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: const BoxDecoration(
                      color: Style.white, shape: BoxShape.circle),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "${cart!.quantity}",
                        style: Style.interBold(
                            size: 15.sp, color: Style.brandColor500),
                      ),
                    ),
                  ),
                ),
                20.horizontalSpace,
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Style.brandColor500,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "modifier",
                        style: Style.interBold(
                            color: Style.brandColor500, size: 13.sp),
                      ),
                    ),
                  ),
                ) // AddOrRemoveItemComponent(add: add!, remove: remove!)
              ],
            ),
          ),
          10.verticalSpace,
          Divider(
            color: Style.brandColorBlue100,
            height: 0.5.h,
          ),
          5.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: InkWell(
              onTap: () {
                // delete!.call();
              },
              child: Text(
                "Supprimer",
                style: Style.interBold(
                    color: Style.brandColor500,
                    underLineColor: Style.brandColor500,
                    isUnderLine: true,
                    size: 10.sp),
              ),
            ),
          )
        ],
      ),
    );
  }
}
