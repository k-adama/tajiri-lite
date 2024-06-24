import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/categorie_statistique.component.dart';

class SaleByCategoriyComponent extends StatefulWidget {
  final List<OrdersDataEntity> orders;
  const SaleByCategoriyComponent({super.key, required this.orders});

  @override
  State<SaleByCategoriyComponent> createState() =>
      _SaleByCategoriyComponentState();
}

class _SaleByCategoriyComponentState extends State<SaleByCategoriyComponent> {
  //Map<String?, SaleCategoryEntity> salesByCategories = {};

  @override
  void initState() {
    // salesByCategories = countAndSumOrdersByCategorie(widget.orders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoHeightGridView(
      shrinkWrap: true,
      itemCount: 4,
      crossAxisCount: 2,
      mainAxisSpacing: 10.r,
      builder: (context, index) {
        //final element = posController.categoriesSupabase[index];
        return AnimationConfiguration.staggeredGrid(
          columnCount: 4,
          position: index,
          duration: const Duration(milliseconds: 375),
          child: ScaleAnimation(
            scale: 0.5,
            child: FadeInAnimation(
              child: CategoryStatistique(
                  // category: element,
                  // nbrProduct: posController
                  // .getNbrProductByCategorie(element.id),
                  //saleByCategory: salesByCategories[element.id],
                  ),
            ),
          ),
        );
      },
    );
    /*GetBuilder<PosController>(
        builder: (posController) =>
            /* posController.categoriesSupabase.isEmpty
            ? const SizedBox.shrink()
            : */
            AutoHeightGridView(
              shrinkWrap: true,
              itemCount: 8,
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              builder: (context, index) {
                //final element = posController.categoriesSupabase[index];
                return AnimationConfiguration.staggeredGrid(
                  columnCount: 8,
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: ScaleAnimation(
                    scale: 0.5,
                    child: FadeInAnimation(
                      child: CategoryStatistique(
                          // category: element,
                          // nbrProduct: posController
                          // .getNbrProductByCategorie(element.id),
                          //saleByCategory: salesByCategories[element.id],
                          ),
                    ),
                  ),
                );
                
              },
            )
            );*/
  }
}

/*Map<String?, SaleCategoryEntity> countAndSumOrdersByCategorie(
    List<OrdersDataEntity> orders) {
  Map<String?, SaleCategoryEntity> orderSummaryByCategory = {};

  for (var order in orders) {
    order.orderDetails?.forEach((product) {
      String? mainCategoryId = product.food?.mainCategoryId ?? 'Unknown';

      var saleCategory = orderSummaryByCategory[mainCategoryId] ??
          SaleCategoryEntity(
            idCategory: mainCategoryId,
            count: 0,
            totalAmount: 0,
          );

      saleCategory.count += (product.quantity ?? 0);
      saleCategory.totalAmount +=
          ((product.price ?? 0) * (product.quantity ?? 0));

      orderSummaryByCategory[mainCategoryId] = saleCategory;
    });
  }

  return orderSummaryByCategory;
}*/
