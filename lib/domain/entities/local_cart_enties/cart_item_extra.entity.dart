class CartItemExtraEntity {
  String? foodId;
  int? quantity;
  String? foodName;

  CartItemExtraEntity({this.foodId, this.quantity, this.foodName});

  CartItemExtraEntity.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    quantity = json['quantity'];
    foodName = json['foodName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodId'] = foodId;
    data['quantity'] = quantity;
    data['foodName'] = foodName;
    return data;
  }
}
