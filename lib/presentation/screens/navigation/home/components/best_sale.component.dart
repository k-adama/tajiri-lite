import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/extensions/string.extension.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/top_10_food.entity.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/home/components/sale_header.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/images/common_image.dart';

class BestSaleComponent extends StatefulWidget {
  //final List<OrdersDataEntity> orders;
  final String saleHeaderTitle;
  const BestSaleComponent(
      {super.key,
      //required this.orders,
      required this.saleHeaderTitle});

  @override
  State<BestSaleComponent> createState() => _BestSaleComponentState();
}

class _BestSaleComponentState extends State<BestSaleComponent> {
  List<Top10FoodEntity> top10Food = [];

  @override
  void initState() {
    //top10Food = getTop10Foods(widget.orders);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 310,
      height: 360,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Style.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SaleHeaderComponent(
            title: widget.saleHeaderTitle,
            rigthItemTitle: "Produit/total vente",
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              //top10Food.length,
              itemBuilder: (context, index) {
                //final top10 = top10Food[index];
                return BestSaleItemComponent(
                    // position: index + 1,
                    // top10: top10,
                    );
              },
            ),
          )
        ],
      ),
    );
  }
}

class BestSaleItemComponent extends StatelessWidget {
  // final Top10FoodEntity top10;
  //final int position;

  const BestSaleItemComponent({
    super.key,
    // required this.top10,
    // required this.position
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  //"$position°",
                  '1°',
                  style: Style.interBold(size: 12, color: Style.brandColor500),
                ),
                5.horizontalSpace,
                CommonImage(
                  width: 70,
                  height: 40,
                  imageUrl: '',
                  radius: 4,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //top10.food?.name ?? "_",
                        'food name',
                        overflow: TextOverflow.ellipsis,
                        style: Style.interNormal(
                          size: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        // top10.totalAmount.toString().currencyLong(),
                        "1000 FCFA",
                        style: Style.interBold(
                          size: 12,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          CardForCount(
            title: '2',
            //top10.count.toString(),
            color: Style.brandBlue950,
            titleColor: Style.white,
          )
        ],
      ),
    );
  }
}

List<Top10FoodEntity> getTop10Foods(List<OrdersDataEntity> orders) {
  Map<String?, Top10FoodEntity> groupedByFoods = {};

  for (var order in orders) {
    order.orderDetails?.forEach((product) {
      String foodId = product.foodId ?? product.bundleId ?? 'Unknown';

      if (groupedByFoods.containsKey(foodId)) {
        var selectTop10Food = groupedByFoods[foodId]!;
        groupedByFoods[foodId] = Top10FoodEntity(
          food: product.food,
          count: selectTop10Food.count + (product.quantity ?? 0),
          totalAmount: selectTop10Food.totalAmount +
              ((product.price ?? 0) * (product.quantity ?? 0)),
        );
      } else {
        groupedByFoods[foodId] = Top10FoodEntity(
          food: product.food,
          count: product.quantity ?? 0,
          totalAmount: ((product.price ?? 0) * (product.quantity ?? 0)),
        );
      }
    });
  }

  List<Top10FoodEntity> foodsData = groupedByFoods.values.toList();

  foodsData.sort((a, b) => b.count - a.count);
  if (foodsData.length <= 10) {
    return foodsData;
  } else {
    return foodsData.sublist(0, 10);
  }
}

class CardForCount extends StatelessWidget {
  final String title;
  final Color color;
  final Color titleColor;

  const CardForCount(
      {super.key,
      required this.title,
      required this.color,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: Style.interBold(size: 12, color: titleColor),
      ),
    );
  }
}
