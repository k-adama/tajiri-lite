import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/my_orders_statistiques.component.dart';

class MyOrdersComponent extends StatefulWidget {
  final List<OrdersDataEntity> orders;
  const MyOrdersComponent({super.key, required this.orders});

  @override
  State<MyOrdersComponent> createState() => _MyOrdersComponentState();
}

class _MyOrdersComponentState extends State<MyOrdersComponent> {
  @override
  void initState() {
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
        return AnimationConfiguration.staggeredGrid(
          columnCount: 4,
          position: index,
          duration: const Duration(milliseconds: 375),
          child: ScaleAnimation(
            scale: 0.5,
            child: FadeInAnimation(
              child: MyOrdersStatistiquesComponent(
                value: 0,
                asset: index == 0
                    ? 'assets/svgs/inkitchen.svg'
                    : index == 1
                        ? 'assets/svgs/enattente.svg'
                        : index == 2
                            ? 'assets/svgs/dejaservie.svg'
                            : 'assets/svgs/Union.svg',
                title: index == 0
                    ? 'En cuisine'
                    : index == 1
                        ? 'Paiement en attente'
                        : index == 2
                            ? 'Déjà servie'
                            : 'Paiement effectué',
              ),
            ),
          ),
        );
      },
    );
  }
}
