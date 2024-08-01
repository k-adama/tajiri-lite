import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/printer_model.entity.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/draggable_itemorder.component.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/paiement/components/subcart_item.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/icon_with_text.button.dart';

class SplitOrderScreen extends StatefulWidget {
  final List<OrderProduct>? orderProduct;
  final Order? orderData;
  const SplitOrderScreen({super.key, this.orderProduct, this.orderData});

  @override
  State<SplitOrderScreen> createState() => _SplitOrderScreenState();
}

class _SplitOrderScreenState extends State<SplitOrderScreen> {
  List<SubCartItem> subOrders = [
    SubCartItem(orderPrinterProducts: []),
    SubCartItem(orderPrinterProducts: []),
  ];

  late List<OrderPrinterProduct> ordersPrinterProduct;

  final Staff? user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();

  @override
  void initState() {
    ordersPrinterProduct = widget.orderProduct == null
        ? []
        : widget.orderProduct!.map((e) => e.toOrderPrinterProduct()).toList();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // orders.clear();
    super.dispose();
  }

  bool splitIsComplete() {
    return ordersPrinterProduct.isEmpty;
  }

  printReceipts() {
    // final bluetoothController =
    //     Get.find<NavigationController>().printerController;

    // if (!bluetoothController.canPrint()) {
    //   Get.toNamed(Routes.SETTING_PRINTER);
    // } else {
    //   subOrders.removeWhere((element) => element.orderPrinterProducts.isEmpty);
    //   if (widget.orderData != null) {
    //     Get.find<PrinterSettingController>().printManyReceipt(
    //       widget.orderData!.toPrinterModelEntity(
    //         user?.lastname,
    //         restaurant?.name,
    //         restaurant?.phone,
    //       ),
    //       subOrders,
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(
          "Scinder la commande",
          style: Style.interBold(),
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    "Glisser les éléments du menu dans les paniers en dessous afin de créer des factures différentes pour chaque panier créé .",
                    style: Style.interNormal(color: Style.grey700, size: 13),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: ScrollController(),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shrinkWrap: true,
                            itemCount: ordersPrinterProduct.length,
                            itemBuilder: (context, index) {
                              return DraggableItemOrderComponent(
                                orderPrinterProduct:
                                    ordersPrinterProduct[index],
                              );
                            },
                          ),
                        ),
                      ),
                      24.horizontalSpace,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 5),
                          decoration: const BoxDecoration(
                            color: Style.grey50,
                          ),
                          child: ListView(
                            children: [
                              ...subOrders.map((subCart) {
                                final index = subOrders.indexOf(subCart);
                                return SubCartItemComponent(
                                  onAcceptWithDetails: (res) {
                                    final data = res.data; //copyWith
                                    setState(() {
                                      // Vérifie si l'élément est déjà présent dans le sous-panier
                                      bool isAlreadyAdded = subCart
                                          .orderPrinterProducts
                                          .any((item) =>
                                              item.orderProductid ==
                                              data.orderProductid);

                                      if (isAlreadyAdded) {
                                        // Si l'élément est déjà présent, additionne les quantités
                                        OrderPrinterProduct? existingOrder =
                                            subCart
                                                .orderPrinterProducts
                                                .firstWhereOrNull((item) =>
                                                    item.orderProductid ==
                                                    data.orderProductid);
                                        if (existingOrder != null) {
                                          existingOrder.quantity =
                                              existingOrder.quantity +
                                                  data.quantity;
                                        }
                                      } else {
                                        // Si l'élément n'est pas présent, ajoute-le au sous-panier
                                        subCart.orderPrinterProducts.add(data);
                                      }
                                      ordersPrinterProduct.removeWhere(
                                          (element) =>
                                              element.orderProductid ==
                                              data.orderProductid);
                                    });
                                  },
                                  subCart: subCart,
                                  decrementQuantity: decrementQuantity,
                                  incrementQuantity: incrementQuantity,
                                  numberCart: index,
                                );
                              }),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: IconWithTextButton(
                                      isGrised: splitIsComplete(),
                                      titleColor: Style.brandColor500,
                                      title: "Nouveau bloc",
                                      isSecondary: true,
                                      icon: Icons.add,
                                      bgColor: Style.brandColor500,
                                      onPressed: () {
                                        setState(() {
                                          subOrders.add(SubCartItem(
                                              orderPrinterProducts: []));
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const Divider(thickness: 1.5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              isGrised: !splitIsComplete(),
              background: Style.brandColor500,
              textColor: Style.white,
              title: "Faire payer",
              radius: 5,
              onPressed: () {
                printReceipts();
              },
            ),
          ),
          (MediaQuery.of(context).padding.bottom + 10).verticalSpace,
        ],
      ),
    );
  }

  void incrementQuantity(OrderPrinterProduct orderPrinter) {
    // Vérifie si le produit existe dans le panier principal (orders)
    bool existsInOrders = ordersPrinterProduct
        .any((item) => item.orderProductid == orderPrinter.orderProductid);
    print(existsInOrders);
    if (existsInOrders) {
      OrderPrinterProduct? existingOrder =
          ordersPrinterProduct.firstWhereOrNull(
        (item) => item.orderProductid == orderPrinter.orderProductid,
      );

      if (existingOrder != null) {
        // Retire un élément de la quantité du produit dans le panier principal

        setState(() {
          if (existingOrder.quantity > 1) {
            existingOrder.quantity = existingOrder.quantity - 1;
          } else {
            ordersPrinterProduct.removeWhere((element) =>
                element.orderProductid == existingOrder.orderProductid);
          }
        });

        // Ajoute un élément à la quantité du produit dans le sous-panier
        setState(() {
          orderPrinter.quantity = orderPrinter.quantity + 1;
        });
      }
    } else {
      print("Impossible");
    }
  }

  void decrementQuantity(
      OrderPrinterProduct orderPrinter, SubCartItem subCart) {
    if (orderPrinter.quantity > 1) {
      setState(() {
        orderPrinter.quantity = orderPrinter.quantity - 1;
      });
    } else {
      setState(() {
        subCart.orderPrinterProducts.remove(orderPrinter);
      });
    }

    // Ajoute l'élément au panier principal
    bool existsInOrders = ordersPrinterProduct
        .any((item) => item.orderProductid == orderPrinter.orderProductid);

    if (existsInOrders) {
      // Incrémente la quantité du produit dans le panier principal
      OrderPrinterProduct? existingOrder =
          ordersPrinterProduct.firstWhereOrNull(
        (item) => item.orderProductid == orderPrinter.orderProductid,
      );

      if (existingOrder != null) {
        setState(() {
          existingOrder.quantity = existingOrder.quantity + 1;
        });
      }
    } else {
      // Ajoute le produit au panier principal avec une quantité de 1
      OrderPrinterProduct newOrder = orderPrinter.copyWith(quantity: 1);
      setState(() {
        ordersPrinterProduct.add(newOrder);
      });
    }
  }
}

class SubCartItem {
  List<OrderPrinterProduct> orderPrinterProducts;
  SubCartItem({required this.orderPrinterProducts});
}
