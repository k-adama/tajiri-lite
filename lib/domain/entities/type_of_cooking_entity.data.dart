class TypeOfCookingEntityData {
  String? id;
  String? name;
  String? restaurantId;

  TypeOfCookingEntityData({this.id, this.name, this.restaurantId});

  TypeOfCookingEntityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    restaurantId = json['restaurantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['restaurantId'] = restaurantId;

    return data;
  }
}
