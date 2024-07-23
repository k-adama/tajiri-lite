import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_sdk/src/models/main-category.model.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/sale_category.entity.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/images/custom_network_image.dart';

class CategoryStatistique extends StatelessWidget {
  final MainCategory category;
  final SaleCategoryEntity? saleByCategory;
  final int nbrProduct;
  const CategoryStatistique(
      {super.key,
      required this.category,
      required this.nbrProduct,
      required this.saleByCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: Style.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: CustomNetworkImage(
                    url: category.iconUrl ,
                    height: null,
                    width: null,
                    radius: 180,
                  ),
                ),
              ),
              4.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                      style: Style.interBold(size: 14),
                    ),
                    4.verticalSpace,
                    Text(
                      "$nbrProduct produit(s)",
                      style: Style.interNormal(
                        size: 10,
                        color: Style.grey700,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Style.grey700, width: .5),
                        ),
                        child: Text(
                          "${saleByCategory?.count ?? "0"} vente(s)",
                          style: Style.interNormal(
                            size: 10,
                            color: Style.grey700,
                          ),
                        ),
                      ),
                    ),
                    3.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        '${saleByCategory?.totalAmount ?? "0"}  FCFA',
                        overflow: TextOverflow.ellipsis,
                        style: Style.interBold(size: 14),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
