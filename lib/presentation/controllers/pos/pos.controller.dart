import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/common/utils.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/app/mixpanel/mixpanel.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_waitress/domain/entities/category_supabase.entity.dart';
import 'package:tajiri_waitress/app/extensions/product.extension.dart';
import 'package:tajiri_waitress/domain/entities/local_cart_enties/bag_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';
import 'package:tajiri_waitress/domain/entities/waitress.entity.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/custom.button.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/dialogs/successfull.dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:tajiri_sdk/src/models/table.model.dart' as taj_sdk;

class PosController extends GetxController {
  final KIT_ID = "1c755978-ae56-47c6-b8e6-a5e3b03577ce";
  var uuid = const Uuid();
  String? selectedOfCooking;
  bool isProductLoading = true;
  int quantityAddFood = 1;
  RxInt priceAddFood = 0.obs;
  List<Product> products = List<Product>.empty().obs;
  List<Product> productsInit = List<Product>.empty().obs;
  RxString customerNameSelect = "".obs;
  RxString customerId = ''.obs;
  String? tableCurrentId;
  MainCategory? categorieSupabaseSelected;
  RxList bundlePacks = [].obs;
  final categories = List<Category>.empty().obs;
  final mainCategories = List<MainCategory>.empty().obs;
  MainCategory? mainCategorieSelected;
  RxString categoryId = 'all'.obs;

  // cart
  RxInt selectedBagIndex =
      0.obs; // toujours le seul pannier selectionné par default ici
  static final initialBag = BagDataEntity(index: 0, bagProducts: []);
  RxList<BagDataEntity> bags = <BagDataEntity>[initialBag].obs;
  int totalAmount = 0;
  List<SideDishAndQuantityEntity> sideDishAndQuantity = [];
  List<TypeOfCooking> typesOfCooking = [];

  Product? productDataInCart;
  Order? newOrder;
  RxString orderNotes = "".obs;
  RxString paymentMethodId = "d8b8d45d-da79-478f-9d5f-693b33d654e6".obs;

  final selectbagProductsLength = 0.obs;
  Rx<Waitress?> selectedWaitress = Rx<Waitress?>(null);
  Rx<taj_sdk.Table?> selectedTable = Rx<taj_sdk.Table?>(null);

  final createOrderLoading = false.obs;
  dynamic placeOrder;
  final categoriesSupabase = List<CategorySupabaseEntity>.empty().obs;

  BagDataEntity get selectbag => bags[selectedBagIndex.value];
  bool get hasTableManagement => checkListingType(user) == ListingType.table;
  static final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurant = AppHelpersCommon.getRestaurantInLocalStorage();
  final restaurantId = user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() async {
    await Future.wait([
      fetchProductsAndCategories(),
      fetchTypeOfCooking(),
      fetchMainCategories(),
    ]);
    super.onReady();
  }

  void addANewBag() {
    bags.add(BagDataEntity(index: bags.length, bagProducts: []));
    selectedBagIndex.value = bags.length - 1;
    update();
  }

