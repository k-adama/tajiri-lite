import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/small_add_button.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/images/common_image.dart';

class ProductGridItemComponent extends StatelessWidget {
  final FoodDataEntity? product;
  //final VoidCallback addCart;
  // final VoidCallback addCount;
  //final VoidCallback removeCount;
  final bool isAdd;
  final Color? borderColor;
  //final int count;
  final Function() onTap;

  const ProductGridItemComponent({
    super.key,
    required this.product,
    //required this.addCart,
    this.isAdd = false,
    // this.count = 0,
    // required this.addCount,
    //required this.removeCount,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product?.quantity == 0;
    return Opacity(
      opacity: isOutOfStock ? 0.3 : 1.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: isOutOfStock
            ? () {
                Mixpanel.instance
                    .track("POS Product Out Stock Cliked", properties: {
                  "Product name": product?.name,
                  "Product ID": product?.id,
                  "Category": product?.category?.name,
                  "Selling Price": product?.price
                });
                return;
              }
            : onTap,
        child: Container(
          key: Key("${product?.id}"),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Style.white,
          ),
          margin: const EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImage(
                      height: 130,
                      imageUrl: product?.imageUrl,
                      radius: 0,
                    ),
                    8.verticalSpace,
                    SingleChildScrollView(
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product?.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -14 * 0.02,
                                      color: Style.black,
                                    ),
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    product?.quantity != 0
                                        ? product?.quantity != 0
                                            ? '${product?.quantity ?? product?.type}  en stock'
                                            : 'Rupture'
                                        : 'Rupture',
                                    style: Style.interRegular(
                                      size: 12,
                                      color: product?.quantity == 0
                                          ? Style.red
                                          : Style.grey600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    '${product?.price} FCFA',
                                    overflow: TextOverflow.ellipsis,
                                    style: Style.interNoSemi(
                                      size: 11,
                                      color: Style.black,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                              child: SmallAddButtonComponent(
                                onTap: () {},
                                width: 30,
                                height: 30,
                                color: Style.brandBlue950,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: borderColor ?? Style.brandColor50,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.r),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
