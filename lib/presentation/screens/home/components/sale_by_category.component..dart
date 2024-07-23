import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_sdk/src/models/order.model.dart';
import 'package:tajiri_waitress/domain/entities/sale_category.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/categorie_statistique.component.dart';

class SaleByCategoriyComponent extends StatefulWidget {
  final List<Order> orders;
  const SaleByCategoriyComponent({super.key, required this.orders});

  @override
  State<SaleByCategoriyComponent> createState() =>
      _SaleByCategoriyComponentState();
}

class _SaleByCategoriyComponentState extends State<SaleByCategoriyComponent> {
  Map<String?, SaleCategoryEntity> salesByCategories = {};

  @override
  void initState() {
    salesByCategories = countAndSumOrdersByCategorie(widget.orders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
        builder: (posController) => posController.mainCategories.isEmpty
            ? const SizedBox.shrink()
            : AutoHeightGridView(
                shrinkWrap: true,
                itemCount: 8,
                crossAxisCount: 2,
                mainAxisSpacing: 10.r,
                builder: (context, index) {
                  final element = posController.mainCategories[index];
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 8,
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: FadeInAnimation(
                        child: CategoryStatistique(
                          category: element,
                          nbrProduct: posController
                              .getNbrProductByCategorie(element.id),
                          saleByCategory: salesByCategories[element.id],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}

Map<String?, SaleCategoryEntity> countAndSumOrdersByCategorie(
    List<Order> orders) {
  Map<String?, SaleCategoryEntity> orderSummaryByCategory = {};

  for (var order in orders) {
    for (var product in order.orderProducts) {
      String? mainCategoryId = product.product.category.mainCategoryId;

      var saleCategory = orderSummaryByCategory[mainCategoryId] ??
          SaleCategoryEntity(
            idCategory: mainCategoryId,
            count: 0,
            totalAmount: 0,
          );

      saleCategory.count += (product.quantity);
      saleCategory.totalAmount += ((product.price) * (product.quantity));

      orderSummaryByCategory[mainCategoryId] = saleCategory;
    }
  }

  return orderSummaryByCategory;
}
