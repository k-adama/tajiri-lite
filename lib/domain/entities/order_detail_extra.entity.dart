import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';

class OrderDetailExtraEntity {
  String? id;
  String? foodId;
  int? quantity;
  String? orderDetailId;
  String? createdAt;
  String? updatedAt;
  FoodDataEntity? food;

  OrderDetailExtraEntity(
      {this.id,
      this.foodId,
      this.quantity,
      this.orderDetailId,
      this.createdAt,
      this.updatedAt,
      this.food});

  OrderDetailExtraEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['foodId'];
    quantity = json['quantity'];
    orderDetailId = json['orderDetailId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    food = json['food'] != null ? FoodDataEntity.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['foodId'] = foodId;
    data['quantity'] = quantity;
    data['orderDetailId'] = orderDetailId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (food != null) {
      data['food'] = food!.toJson();
    }
    return data;
  }
}
