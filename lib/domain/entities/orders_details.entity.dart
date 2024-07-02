import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/order_detail_extra.entity.dart';

class OrderDetailsEntity {
  OrderDetailsEntity({
    String? id,
    String? foodId,
    String? bundleId,
    int? price,
    int? quantity,
    String? orderId,
    String? createdAt,
    String? updatedAt,
    String? typeOfCooking,
    List<OrderDetailExtraEntity>? orderDetailExtra,
    FoodDataEntity? food,
    dynamic bundle,
  }) {
    _id = id;
    _foodId = foodId;
    _bundleId = bundleId;
    _price = price;
    _quantity = quantity;
    _orderId = orderId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _typeOfCooking = typeOfCooking;
    _orderDetailExtra = orderDetailExtra;
    _food = food;
    _bundle = bundle;
  }

  OrderDetailsEntity.fromJson(dynamic json) {
    _id = json['id'];
    _foodId = json['foodId'];
    _bundleId = json['bundleId'];
    _price = json['price'];
    _quantity = json['quantity'];
    _orderId = json['orderId'];
    _typeOfCooking = json['typeOfCooking'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['orderDetailExtra'] != null) {
      _orderDetailExtra = [];
      json['orderDetailExtra'].forEach((v) {
        _orderDetailExtra?.add(OrderDetailExtraEntity.fromJson(v));
      });
    }
    _food = json['food'] != null ? FoodDataEntity.fromJson(json['food']) : null;
    _bundle = json['bundle'];
  }

  String? _id;
  String? _foodId;
  String? _bundleId;
  int? _price;
  int? _quantity;
  String? _orderId;
  String? _createdAt;
  String? _updatedAt;
  String? _typeOfCooking;
  List<OrderDetailExtraEntity>? _orderDetailExtra;
  FoodDataEntity? _food;
  dynamic _bundle;

  String? get id => _id;
  String? get foodId => _foodId;
  String? get bundleId => _bundleId;
  int? get price => _price;
  int? get quantity => _quantity;
  String? get orderId => _orderId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get typeOfCooking => _typeOfCooking;
  List<OrderDetailExtraEntity>? get orderDetailExtra => _orderDetailExtra;
  FoodDataEntity? get food => _food;
  dynamic get bundle => _bundle;

  OrderDetailsEntity copyWith({
    String? id,
    String? foodId,
    String? bundleId,
    int? price,
    int? quantity,
    String? orderId,
    String? createdAt,
    String? typeOfCooking,
    String? updatedAt,
    List<OrderDetailExtraEntity>? orderDetailExtra,
    FoodDataEntity? food,
    dynamic bundle,
  }) =>
      OrderDetailsEntity(
        id: id ?? _id,
        foodId: foodId ?? _foodId,
        bundleId: bundleId ?? _bundleId,
        price: price ?? _price,
        quantity: quantity ?? _quantity,
        orderId: orderId ?? _orderId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        typeOfCooking: _typeOfCooking ?? typeOfCooking,
        //orderDetailExtra: orderDetailExtra ?? _orderDetailExtra,
        food: food ?? _food,
        bundle: bundle ?? _bundle,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['foodId'] = _foodId;
    map['bundleId'] = _bundleId;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['orderId'] = _orderId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['typeOfCooking'] = typeOfCooking;
    if (_orderDetailExtra != null) {
      map['orderDetailExtra'] =
          _orderDetailExtra?.map((v) => v.toJson()).toList();
    }
    if (_food != null) {
      map['food'] = _food?.toJson();
    }
    if (_bundle != null) {
      map['bundle'] = _bundle?.toJson();
    }
    return map;
  }

  set id(String? value) {
    _id = value;
  }

  set foodId(String? value) {
    _foodId = value;
  }

  set bundleId(String? value) {
    _bundleId = value;
  }

  set price(int? value) {
    _price = value;
  }

  set quantity(int? value) {
    _quantity = value;
  }

  set orderId(String? value) {
    _orderId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set typeOfCooking(String? value) {
    _typeOfCooking = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }

  set orderDetailExtra(List<OrderDetailExtraEntity>? value) {
    _orderDetailExtra = value;
  }

  set food(FoodDataEntity? value) {
    _food = value;
  }

  set bundle(dynamic value) {
    _bundle = value;
  }
}
