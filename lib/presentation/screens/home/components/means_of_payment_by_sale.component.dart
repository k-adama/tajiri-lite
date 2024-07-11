import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/payment_method_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.controller.dart';
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
    return GetBuilder<HomeController>(builder: (homeController) {
      return AutoHeightGridView(
        shrinkWrap: true,
        itemCount: PAIEMENTS.length,
        crossAxisCount: 2,
        mainAxisSpacing: 10.r,
        builder: (context, index) {
          var meansOfpayment = PAIEMENTS[index];

          final dynamic payment =
              homeController.paymentsMethodAmount.firstWhere(
            (itemPy) => itemPy.id == meansOfpayment['id'],
            orElse: () => PaymentMethodDataEntity(
              id: meansOfpayment['id'],
              total: 0,
              name: meansOfpayment['name'],
            ),
          );

          final value = payment.total ?? 0;
          return AnimationConfiguration.staggeredGrid(
            columnCount: 4,
            position: index,
            duration: const Duration(milliseconds: 375),
            child: ScaleAnimation(
              scale: 0.5,
              child: FadeInAnimation(
                child: MeansOfPaymentComponent(
                  value: value,
                  meansOfpayment: meansOfpayment,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
