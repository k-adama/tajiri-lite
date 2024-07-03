import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/my_orders_statistiques.component.dart';

class OrderStatus {
  final int id;
  final String asset;
  final String title;

  OrderStatus({required this.id, required this.asset, required this.title});
}

class MyOrdersComponent extends StatefulWidget {
  final List<OrdersDataEntity> orders;

  const MyOrdersComponent({super.key, required this.orders});

  @override
  State<MyOrdersComponent> createState() => _MyOrdersComponentState();
}

class _MyOrdersComponentState extends State<MyOrdersComponent> {
  final List<OrderStatus> orderStatuses = [
    OrderStatus(asset: 'assets/svgs/inkitchen.svg', title: 'En cuisine', id: 0),
    OrderStatus(
        asset: 'assets/svgs/enattente.svg',
        title: 'Paiement en attente',
        id: 1),
    OrderStatus(
        asset: 'assets/svgs/dejaservie.svg', title: 'Déjà servie', id: 2),
    OrderStatus(
        asset: 'assets/svgs/Union.svg', title: 'Paiement effectué', id: 3)
  ];

  int getValue(OrderStatus status) {
    if (status.id == 3) {
      //Paiement effectué
      return widget.orders
          .where((element) => element.status == AppConstants.ORDER_PAID)
          .toList()
          .length;
    }

    if (status.id == 2) {
      //Déja servie
      return widget.orders
          .where((element) => element.status == AppConstants.ORDER_READY)
          .toList()
          .length;
    }
    if (status.id == 1) {
      //Paiement en attente
      return widget.orders
          .where((element) =>
              element.status != AppConstants.ORDER_PAID &&
              element.status != AppConstants.ORDER_CANCELED)
          .toList()
          .length;
    }

    //Paiement en cuisine
    return widget.orders
        .where((element) => element.status == AppConstants.ORDER_COOKING)
        .toList()
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return AutoHeightGridView(
      shrinkWrap: true,
      itemCount: orderStatuses.length,
      crossAxisCount: 2,
      mainAxisSpacing: 10.r,
      builder: (context, index) {
        final status = orderStatuses[index];
        return AnimationConfiguration.staggeredGrid(
          columnCount: orderStatuses.length,
          position: index,
          duration: const Duration(milliseconds: 375),
          child: ScaleAnimation(
            scale: 0.5,
            child: FadeInAnimation(
              child: MyOrdersStatistiquesComponent(
                value: getValue(status),
                asset: status.asset,
                title: status.title,
              ),
            ),
          ),
        );
      },
    );
  }
}
