import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/components/category_card.component.dart';

class MainAppbarComponent extends StatefulWidget {
  const MainAppbarComponent({super.key});

  @override
  State<MainAppbarComponent> createState() => _MainAppbarComponentState();
}

class _MainAppbarComponentState extends State<MainAppbarComponent> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) => Container(
        width: double.infinity,
        // height: 100,
        padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 15.r),
        decoration: const BoxDecoration(
          color: Style.white,
          border: Border(
            bottom: BorderSide(width: 1,
            color: Style.grey100)
          )
        
        ),
        height: 130,
        child: ListView.builder(
          shrinkWrap: true,
          // controller: categoryController,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            //final categorie = posController.categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CategoryCardComponent(
                onTap: () {
                  setState(() {
                   if (selectedIndex == index) {
                  selectedIndex = -1; // Désélectionne l'élément
                } else {
                  selectedIndex = index; // Sélectionne le nouvel élément
                }
                  });
                },
                // colors: [],
                isSelected: selectedIndex == index,
              ),
            );
          },
        ),
      ),
    );
  }
}
