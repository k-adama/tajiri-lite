import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/instance_manager.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/select_type_of_cooking.component.dart';

class TypeOfCookingComponent extends StatefulWidget {
  final String? initTypeOfCooking;
  const TypeOfCookingComponent({super.key, this.initTypeOfCooking});

  @override
  State<TypeOfCookingComponent> createState() => _TypeOfCookingComponentState();
}

class _TypeOfCookingComponentState extends State<TypeOfCookingComponent> {
  String? selectTypeOfCooking;
  PosController posController = Get.find();
  @override
  void initState() {
    selectTypeOfCooking = widget.initTypeOfCooking;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      posController.setSelectTypeOfCooking(selectTypeOfCooking);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            "Type de cuisson",
            style: Style.interBold(size: 20, color: Style.brandBlue950),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            "Veuillez sélectionner une cuisson",
            style: Style.interNormal(size: 10, color: Style.grey500),
          ),
        ),
        AutoHeightGridView(
          shrinkWrap: true,
          itemCount: 4,
          crossAxisCount: 2,
          mainAxisSpacing: 10.r,
          builder: (context, index) {
            //final element ;
            return AnimationConfiguration.staggeredGrid(
              columnCount: 4,
              position: index,
              duration: const Duration(milliseconds: 375),
              child: ScaleAnimation(
                scale: 0.5,
                child: FadeInAnimation(
                    child: TypeOfCookingSelectionComponent(
                  text: 'Grillé',
                  onTap: () => posController.setSelectTypeOfCooking('grillé'),
                  isSelected: posController.selectedOfCooking == 'grillé',
                )),
              ),
            );
          },
        )
      ],
    );
  }
}
