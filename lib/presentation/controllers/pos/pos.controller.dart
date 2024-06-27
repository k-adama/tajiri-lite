import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/data/products/products.repository.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/domain/entities/category.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_variant_categorie.entity.dart';
import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';
import 'package:tajiri_waitress/domain/entities/type_of_cooking_entity.data.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/local_cart_enties/bag_data.entity.dart';

class PosController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  RxString settleOrderId = "ON_PLACE".obs;
  var uuid = const Uuid();
  String? selectedOfCooking;
  bool isProductLoading = true;
  int quantityAddFood = 1;
  RxInt priceAddFood = 0.obs;
  List<FoodDataEntity> foods = List<FoodDataEntity>.empty().obs;
  List<FoodDataEntity> foodsInit = List<FoodDataEntity>.empty().obs;
  RxList bundlePacks = [].obs;
  final categories = List<CategoryEntity>.empty().obs;
  RxString categoryId = 'all'.obs;
  final foodVariantCategories = List<FoodVariantCategoryEntity>.empty().obs;

  // cart
  RxInt selectedBagIndex =
      0.obs; // toujours le seul pannier selectionné par default ici
  RxList<BagDataEntity> bags = <BagDataEntity>[].obs;

  int totalAmount = 0;
  final ProductsRepository _productsRepository = ProductsRepository();

  List<SideDishAndQuantityEntity> sideDishAndQuantity = [];
  List<TypeOfCookingEntityData> typesOfCooking = [];

  final user = AppHelpersCommon.getUserInLocalStorage();

  BagDataEntity get selectbag => bags[selectedBagIndex.value];

  @override
  void onReady() async {
    addANewBag();
    await Future.wait([
      fetchFoods(),
      fetchTypeOfCookingFromSupabase(),
    ]);
    super.onReady();
  }

  void addANewBag() {
    bags.add(BagDataEntity(index: bags.length, bagProducts: []));
    selectedBagIndex.value = bags.length - 1;
    update();
  }

  Future<void> fetchFoods() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final response = await _productsRepository
          .getFoods(AppConstants.TYPE_QUERY_ONLY_PRODUCT);

      final responseBundlePacks = await _productsRepository.getBundlePacks();

      response.when(
        success: (data) async {
          final json = data ?? [];

          final foodData = json;
          foods.assignAll(foodData);
          foodsInit.assignAll(foodData);
          bundlePacks.assignAll(responseBundlePacks.data);

          final newCategories = json
              .where((e) {
                return e.category != null;
              }) // Filter out items with null category
              .map((e) => e.category!) // Safe to use non-nullable access now
              .toSet()
              .toList();

          newCategories.insert(
            0,
            CategoryEntity(
              id: "all",
              name: "Tout",
              imageUrl: '🗂️',
            ),
          );
          newCategories.insert(
            newCategories.length,
            CategoryEntity(
              id: KIT_ID,
              name: "Packs de vente",
              imageUrl: '🎁',
            ),
          );
          categories.assignAll(newCategories);
          // filter with the selection category (by default the first)
          // handleFilter("all", categorieSupabaseSelected?.name);

          List<FoodVariantCategoryEntity> newFoodVariantCategories = [];

          for (var foodData in json) {
            final listFoodVariantCategories = foodData.foodVariantCategory;

            if (listFoodVariantCategories!.isNotEmpty) {
              for (var value in listFoodVariantCategories) {
                newFoodVariantCategories.add(value);
              }
            }
          }

          foodVariantCategories.assignAll(newFoodVariantCategories);

          isProductLoading = false;
          update();
        },
        failure: (failure, status) {
          isProductLoading = false;
          update();
          /*  AppHelpers.showCheckTopSnackBar(
              context,
              status.toString(),
            ); */
        },
      );
      isProductLoading = false;
      update();
    }
  }

  void setSelectTypeOfCooking(String? typOfCooking) {
    selectedOfCooking = typOfCooking;
    update();
  }

  void setIncrementQuantityAddFood(FoodDataEntity? food) {
    if (food != null) {
      if (food.quantity == quantityAddFood) {
      } else {
        if (quantityAddFood < (food.quantity ?? 0)) {
          quantityAddFood++;
          update();
        } else {
          quantityAddFood;
          update();
        }
      }
    } else {}
  }

  setDecrementQuantityAddFood(FoodDataEntity? food) {
    if (food != null) {
      if (quantityAddFood > 0) {
        quantityAddFood--;
        update();
      } else {
        quantityAddFood = quantityAddFood + 1;
        update();
      }
    } else {}
  }

  setPriceAddFood(int value) {
    priceAddFood.value = value;
    print("---priceAddFood : $priceAddFood");
    update();
  }

  void handleAddModalFoodInCartItemInitialState() {
    quantityAddFood = 1;
    sideDishAndQuantity = [];
    priceAddFood.value = 0;
    update();
  }

  void addToCart(FoodDataEntity food) {
    selectbag.bagProducts.add(createMainCartItemFromFood(
      food,
      quantityAddFood,
      priceAddFood.value,
      sideDishAndQuantity,
      selectedOfCooking,
    ));
    handleAddModalFoodInCartItemInitialState(); // reset the state
    update();
  }

  MainCartEntity createMainCartItemFromFood(
      FoodDataEntity food,
      int quantity,
      int price,
      List<SideDishAndQuantityEntity> sideDishAndQuantity,
      String? typeOfCookingId,
      {CartItemStatus? status = CartItemStatus.isNew}) {
    return MainCartEntity(
        id: food.id,
        quantity: quantity,
        name: food.name,
        price: price,
        itemId: uuid.v4(),
        typeOfCooking: typesOfCooking
                .firstWhereOrNull((type) => type.id == typeOfCookingId)
                ?.name ??
            typeOfCookingId,
        typeOfCookingId: typeOfCookingId,
        sideDishes: sideDishAndQuantity,
        totalAmount: totalAmount,
        status: status,
        foodDataEntity: food);
  }

  void setIncrementSideDish(SideDishFoodEntity sideDishFood) {
    var existingEntryIndex = sideDishAndQuantity.indexWhere(
      (entry) => entry.sideDish?.id == sideDishFood.sideDish!.id,
    );
    if (existingEntryIndex != -1) {
      if (sideDishAndQuantity[existingEntryIndex].quantity != null) {
        sideDishAndQuantity[existingEntryIndex].quantity!;
        sideDishAndQuantity[existingEntryIndex].quantity =
            sideDishAndQuantity[existingEntryIndex].quantity! + 1;
      } else {
        sideDishAndQuantity[existingEntryIndex].quantity = 1;
      }
    } else {
      sideDishAndQuantity.add(SideDishAndQuantityEntity(
          sideDish: sideDishFood.sideDish, quantity: 1));
    }
    update();
  }

  void setDecrementSideDish(SideDishFoodEntity sideDishFood,
      {bool? removeDish = false}) {
    var existingEntryIndex = sideDishAndQuantity.indexWhere(
      (entry) => entry.sideDish?.id == sideDishFood?.sideDish!.id,
    );
    if (existingEntryIndex != -1) {
      if (removeDish == true) {
        sideDishAndQuantity.removeAt(existingEntryIndex);
        return;
      }
      if (sideDishAndQuantity[existingEntryIndex].quantity != null &&
          sideDishAndQuantity[existingEntryIndex].quantity! > 1) {
        // peut etre decrementé uniquement si la quantité est superieur à 1
        sideDishAndQuantity[existingEntryIndex].quantity =
            sideDishAndQuantity[existingEntryIndex].quantity! - 1;
      }
      sideDishAndQuantity = filterSideDishAddQuantity(sideDishAndQuantity);
    }
    update();
  }

  int getSideDishAddQuantity(String? id) {
    final side = sideDishAndQuantity.firstWhere(
        (item) => item.sideDish?.id == id,
        orElse: () => SideDishAndQuantityEntity());
    return side.quantity ?? 0;
  }

  List<SideDishAndQuantityEntity> filterSideDishAddQuantity(
      List<SideDishAndQuantityEntity> sideDishAndQuantity) {
    return sideDishAndQuantity.where((item) => item.quantity != 0).toList();
  }

  String quantityProduct() {
    return "${selectbag.bagProducts.length}";
  }

  Future<void> fetchTypeOfCookingFromSupabase() async {
    final restaurantId = user?.role?.restaurantId;

    if (restaurantId == null) {
      AppHelpersCommon.showBottomSnackBar(
        Get.context!,
        const Text("Impossible de recuperer l'id du restaurant"),
        const Duration(seconds: 2),
        true,
      );
    }
    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      update();
      try {
        final supabase = Supabase.instance.client;
        final response = await supabase
            .from('type_of_cooking')
            .select('*')
            .eq("restaurantId", restaurantId!);

        final json = response as List<dynamic>;
        final data =
            json.map((item) => TypeOfCookingEntityData.fromJson(item)).toList();

        typesOfCooking.assignAll(data);
        update();
      } catch (e) {
        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );
        update();
      }
    }
  }

  void removeItemInBag(MainCartEntity item) {
    if (selectedBagIndex.value < bags.length) {
      final product = selectbag.bagProducts
          .firstWhereOrNull((product) => product.itemId == item.itemId);

      selectbag.bagProducts.remove(product);
      addProductToDeleteList(selectbag, product);

      bags[selectedBagIndex.value] = selectbag;

      calculateBagProductTotal(); // Recalculer le total après la suppression de l'item
      update();
    }
  }

  addProductToDeleteList(BagDataEntity selectedBag, MainCartEntity? product) {
    //add product to delete list

    // si nous somme dans modifier
    if (product != null && productCanMarkedUpdate(product)) {
      // Vérifier si le produit existe déjà dans la liste deleteProducts
      int existingIndex =
          selectedBag.deleteProducts!.indexWhere((p) => p.id == product.id);

      if (existingIndex != -1) {
        // Le produit existe déjà dans la liste, le remplacer
        selectedBag.deleteProducts![existingIndex] = product;
      } else {
        selectedBag.deleteProducts!
            .add(product); // Ajoute le produit au tableau de suppression.
      }
      print(
          "----------delete products list-------${selectedBag.deleteProducts}");
    }
  }

  bool productCanMarkedUpdate(MainCartEntity product) {
    return product.status != CartItemStatus.isNew;
  }

  double calculateBagProductTotal() {
    if (selectedBagIndex.value < bags.length) {
      var selectedBag = bags[selectedBagIndex.value];
      double total = 0.0;

      for (var item in selectedBag.bagProducts) {
        total += (item.price ?? 0) * (item.quantity ?? 0);
      }

      return total;
    }
    return 0;
  }
}
