

import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/side_dish.entity.dart';

enum CartItemStatus { none, updated, isNew, deleted }

String getStatusLabel(CartItemStatus? status) {
  if (status == CartItemStatus.isNew || status == null) {
    return "[Nouveau]";
  } else if (status == CartItemStatus.deleted) {
    return "[Supprimé]";
  } else if (status == CartItemStatus.none) {
    return "[inchangé]";
  } else {
    return "[Modifie]";
  }
}

class MainCartEntity {
  String? id;
  String? name;
  int? price;
  int? quantity;
  String? typeOfCooking;
  String? typeOfCookingId;
  List<SideDishAndQuantityEntity>? sideDishes;
  int? totalAmount;
  FoodDataEntity? foodDataEntity;
  CartItemStatus? status;
  String? itemId;
  // bool? updated;
  // bool? isNew;

  MainCartEntity({
    this.id,
    this.quantity,
    this.name,
    this.price,
    this.typeOfCooking,
    this.typeOfCookingId,
    this.sideDishes,
    this.totalAmount,
    this.foodDataEntity,
    this.itemId,
    this.status = CartItemStatus.isNew,
    // this.isNew,
    // this.updated,
  });

  factory MainCartEntity.fromJson(Map<String, dynamic> json) {
    return MainCartEntity(
        id: json['id'],
        quantity: json['quantity'],
        itemId: json['itemId'],
        name: json['name'],
        price: json['price'],
        typeOfCooking: json['typeOfCooking'],
        typeOfCookingId: json['typeOfCookingId'],
        sideDishes: json['sideDishes'] != null
            ? List<SideDishAndQuantityEntity>.from(
                json['sideDishes'].map(
                  (item) => SideDishAndQuantityEntity.fromJson(item),
                ),
              )
            : null,
        totalAmount: json['totalAmount'],
        foodDataEntity: FoodDataEntity.fromJson(json),
        status: json['status']
        // updated: json['updated'],
        // isNew: json['isNew'],
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'quantity': quantity,
      'name': name,
      'price': price,
      'itemId': itemId,
      'typeOfCooking': typeOfCooking,
      'typeOfCookingId': typeOfCookingId,
      'totalAmount': totalAmount,
      'sideDishes': sideDishes?.map((item) => item.toJson()).toList(),
      'foodDataEntity': foodDataEntity?.toJson(),
      'status': status.toString(),
      // 'updated': updated,
      // 'isNew': isNew,
    };
    return data;
  }

  MainCartEntity copyWith() {
    return MainCartEntity(
      id: this.id,
      quantity: this.quantity,
      name: this.name,
      price: this.price,
      typeOfCooking: this.typeOfCooking,
      typeOfCookingId: this.typeOfCookingId,
      sideDishes: this.sideDishes != null
          ? List<SideDishAndQuantityEntity>.from(
              this.sideDishes!.map((item) => item.copyWith()))
          : null,
      totalAmount: this.totalAmount,
      foodDataEntity: this.foodDataEntity?.copyWith(),
      status: this.status,
    );
  }
}

class MainItemEntity {
  String? id;
  int? quantity;
  int? maxFoodqte; // la quantité max en stock pour le produit

  String? name;
  int? price;
  String? image;
  MainItemVariation? variant;

  MainItemEntity({
    this.id,
    this.quantity,
    this.name,
    this.price,
    this.image,
    this.variant,
    this.maxFoodqte,
  });

  factory MainItemEntity.fromJson(Map<String, dynamic> json) {
    return MainItemEntity(
      id: json['id'],
      quantity: json['quantity'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      variant: json['variant'] != null
          ? MainItemVariation.fromJson(json['variant'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'quantity': quantity,
      'name': name,
      'price': price,
      'image': image,
      'variant': variant?.toJson(),
    };
    return data;
  }
}

class MainItemVariation {
  String? id;
  int? itemId;
  String? name;
  int? price;

  MainItemVariation({
    this.id,
    this.itemId,
    this.name,
    this.price,
  });

  factory MainItemVariation.fromJson(Map<String, dynamic> json) {
    return MainItemVariation(
      id: json['id'],
      itemId: json['itemId'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'itemId': itemId,
      'name': name,
      'price': price,
    };
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainItemVariation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ExtraItem {
  String? id;
  String? itemId;
  int? quantity;
  String? name;
  int? price;
  ExtraItem({
    this.id,
    this.itemId,
    this.quantity,
    this.name,
    this.price,
  });
}

class AddonsItem {
  String? id;
  String? itemId;
  int? quantity;
  String? name;
  int? price;
  AddonsItem({
    this.id,
    this.itemId,
    this.quantity,
    this.name,
    this.price,
  });
}

class ItemVariations {
  final Names names;
  final IVariations variations;

  ItemVariations(this.names, this.variations);
}

class IVariations {
  final String id;
  final int value;

  IVariations(this.id, this.value);
}

class Names {
  final String size;

  Names(this.size);
}

class CartLocalModelList {
  final List<CartLocalModel> list;

  CartLocalModelList({
    required this.list,
  });

  factory CartLocalModelList.fromJson(Map data) {
    List<CartLocalModel> list = [];
    data["list"].forEach((e) {
      list.add(CartLocalModel.fromJson(e));
    });
    return CartLocalModelList(
      list: list,
    );
  }

  Map toJson() {
    return {
      "list": list.map((e) => e.toJson()).toList(),
    };
  }
}

class CartLocalModel {
  int count;
  final String stockId;

  CartLocalModel({required this.count, required this.stockId});

  factory CartLocalModel.fromJson(Map data) {
    return CartLocalModel(
      count: data["count"],
      stockId: data["stockId"],
    );
  }

  Map toJson() {
    return {
      "count": count,
      "stockId": stockId,
    };
  }
}
