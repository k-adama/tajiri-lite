import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/constants/app.constant.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/data/repositories/products/products.repository.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/domain/entities/category.entity.dart';
import 'package:tajiri_waitress/domain/entities/category_supabase.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/food_variant_categorie.entity.dart';
import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';
import 'package:tajiri_waitress/domain/entities/table.entity.dart';
import 'package:tajiri_waitress/domain/entities/type_of_cooking_entity.data.dart';
import 'package:tajiri_waitress/domain/entities/waitress.entity.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/local_cart_enties/bag_data.entity.dart';

class PosController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
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
  static final initialBag = BagDataEntity(index: 0, bagProducts: []);
  RxList<BagDataEntity> bags = <BagDataEntity>[initialBag].obs;

  int totalAmount = 0;
  final ProductsRepository _productsRepository = ProductsRepository();

  List<SideDishAndQuantityEntity> sideDishAndQuantity = [];
  List<TypeOfCookingEntityData> typesOfCooking = [];

  FoodDataEntity foodDataInCart = FoodDataEntity();

  final user = AppHelpersCommon.getUserInLocalStorage();
  OrdersDataEntity newOrder = OrdersDataEntity();
  RxString orderNotes = "".obs;
  RxString paymentMethodId = "d8b8d45d-da79-478f-9d5f-693b33d654e6".obs;

  final selectbagProductsLength = 0.obs;

  final waitress = List<WaitressEntity>.empty().obs;
  Rx<WaitressEntity?> selectedWaitress = Rx<WaitressEntity?>(null);
  Rx<TableEntity?> selectedTable = Rx<TableEntity?>(null);

  final createOrderLoading = false.obs;
  dynamic placeOrder;
  //String? waitressCurrentId;

  //Categorie Supabase
  final categoriesSupabase = List<CategorySupabaseEntity>.empty().obs;

  BagDataEntity get selectbag => bags[selectedBagIndex.value];
  bool get hasTableManagement => checkListingType(user) == ListingType.table;

  @override
  void onReady() async {
    await Future.wait([
      fetchCategoriesSupabase(),
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
    print("-----------FETCH FOOD-----------");
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
          handleFilter("all", "Tout");

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

  Future<void> fetchCategoriesSupabase() async {
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
      // isOrdersLoading = true;
      update();
      try {
        print("---------------fetchCategories on supabse-------------");
        final supabase = Supabase.instance.client;
        final response =
            await supabase.from('categories').select('*, collectionId(*)');

        final json = response as List<dynamic>;
        final data =
            json.map((item) => CategorySupabaseEntity.fromJson(item)).toList();

        categoriesSupabase.assignAll(data);
        update();
      } catch (e) {
        print(
            "---------------fetchCategories on supabse error : $e-------------");

        AppHelpersCommon.showBottomSnackBar(
          Get.context!,
          Text(e.toString()),
          const Duration(seconds: 2),
          true,
        );

        print(e);
        update();
      }
    }
  }

  void setCategoryId(String id) {
    categoryId.value = id;
    update();
  }

  void handleFilter(String? categoryId, String? categoryName) {
    if (categoryId == null) {
      return;
    }
    setCategoryId(categoryId);
    if (categoryId == 'all') {
      foods.assignAll(foodsInit);
      update();
      try {
        Mixpanel.instance.track("POS Category Filter", properties: {
          "Category Name": categoryName,
          "Number of Search Results": foods.length,
          "Number of Out of Stock":
              foods.where((food) => food.quantity == 0).length,
          "Number of products with variants": foods
              .where((food) =>
                  food.foodVariantCategory != null &&
                  food.foodVariantCategory!.isNotEmpty)
              .length
        });
      } catch (e) {
        print("Mixpanel error: $e");
      }

      return;
    }

    if (categoryId == KIT_ID) {
      final transformedList = bundlePacks.map((bundle) {
        return {
          ...bundle,
          'type': 'bundle',
        };
      }).toList();
      final foodData =
          transformedList.map((item) => FoodDataEntity.fromJson(item)).toList();
      foods.assignAll(foodData);
      update();

      try {
        Mixpanel.instance.track("POS Category Filter", properties: {
          "Category Name": categoryName,
          "Number of Search Results": transformedList.length,
          "Number of Out of Stock": 0,
          "Number of products with variants": 0
        });
      } catch (e) {
        print("mixpanel error: $e");
      }
      return;
    }

    // Filter foods whose mainCategoryId key is equal to the ID of the selected category
    final newData =
        foodsInit.where((item) => item.categoryId == categoryId).toList();
    foods.assignAll(newData);
    update();
    try {
      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": newData.length,
        "Number of Out of Stock":
            newData.where((food) => food.quantity == 0).length,
        "Number of products with variants": newData
            .where((food) =>
                food.foodVariantCategory != null &&
                food.foodVariantCategory!.isNotEmpty)
            .length
      });
    } catch (e) {
      print("Mixpanel error: $e");
    }
  }

  Map<String, dynamic> fieldModalProductToUpdateProductAndReturnSelectId(
      BuildContext context, String? itemId) {
    List<String?> selectIdDish = [];
    // filter cart by itemId to find existing product index
    var existingProductIndex =
        selectbag.bagProducts.indexWhere((item) => item.itemId == itemId);

    //
    final selectBagProducts = selectbag.bagProducts[existingProductIndex];
    quantityAddFood = selectBagProducts.quantity!;
    setPriceAddFood(selectBagProducts.price!);

    setFoodDataInCart(selectBagProducts.foodDataEntity!);

    setSelectTypeOfCooking(
        selectBagProducts.typeOfCookingId ?? ""); //update typeOfCooking

    for (int i = 0; i < selectBagProducts.sideDishes!.length; i++) {
      SideDishEntity? sideDish = selectBagProducts.sideDishes![i].sideDish;
      int quantity = selectBagProducts.sideDishes![i].quantity!;

      selectIdDish.add(sideDish?.id); // add for return selectDishId
      if (quantity == 1) {
        setIncrementSideDish(
            SideDishFoodEntity(sideDish: sideDish)); // update sideDish
      } else {
        for (int j = 0; j < quantity; j++) {
          setIncrementSideDish(
            SideDishFoodEntity(
              sideDish: sideDish,
            ),
          );
        }
      }
    }
    update();
    return {
      "selectIdDish": selectIdDish,
      "typeCooking": selectBagProducts.typeOfCookingId
    };
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
    selectbagProductsLength.value = selectbag.bagProducts.length;
    update();
  }

  updateCartItem(
      BuildContext context, FoodDataEntity foodDataEntity, String? itemId) {
    var existingProductIndex =
        selectbag.bagProducts.indexWhere((item) => item.itemId == itemId);
    selectbag.bagProducts.removeAt(existingProductIndex);
    addProductToSelectedBag(foodDataInCart, existingProductIndex);
    update();
  }

  void addProductToSelectedBag(FoodDataEntity food, int indexRemoveProduct) {
    MainCartEntity product = createMainCartItemFromFood(
      food,
      quantityAddFood,
      priceAddFood.value,
      sideDishAndQuantity,
      selectedOfCooking,
    );
    setSelectTypeOfCooking("");
    try {
      Mixpanel.instance.track("Added to Cart", properties: {
        "Product name": food.name,
        "Product ID": food.id,
        "Category": food.category?.name,
        "Selling Price": food.price,
        "Quantity": quantityAddFood,
        "Stock Availability": food.quantity,
        "IsVariant": false
      });
    } catch (e) {
      print("Mixpanel error : $e");
    }

    // verifier si la quantité peut etre augmentée (en fonction du stock de fooddata) en prenant en compte le type bundle (les type bundle n'ont pas de quantité definis donc ont une quantité  null)
    final currentItem = selectbag.bagProducts
        .firstWhereOrNull((element) => element.id == food.id);
    if (food.quantity != null && currentItem?.quantity == food.quantity) return;

    if (selectedBagIndex.value < bags.length) {
      product.quantity = quantityAddFood;
      selectbag.bagProducts.insert(indexRemoveProduct, product);

      // Met à jour le panier sélectionné dans la liste des paniers
      bags[selectedBagIndex.value] = selectbag;
      handleAddModalFoodInCartItemInitialState();
      update();
    }
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
      (entry) => entry.sideDish?.id == sideDishFood.sideDish!.id,
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
    final side = sideDishAndQuantity.firstWhereOrNull(
      (item) => item.sideDish?.id == id,
    );
    return side?.quantity ?? 0;
  }

  List<SideDishAndQuantityEntity> filterSideDishAddQuantity(
      List<SideDishAndQuantityEntity> sideDishAndQuantity) {
    return sideDishAndQuantity.where((item) => item.quantity != 0).toList();
  }

  int quantityProduct() {
    return selectbag.bagProducts.length;
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
      selectbagProductsLength.value = selectbag.bagProducts.length;
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

  void addItemsFromOrderToCart(OrdersDataEntity order) {
    // supprimer le seul pannier et creer un nouveau
    bags.clear();
    addANewBagFromOrder(order);

    for (var orderDetail in order.orderDetails!) {
      print(
          "========order detail==${orderDetail.food?.name}===${orderDetail.orderDetailExtra} ");
      FoodDataEntity food = orderDetail.food ?? orderDetail.bundle;
      List<SideDishAndQuantityEntity> sideDishList =
          orderDetail.orderDetailExtra!.map((item) {
        return SideDishAndQuantityEntity(
          sideDish: SideDishEntity(
            id: item.food?.id,
            name: item.food?.name,
            price: null,
          ),
          quantity: item.quantity,
        );
      }).toList();

      // mettre CartItemStatus a none le status pour pouvoir update
      addProductToSelectedBagByMAinItem(createMainCartItemFromFood(
          food,
          orderDetail.quantity!,
          orderDetail.price!,
          sideDishList,
          orderDetail.typeOfCooking,
          status: CartItemStatus.none));
    }
    selectbagProductsLength.value = selectbag.bagProducts.length;
  }

  void addANewBagFromOrder(OrdersDataEntity order) {
    BagDataEntity newBag = BagDataEntity(
        index: bags.length,
        bagProducts: [],
        idOrderToUpdate: order.id,
        waitressId: order.waitressId,
        tableId: order.tableId,
        settleOrderId: order.orderType);

    bags.add(newBag);
    selectedBagIndex.value = bags.length - 1; //setSelectedBagIndex
  }

  void addProductToSelectedBagByMAinItem(MainCartEntity product) {
    //==================
    if (selectedBagIndex.value < bags.length) {
      var existingProductIndex = selectbag.bagProducts
          .indexWhere((item) => item.itemId == product.itemId);

      if (existingProductIndex != -1) {
        // verifier si la quantité peut etre augmentée (en fonction du stock de fooddata)
        final selectBagProducts = selectbag.bagProducts[existingProductIndex];

        // Si le produit existe déjà, incrémente la quantité

        selectBagProducts.quantity = (selectBagProducts.quantity ?? 0) + 1;

        // si c'est une modification on marque la commande comme mise à jour
        if (selectbag.idOrderToUpdate != null) {
          if (selectBagProducts.status != CartItemStatus.isNew) {
            print("update==========product");
            selectBagProducts.status = CartItemStatus.updated;
          }
        }
      } else {
        selectbag.bagProducts.add(product);
      }

      // Met à jour le panier sélectionné dans la liste des paniers
      bags[selectedBagIndex.value] = selectbag;
      update();
    }
  }

  // MAKE ORDER
  Future<void> handleCreateOrder(BuildContext context) async {
    try {
      await saveOrder(context);
    } catch (error) {
      print(error);
    }
  }

  saveOrder(BuildContext context) async {
    const status = "NEW";
    setPlaceOrder(status);

    createOrderLoading.value = true;
    update();

    print("+++++++++PARAMS $placeOrder");

    final idOrderToUpdate = bags[selectedBagIndex.value].idOrderToUpdate;

    print("==================>idOrderToUpdate $idOrderToUpdate");

    final response = idOrderToUpdate != null
        ? await _productsRepository.updateOrder(placeOrder, idOrderToUpdate)
        : await _productsRepository.createOrder(placeOrder);

    response.when(success: (data) {
      newOrder = data!;
      createOrderLoading.value = false;
      try {
        Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
          "CustomerEntity type": newOrder.customer == null ? 'GUEST' : 'SAVED',
          "Order Status": status,
          "Payment method": "",
          "Status": "Success",
          "Products": newOrder.orderDetails?.map((item) {
            final int foodPrice =
                item.food != null ? item.food?.price : item.bundle['price'];
            return {
              'Product Name': getNameFromOrderDetail(item),
              'Price': item.price,
              'Quantity': item.quantity,
              'IsVariant': item.price != foodPrice ? true : false
            };
          }).toList()
        });
      } catch (e) {
        print("Mixpanel error $e");
      }

      if (bags.length == 1) {
        bags[selectedBagIndex.value] = BagDataEntity(index: 0, bagProducts: []);
        // Vider le panier sans le supprimer
      } else {
        List<BagDataEntity> newBags = [];
        bags.removeAt(selectedBagIndex.value);
        for (int i = 0; i < bags.length; i++) {
          newBags
              .add(BagDataEntity(index: i, bagProducts: bags[i].bagProducts));
        }

        bags.assignAll(newBags);
      }
      selectbagProductsLength.value = selectbag.bagProducts.length;
      const int selectedIndex = 0;

      selectedBagIndex.value = selectedIndex;
      update();

      AppHelpersCommon.showAlertDialog(
        context: context,
        canPop: false,
        child: SuccessfullDialog(
          content: 'La commande \n a été envoyée à la caisse.',
          redirect: () {},
          asset: "assets/svgs/confirmOrderIcon.svg",
          button: CustomButton(
            isUnderline: true,
            textColor: Style.brandColor500,
            background: Style.brandBlue50,
            underLineColor: Style.brandColor500,
            title: 'Prendre une nouvelle commande',
            onPressed: () {
              Get.close(3);
            },
          ),
          closePressed: () {
            Get.close(3);
          },
        ),
      );

      handleInitialState();
    }, failure: (failure, statusCode) {
      createOrderLoading.value = false;
      update();
      try {
        Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
          "CustomerEntity type": newOrder.customer == null ? 'GUEST' : 'SAVED',
          "Order Status": status,
          "Payment method": "",
          "Status": "Failure",
          "Products": newOrder.orderDetails?.map((item) {
            final int foodPrice =
                item.food != null ? item.food?.price : item.bundle['price'];
            return {
              'Product Name': getNameFromOrderDetail(item),
              'Price': item.price,
              'Quantity': item.quantity,
              'IsVariant': item.price != foodPrice ? true : false
            };
          }).toList()
        });
      } catch (e) {
        print("Mixpanel error : $e");
      }
    });
  }

  void handleInitialState() {
    orderNotes.value = "";
    selectedTable.value = null;
    selectedWaitress.value = null;
    update();
  }

  int getNbrProductByCategorie(String? categoryId) {
    final newData =
        foodsInit.where((item) => item.mainCategoryId == categoryId).toList();
    return newData.length;
  }

  void setPlaceOrder(String status) {
    final user = AppHelpersCommon.getUserInLocalStorage();
    final restaurantId = user?.role?.restaurantId;

    String customeType =
        "GUEST"; //(customerNameSelect.value == "") ? "GUEST" : "SAVED";
    String? customerIdValue;
    //(customerId.value == "") ? null : customerId.value;

    final itemFoods = selectbag.bagProducts.map((item) {
      return {
        'foodId': item.id,
        'price': item.price,
        'typeOfCooking': item.typeOfCooking,
        'quantity': item.quantity,
        'extras': item.sideDishes?.map((dish) {
          return {"foodId": dish.sideDish?.id, "quantity": dish.quantity};
        }).toList()
      };
    }).toList();

    final totalCartValue = calculateBagProductTotal();
    final Map<String, dynamic> params = {
      'subTotal': totalCartValue,
      'grandTotal': totalCartValue,
      'customerType': customeType,
      'status': status,
      'customerId': customerIdValue,
      'items': itemFoods,
      'orderType': bags[selectedBagIndex.value].settleOrderId,
      'orderNotes': orderNotes.value,
      'restaurantId': restaurantId,
      'createdId': user?.id,
      'couponCode': "", // couponCode,
      'discountAmount': 0,
      'paymentMethodId': paymentMethodId.value,
      'pinCode': "",
      'address': "",
      'tax': 0,
    };
    final waitressFromBagSelected = bags[selectedBagIndex.value].waitressId;
    final tableFromBagSelected = bags[selectedBagIndex.value].tableId;

    // if (checkListingType(user) == ListingType.waitress) {
    //   params['waitressId'] = waitressFromBagSelected ?? waitressCurrentId;
    // }   ici on envoie pas le waitresId car on considere que le user qui crée la commande est le waitres
    // else
    if (hasTableManagement) {
      params['tableId'] = tableFromBagSelected ?? selectedTable.value?.id;
    }
    placeOrder = params;
    update();
  }

  //

  bool productCanMarkedUpdate(MainCartEntity product) {
    return product.status != CartItemStatus.isNew;
  }

  double calculateBagProductTotal() {
    if (selectedBagIndex.value < bags.length) {
      double total = 0.0;
      for (var item in selectbag.bagProducts) {
        total += (item.price ?? 0) * (item.quantity ?? 0);
      }

      return total;
    }
    return 0;
  }

  setFoodDataInCart(FoodDataEntity foodDataEntity) {
    foodDataInCart = foodDataEntity;
    update();
  }
}
