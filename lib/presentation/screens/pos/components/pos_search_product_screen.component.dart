import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/custom_pos_roundedButton.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/product_list.component.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/text_fields/search_bar.text_field.dart';

class PosSearchProductScreen extends StatefulWidget {
  const PosSearchProductScreen({super.key});

  @override
  State<PosSearchProductScreen> createState() => _PosSearchProductScreenState();
}

class _PosSearchProductScreenState extends State<PosSearchProductScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearchFocused = false;
  final FocusNode searchFocusNode = FocusNode();

  final posController = Get.find<PosController>();
  List<FoodDataEntity> searchFoods = <FoodDataEntity>[];

  @override
  void initState() {
    super.initState();
    searchFoods = posController.foodsInit;
    print(searchFoods);
    searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(builder: (posController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Style.secondaryColor),
          backgroundColor: Style.white,
        ),
        backgroundColor: Style.bodyNewColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Style.white,
              ),
              child: SearchBarTextField(
                searchController: searchController,
                hintText: "Rechercher un plat, une boisson ...",
                focusNode: searchFocusNode,
                onSearch: (text) {
                  searchFoods = posController.foodsInit.where((item) {
                    final nameRecherch = searchController.text.toLowerCase();
                    final foodName = item.name!.toLowerCase();
                    final categoryName = item.category!.name!.toLowerCase();
                    return foodName.startsWith(nameRecherch) ||
                        categoryName.startsWith(nameRecherch);
                  }).toList();
                  setState(() {});
                },
              ),
            ),
            Expanded(
                child: ProductsListComponent(
              foodList: searchFoods,
            ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: posController.quantityProduct() == 0
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomPosRoundedButtonComponent(
                  onTap: () {
                    Get.toNamed(Routes.CART);
                  },
                  text: posController.quantityProduct().toString(),
                ),
              ),
      );
    });
  }
}
