import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/food_detail_modal.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/product_grid_item.component.dart';

class ProductsListComponent extends StatefulWidget {
  const ProductsListComponent({super.key});

  @override
  State<ProductsListComponent> createState() => _ProductsListComponentState();
}

class _ProductsListComponentState extends State<ProductsListComponent> {
  final refresh.RefreshController _refreshController =
      refresh.RefreshController();

  final PosController posController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    await posController.fetchFoods();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await posController.fetchFoods();
    _refreshController.loadComplete();
  }

  addToCart(FoodDataEntity food) {
    if (food.quantity == 0) {
      return;
    }

    posController.addToCart(food);
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: refresh.SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        onLoading: () {
          _onLoading();
        },
        onRefresh: () {
          _onRefresh();
        },
        controller: _refreshController,
        child: AutoHeightGridView(
          shrinkWrap: true,
          itemCount: posController.foods.length,
          crossAxisCount: 2,
          mainAxisSpacing: 10.r,
          builder: (context, index) {
            final food = posController.foods[index];
            return AnimationConfiguration.staggeredGrid(
              columnCount: 20,
              position: index,
              duration: const Duration(milliseconds: 375),
              child: ScaleAnimation(
                scale: 0.5,
                child: FadeInAnimation(
                    child: ProductGridItemComponent(
                  key: Key("${food.id}"),
                  product: food,
                  onTap: () {
                    print(
                        "================================> catégory : ${food.category?.name}");
                    AppHelpersCommon.showCustomModalBottomSheet(
                      context: context,
                      modal: FoodDetailModalComponent(
                        key: Key("${food.id}"),
                        product: food,
                        addCart: () {
                          addToCart(food);
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
  }
}
