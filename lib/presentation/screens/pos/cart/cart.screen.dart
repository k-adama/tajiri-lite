import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/cart/components/orders_informations_display.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/order_detail_confirm_modal.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final user = AppHelpersCommon.getUserInLocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Panier",
          style: Style.interBold(
            size: 20,
            color: Style.brandBlue950,
          ),
        ),
        iconTheme: const IconThemeData(color: Style.brandBlue950),
        backgroundColor: Style.white,
      ),
      backgroundColor: Style.bodyNewColor,
      body: GetBuilder<PosController>(builder: (posController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Scrollbar(
                controller: ScrollController(),
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shrinkWrap: true,
                    itemCount: posController.selectbag.bagProducts.length,
                    itemBuilder: (context, index) {
                      List<MainCartEntity> cartItems =
                          posController.selectbag.bagProducts;

                      final cartItem = cartItems[index];

                      return OrdersInformationsDisplayComponent(
                        cart: cartItem,
                        delete: () {
                          posController.removeItemInBag(cartItem);
                        },
                      );
                    }),
              ),
            ),
            bottomWidget(context, posController),
          ],
        );
      }),
    );
  }

  Widget bottomWidget(BuildContext context, PosController posController) {
    return Container(
      decoration: const BoxDecoration(
          color: Style.white,
          border: Border(top: BorderSide(width: 0.5, color: Style.grey300))),
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.w, bottom: 50),
      child: Column(
        children: [
          CustomButton(
            background: Style.brandColor50,
            title: "Ajouter un produit",
            textColor: Style.brandColor500,
            haveBorder: false,
            radius: 5,
            icon: const Icon(
              Icons.add,
              color: Style.brandColor500,
            ),
            isUnderline: true,
            onPressed: () {
              Get.back();
            },
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 45,
                  child: CustomButton(
                    background: Style.brandColor500,
                    title: "Envoyer à la caisse",
                    textColor: Style.white,
                    isLoadingColor: Style.white,
                    haveBorder: false,
                    radius: 5,
                    onPressed: () {
                      AppHelpersCommon.showCustomModalBottomSheet(
                        context: context,
                        modal: Obx(() {
                          return OrderConfirmDetailModalComponent(
                            isLoading: posController.createOrderLoading.value,
                            confirmOrder: () {
                              posController.handleCreateOrder(context);
                            },
                          );
                        }),
                        isDarkMode: false,
                        isDrag: true,
                        radius: 12,
                      );
                    },
                  ),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Style.grey50.withOpacity(0.2),
                        border: Border.all(
                          color: Style.grey500,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Total (En FCFA)",
                        ),
                        Text(
                          "${posController.calculateBagProductTotal().toInt()}",
                          style: Style.interBold(color: Style.brandBlue950),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