  Future<void> fetchProductsAndCategories() async {
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();
      final result = await tajiriSdk.productsService.getProducts(restaurantId!);
      products.assignAll(result);
      productsInit.assignAll(result);
      isProductLoading = false;
      update();
    }
  }

  Future<void> fetchCategories() async {
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isProductLoading = true;
      update();

      final newCategories =
          await tajiriSdk.categoriesService.getCategories(restaurantId!);
      newCategories.insert(
        0,
        Category(
          id: "all",
          name: "Tout",
          imageUrl: '🗂️',
          restaurantId: '',
          mainCategoryId: '',
        ),
      );
      newCategories.insert(
        newCategories.length,
        Category(
          id: KIT_ID,
          name: "Packs de vente",
          imageUrl: '🎁',
          restaurantId: '',
          mainCategoryId: '',
        ),
      );
      categories.assignAll(newCategories);
      handleFilter("all", categorieSupabaseSelected?.name);
      isProductLoading = false;
      update();
    }
  }

  Future<void> fetchMainCategories() async {
    if (restaurantId == null) {
      return;
    }

    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      update();
      try {
        final result =
            await tajiriSdk.mainCategoriesService.getMainCategories();
        mainCategories.assignAll(result);
        selectMainCategorie(mainCategories[0]);
        update();
      } catch (e) {
        update();
      }
    }
  }

  selectMainCategorie(MainCategory categorie) {
    mainCategorieSelected = categorie;
    handleFilter(categorie.id, categorie.name);
    update();
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
      products.assignAll(productsInit);
      update();
      try {
        Mixpanel.instance.track("POS Category Filter", properties: {
          "Category Name": categoryName,
          "Number of Search Results": products.length,
          "Number of Out of Stock":
              products.where((product) => product.quantity == 0).length,
          "Number of products with variants":
              products.where((product) => product.variants.isNotEmpty).length
        });
      } catch (e) {
        print("Mixpanel error: $e");
      }

      return;
    }

    if (categoryId == KIT_ID) {
      final newData = productsInit.where((item) => item.isBundle).toList();
      products.assignAll(newData);

      try {
        Mixpanel.instance.track("POS Category Filter", properties: {
          "Category Name": categoryName,
          "Number of Search Results": newData.length,
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
        productsInit.where((item) => item.categoryId == categoryId).toList();
    products.assignAll(newData);
    update();
    try {
      Mixpanel.instance.track("POS Category Filter", properties: {
        "Category Name": categoryName,
        "Number of Search Results": newData.length,
        "Number of Out of Stock":
            newData.where((food) => food.quantity == 0).length,
        "Number of products with variants":
            newData.where((food) => food.variants.isNotEmpty).length
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

  void setIncrementQuantityAddFood(Product? food) {
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

  setDecrementQuantityAddFood(Product? food) {
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
    update();
  }

  void handleAddModalFoodInCartItemInitialState() {
    quantityAddFood = 1;
    sideDishAndQuantity = [];
    priceAddFood.value = 0;
    setSelectTypeOfCooking(null);
    update();
  }

  void addToCart(Product food) {
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
      BuildContext context, Product? foodDataEntity, String? itemId) {
    var existingProductIndex =
        selectbag.bagProducts.indexWhere((item) => item.itemId == itemId);
    selectbag.bagProducts.removeAt(existingProductIndex);
    // addProductToSelectedBag(productDataInCart, existingProductIndex);
    if (productDataInCart != null) {
      addProductToSelectedBag(productDataInCart!, existingProductIndex);
    }
    update();
  }

  void addProductToSelectedBag(Product food, int indexRemoveProduct) {
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
      Product product,
      int quantity,
      int price,
      List<SideDishAndQuantityEntity> sideDishAndQuantity,
      String? typeOfCookingId,
      {CartItemStatus? status = CartItemStatus.isNew}) {
    return MainCartEntity(
        id: product.id,
        quantity: quantity,
        name: product.name,
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
        foodDataEntity: product);
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

  Future<void> fetchTypeOfCooking() async {
    if (restaurantId == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();

    if (connected) {
      update();
      try {
        final result = await tajiriSdk.typesOfCookingService
            .getTypesOfCooking(restaurantId!);
        typesOfCooking.assignAll(result);
        print("type cooking $typesOfCooking");

        update();
      } catch (e) {
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

  void addItemsFromOrderToCart(Order order) {
    // supprimer le seul pannier et creer un nouveau
    bags.clear();
    addANewBagFromOrder(order);

    for (var orderDetail in order.orderProducts) {
      Product food = orderDetail.product;
      List<SideDishAndQuantityEntity> sideDishList =
          orderDetail.orderProductExtra.map((item) {
        return SideDishAndQuantityEntity(
          sideDish: SideDishEntity(
            id: item.product.id,
            name: item.product.name,
            price: null,
          ),
          quantity: item.quantity,
        );
      }).toList();

      // mettre CartItemStatus a none le status pour pouvoir update
      addProductToSelectedBagByMAinItem(createMainCartItemFromFood(
          food,
          orderDetail.quantity,
          orderDetail.price,
          sideDishList,
          orderDetail.productTypeOfCookingId,
          status: CartItemStatus.none));
    }
    selectbagProductsLength.value = selectbag.bagProducts.length;
  }

  void addANewBagFromOrder(Order order) {
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
    final createOrderDto = getCreateOrderDto(status);
    createOrderLoading.value = true;
    update();
    final idOrderToUpdate = bags[selectedBagIndex.value].idOrderToUpdate;
    try {
      final result = idOrderToUpdate != null
          ? await tajiriSdk.ordersService
              .updateOrder(idOrderToUpdate, getUpdateOrderDto(status))
          : await tajiriSdk.ordersService.createOrder(createOrderDto);
      newOrder = result;
      createOrderLoading.value = false;
      try {
        Mixpanel.instance.track("Checkout (Send Order to DB)", properties: {
          "CustomerEntity type":
              newOrder?.customerId == null ? 'GUEST' : 'SAVED',
          "Order Status": status,
          "Payment method": "",
          "Status": "Success",
          "Products": newOrder?.orderProducts.map((item) {
            final int foodPrice = item.product.price;
            return {
              'Product Name': item.product.name,
              'Price': item.price,
              'Quantity': item.quantity,
              'IsVariant': item.price != foodPrice ? true : false
            };
          }).toList()
        });
      } catch (e) {}
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
    } catch (e) {
      createOrderLoading.value = false;
      update();
    }
  }

  void handleInitialState() {
    orderNotes.value = "";
    selectedTable.value = null;
    selectedWaitress.value = null;
    update();
  }

  int getNbrProductByCategorie(String? categoryId) {
    final newData = productsInit
        .where((item) => item.mainCategoryId == categoryId)
        .toList();
    return newData.length;
  }

  List<MainCartEntity> parseProductList() {
    try {
      return bags[selectedBagIndex.value].bagProducts;
    } catch (e) {
      return [];
    }
  }

  CreateOrderDto getCreateOrderDto(String status) {
    String customeType = (customerNameSelect.value == "") ? "GUEST" : "SAVED";
    String? customerIdValue =
        (customerId.value == "") ? null : customerId.value;
    final orderProductDto = parseProductList().map((item) {
      final productTypeOfCookingId =
          item.typeOfCookingId == null || item.typeOfCookingId!.trim().isEmpty
              ? null
              : item.typeOfCookingId;
      return OrderProductDto(
        productId: item.id!,
        price: item.price ?? 0,
        quantity: item.quantity ?? 1,
        productTypeOfCookingId: productTypeOfCookingId,
        extras: item.sideDishes?.map((dish) {
          return OrderProductExtraDto(
              productId: dish.sideDish?.id ?? "", quantity: dish.quantity ?? 0);
        }).toList(),
      );
    }).toList();
    final totalCartValue = calculateBagProductTotal();
    final createDto = CreateOrderDto(
      subTotal: totalCartValue.toInt(),
      grandTotal: totalCartValue.toInt(),
      restaurantId: restaurantId!,
      customerType: customeType,
      orderType: bags[selectedBagIndex.value].settleOrderId ?? "",
      status: status,
      customerId: customerIdValue,
      orderNotes: orderNotes.value,
      createdId: user?.id,
      tax: 0,
      products: orderProductDto,
      tableId:
          hasTableManagement ? selectedTable.value?.id ?? tableCurrentId : null,
    );
    return createDto;
  }

  UpdateOrderDto getUpdateOrderDto(String status) {
    String customeType = (customerNameSelect.value == "") ? "GUEST" : "SAVED";
    String? customerIdValue =
        (customerId.value == "") ? null : customerId.value;

    final orderProductDto = parseProductList().map((item) {
      final productTypeOfCookingId =
          item.typeOfCookingId == null || item.typeOfCookingId!.trim().isEmpty
              ? null
              : item.typeOfCookingId;
      return OrderProductDto(
        productId: item.id!,
        price: item.price ?? 0,
        quantity: item.quantity ?? 1,
        productTypeOfCookingId: productTypeOfCookingId,
        extras: item.sideDishes?.map((dish) {
          return OrderProductExtraDto(
              productId: dish.sideDish?.id ?? "", quantity: dish.quantity ?? 0);
        }).toList(),
      );
    }).toList();

    final totalCartValue = calculateBagProductTotal();
    final updateDto = UpdateOrderDto(
      subTotal: totalCartValue.toInt(),
      grandTotal: totalCartValue.toInt(),
      customerType: customeType,
      orderType: bags[selectedBagIndex.value].settleOrderId ?? "",
      status: status,
      customerId: customerIdValue,
      orderNotes: orderNotes.value,
      createdId: user?.id,
      tax: 0,
      products: orderProductDto,
      tableId:
          hasTableManagement ? selectedTable.value?.id ?? tableCurrentId : null,
    );
    log("updateDto DTO : ${updateDto.toJson()}");
    return updateDto;
  }

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

  setFoodDataInCart(Product foodDataEntity) {
    productDataInCart = foodDataEntity;
    update();
  }
}
