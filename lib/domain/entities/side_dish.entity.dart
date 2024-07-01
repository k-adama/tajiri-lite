class SideDishFoodEntity {
  String? id;
  String? mainFoodId;
  String? sideDishId;
  String? createdAt;
  String? updatedAt;
  SideDishEntity? sideDish;

  SideDishFoodEntity(
      {this.id,
      this.mainFoodId,
      this.sideDishId,
      this.createdAt,
      this.updatedAt,
      this.sideDish});

  SideDishFoodEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainFoodId = json['mainFoodId'];
    sideDishId = json['sideDishId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sideDish = json['sideDish'] != null
        ? new SideDishEntity.fromJson(json['sideDish'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainFoodId'] = this.mainFoodId;
    data['sideDishId'] = this.sideDishId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.sideDish != null) {
      data['sideDish'] = this.sideDish!.toJson();
    }
    return data;
  }
}

class SideDishEntity {
  String? id;
  String? name;
  int? price;

  SideDishEntity({this.id, this.name, this.price});

  SideDishEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    return data;
  }

  SideDishEntity copyWith() {
    return SideDishEntity(
      id: this.id,
      name: this.name,
      price: this.price,
    );
  }
}

class SideDishAndQuantityEntity {
  SideDishEntity? sideDish;
  int? quantity;

  SideDishAndQuantityEntity({this.sideDish, this.quantity});

  SideDishAndQuantityEntity.fromJson(Map<String, dynamic> json) {
    sideDish = json['sideDish'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sideDish'] = sideDish;
    data['quantity'] = quantity;
    return data;
  }

  SideDishAndQuantityEntity copyWith() {
    return SideDishAndQuantityEntity(
      sideDish: this.sideDish?.copyWith(),
      quantity: this.quantity,
    );
  }
}
