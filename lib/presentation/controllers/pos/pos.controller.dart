import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/data/products/products.repository.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/domain/entities/category.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_variant_categorie.entity.dart';
import 'package:tajiri_waitress/domain/entities/main_item.entity.dart';
import 'package:uuid/uuid.dart';

class PosController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  RxString settleOrderId = "ON_PLACE".obs;
  var uuid = const Uuid();
  String? selectedOfCooking;
  bool isProductLoading = true;
  int quantityAddFood = 1;
  int priceAddFood = 0;
  List<FoodDataEntity> foods = List<FoodDataEntity>.empty().obs;
  List<FoodDataEntity> foodsInit = List<FoodDataEntity>.empty().obs;
  RxList bundlePacks = [].obs;
  final categories = List<CategoryEntity>.empty().obs;
  RxString categoryId = 'all'.obs;
  final foodVariantCategories = List<FoodVariantCategoryEntity>.empty().obs;
  final cartItemList = List<MainCartEntity>.empty().obs;
  //List<TypeOfCookingEntityData> typesOfCooking = [];
  //FoodDataEntity foodDataInCart = FoodDataEntity();
  int totalAmount = 0;
  final ProductsRepository _productsRepository = ProductsRepository();

  @override
  void onReady() async {
    await Future.wait([
      fetchFoods(),
    ]);
    super.onReady();
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

  void addToCart(FoodDataEntity food) {
    cartItemList.add(createMainCartItemFromFood(
      food,
      quantityAddFood,
      priceAddFood,
      //sideDishAndQuantity,
      // selectedOfCooking,
    ));
    update();
  }

  MainCartEntity createMainCartItemFromFood(
      FoodDataEntity food, int quantity, int price,
      // List<SideDishAndQuantityEntity> sideDishAndQuantity,
      // String? typeOfCookingId,
      {CartItemStatus? status = CartItemStatus.isNew}) {
    return MainCartEntity(
        id: food.id,
        quantity: quantity ?? food.quantity,
        name: food.name,
        price: price ?? food.price,
        itemId: uuid.v4(),
        /* typeOfCooking: typesOfCooking
                .firstWhereOrNull((type) => type.id == typeOfCookingId)
                ?.name ??
            typeOfCookingId,*/
        // typeOfCookingId: typeOfCookingId,
        // sideDishes: sideDishAndQuantity,
        totalAmount: totalAmount,
        status: status,
        foodDataEntity: food);
  }

  String quantityProduct() {
    if (cartItemList.length > 1) {
      return "${cartItemList.length}";
    }
    return "${cartItemList.length}";
  }

  List<MainCartEntity> getSortList(List<MainCartEntity>? items) {
    if (items == null) {
      return [];
    }
    List<MainCartEntity>? sortedItems = items.map((e) => e).toList()
      ..sort((a, b) => b.name!.compareTo(a.name!));
    return sortedItems;
  }
}
