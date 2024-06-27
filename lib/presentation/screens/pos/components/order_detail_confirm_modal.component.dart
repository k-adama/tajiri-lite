import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/confirm_order_display_information.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/on_place_information.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';

class OrderConfirmDetailModalComponent extends StatefulWidget {
  const OrderConfirmDetailModalComponent({super.key});

  @override
  State<OrderConfirmDetailModalComponent> createState() =>
      _OrderConfirmDetailModalComponentState();
}

class _OrderConfirmDetailModalComponentState
    extends State<OrderConfirmDetailModalComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
            color: Style.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Center(
                child: Container(
                  height: 4.h,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Style.brandBlue950,
                      borderRadius: BorderRadius.all(Radius.circular(40.r))),
                ),
              ),
              20.verticalSpace,
              Text(
                "Détail de la commande",
                style: Style.interBold(
                  size: 20,
                  color: Style.brandBlue950,
                ),
              ),
              const Divider(
                thickness: 2,
                color: Style.grey100,
              ),
              16.verticalSpace,
              const ConfirmOrderDisplayInformationComponent(
                title: "Information de livraison",
                subTitle: "Veuillez sélectionner le mode de livraison",
                widget: OnPlaceInformationComponent(),
              ),
              20.verticalSpace,
              SizedBox(
                height: 45,
                child: CustomButton(
                  background: Style.brandColor500,
                  title: "Confirmer la commande",
                  textColor: Style.white,
                  isLoadingColor: Style.white,
                  haveBorder: false,
                  radius: 5,
                  onPressed: () {},
                ),
              ),
              50.verticalSpace,
            ],
          )),
    );
  }
}
