import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/product_grid_item.component.dart';

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
    // await posController.fetchFoods();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // await posController.fetchFoods();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (_posController) => AnimationLimiter(
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
            itemCount: 10,
            crossAxisCount: 2,
            mainAxisSpacing: 10.r,
            builder: (context, index) {
              //final element = posController.categoriesSupabase[index];
              return AnimationConfiguration.staggeredGrid(
                columnCount: 10,
                position: index,
                duration: const Duration(milliseconds: 375),
                child: ScaleAnimation(
                  scale: 0.5,
                  child: FadeInAnimation(
                      child: ProductGridItemComponent(
                    product: null,
                    onTap: () {},
                  )),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
