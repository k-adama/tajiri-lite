import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/presentation/screens/home/components/means_of_payment.component.dart';

class MeansOfPaymentBySaleComponent extends StatefulWidget {
  final List<OrdersDataEntity> orders;
  const MeansOfPaymentBySaleComponent({super.key, required this.orders});

  @override
  State<MeansOfPaymentBySaleComponent> createState() =>
      _MeansOfPaymentBySaleComponentState();
}

class _MeansOfPaymentBySaleComponentState
    extends State<MeansOfPaymentBySaleComponent> {
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
              child: MeansOfPaymentComponent(
                value: 0,
                asset: index == 0
                    ? 'assets/svgs/cashpayment.svg'
                    : index == 1
                        ? 'assets/svgs/orangepayment.svg'
                        : index == 2
                            ? 'assets/svgs/mtnpayment.svg'
                            : 'assets/images/moovpayment.png',
                title: index == 0
                    ? 'Cash'
                    : index == 1
                        ? 'Orange Money'
                        : index == 2
                            ? 'MTN Momo'
                            : 'Moov Money',
              ),
            ),
          ),
        );
      },
    );
  }
}
