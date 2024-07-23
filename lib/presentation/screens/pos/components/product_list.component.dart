import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/food_detail_modal.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/product_grid_item.component.dart';

class ProductsListComponent extends StatefulWidget {
  final List<Product>? foodList;
  const ProductsListComponent({super.key, this.foodList});

  @override
  State<ProductsListComponent> createState() => _ProductsListComponentState();
}

class _ProductsListComponentState extends State<ProductsListComponent> {
  final refresh.RefreshController _refreshController =
      refresh.RefreshController();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh(PosController posController) async {
    // await posController.fetchFoods();
    _refreshController.refreshCompleted();
  }

  void _onLoading(PosController posController) async {
    // await posController.fetchFoods();
    _refreshController.loadComplete();
  }

  addToCart(Product food, PosController posController) {
    if (food.quantity == 0) {
      return;
    }

    posController.addToCart(food);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(builder: (posController) {
      return posController.isProductLoading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Style.brandColor500,
            ))
          : AnimationLimiter(
              child: refresh.SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                onLoading: () {
                  _onLoading(posController);
                },
                onRefresh: () {
                  _onRefresh(posController);
                },
                controller: _refreshController,
                child: AutoHeightGridView(
                  shrinkWrap: true,
                  itemCount:
                      widget.foodList?.length ?? posController.products.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.r,
                  builder: (context, index) {
                    final product = widget.foodList?[index] ??
                        posController.products[index];
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: 20,
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: ScaleAnimation(
                        scale: 0.5,
                        child: FadeInAnimation(
                            child: ProductGridItemComponent(
                          key: Key("${product.id}"),
                          product: product,
                          onTap: () async {
                            print(
                                "================================> catégory : ${product.category.name}");
                            posController.setPriceAddFood(product.price);
                            await AppHelpersCommon.showCustomModalBottomSheet(
                              context: context,
                              modal: FoodDetailModalComponent(
                                key: Key(product.id),
                                product: product,
                                addCart: () {
                                  addToCart(product, posController);
                                  Get.close(0);
                                },
                                addCount: () {
                                  //addCount(food);
                                },
                                removeCount: () {
                                  //_posController.removeCount(food, null);
                                },
                              ),
                              isDarkMode: false,
                              isDrag: true,
                              radius: 12,
                            );
                            posController
                                .handleAddModalFoodInCartItemInitialState(); //reset state
                          },
                        )),
                      ),
                    );
                  },
                ),
              ),
            );
    });
  }
}
