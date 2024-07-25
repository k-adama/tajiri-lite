import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/side_dish_food_list.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/food_detail_update_price.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/type_of_cooking.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class FoodDetailModalComponent extends StatefulWidget {
  final Product? product;
  final VoidCallback addCart;
  final VoidCallback addCount;
  final VoidCallback removeCount;
  final List<String?>? initSelectDish;
  final String? initTypeOfCooking;
  final bool? isUpdateModal;
  const FoodDetailModalComponent(
      {super.key,
      this.product,
      this.initSelectDish,
      required this.addCart,
      required this.addCount,
      required this.removeCount,
      this.isUpdateModal = false,
      this.initTypeOfCooking});

  @override
  State<FoodDetailModalComponent> createState() =>
      _FoodDetailModalComponentState();
}

class _FoodDetailModalComponentState extends State<FoodDetailModalComponent> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(builder: (posController) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Style.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                Center(
                  child: Container(
                    height: 4.h,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Style.brandBlue950,
                        borderRadius: BorderRadius.all(Radius.circular(40.r))),
                  ),
                ),
                FoodDetailUpdatePrice(
                  product: widget.product,
                ),
                8.verticalSpace,
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Divider(thickness: 1),
                ),
                8.verticalSpace,
                SizedBox(
                  height: 400.h,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (widget.product?.hasTypesOfCooking == true)
                          TypeOfCookingComponent(
                            initTypeOfCooking: widget.initTypeOfCooking,
                          ),
                        8.verticalSpace,
                        if (widget.product?.hasTypesOfCooking == true)
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Divider(thickness: 1),
                          ),
                        8.verticalSpace,
                        if (widget.product?.hasSideDishes == true)
                          SideDishFoodListComponent(
                            productData: widget.product!,
                            dishes: posController.productsInit
                                .where((element) => element.isSideDish)
                                .toList(),
                            product: widget.product,
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Column(
                    children: [
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 40.h,
                            width: 190.w,
                            child: CustomButton(
                              background: Style.brandColor500,
                              textColor: Style.white,
                              title: widget.isUpdateModal == true
                                  ? "Mettre à jour le panier"
                                  : "Ajouter au panier",
                              radius: 5,
                              haveBorder: true,
                              borderColor: Style.brandColor500,
                              onPressed: widget.addCart,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Total (en FCFA)",
                                style: Style.interNormal(
                                  size: 13,
                                ),
                              ),
                              Text(
                                "${posController.priceAddFood.value * posController.quantityAddFood}"
                                    .toString(),
                                style: Style.interBold(
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
              ],
            ),
          ),
        ),
      );
    });
  }
}
