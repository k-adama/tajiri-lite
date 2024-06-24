import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/images/custom_network_image.dart';

class CategoryStatistique extends StatelessWidget {
  //final CategorySupabaseEntity category;
  // final SaleCategoryEntity? saleByCategory;
  // final int nbrProduct;
  const CategoryStatistique({
    super.key,
    //required this.category,
    // required this.nbrProduct,
    //required this.saleByCategory
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
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
                    url: '',
                    height: null,
                    width: null,
                    radius: 180,
                  ),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'category name',
                      overflow: TextOverflow.ellipsis,
                      style: Style.interBold(size: 14),
                    ),
                    Text(
                      // "$nbrProduct produit(s)",
                      "10 produits",
                      style: Style.interNormal(
                        size: 8,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Style.grey700, width: .5),
                      ),
                      child: Text(
                        // "${saleByCategory?.count ?? "0"} vente(s)",
                        '50 ventes',
                        style: Style.interNormal(
                          size: 10,
                          color: Style.grey700,
                        ),
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      //'${saleByCategory?.totalAmount ?? "0"}  FCFA',
                      '2000 FCFA',
                      overflow: TextOverflow.ellipsis,
                      style: Style.interBold(size: 14),
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
