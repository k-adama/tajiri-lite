import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/category_card.component.dart';

class CategoryListComponent extends StatefulWidget {
  const CategoryListComponent({super.key});

  @override
  State<CategoryListComponent> createState() => _CategoryListComponentState();
}

class _CategoryListComponentState extends State<CategoryListComponent> {
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
            border: Border(bottom: BorderSide(width: 1, color: Style.grey100))),
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
