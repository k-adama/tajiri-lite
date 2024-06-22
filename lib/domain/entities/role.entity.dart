class RoleEntity {
  String? id;
  String? name;
  String? description;
  String? restaurantId;
  String? createdAt;
  String? updatedAt;

  RoleEntity({
    this.id,
    this.name,
    this.description,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
  });

  RoleEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    restaurantId = json['restaurantId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['restaurantId'] = restaurantId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}
