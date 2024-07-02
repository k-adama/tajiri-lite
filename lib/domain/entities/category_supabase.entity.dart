class CategorySupabaseEntity {
  String? id;
  String? name;
  CategoryCollectionEntity? collectionId;
  String? description;
  String? iconUrl;
  String? createdAt;
  String? updatedAt;
  String? color;

  CategorySupabaseEntity(
      {this.id,
      this.name,
      this.collectionId,
      this.description,
      this.iconUrl,
      this.createdAt,
      this.updatedAt,
      this.color});

  CategorySupabaseEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    collectionId = CategoryCollectionEntity.fromJson(json['collectionId']);
    description = json['description'];
    iconUrl = json['iconUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['collectionId'] = collectionId?.toJson();
    data['description'] = description;
    data['iconUrl'] = iconUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['color'] = color;
    return data;
  }
}

class CategoryCollectionEntity {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  CategoryCollectionEntity(
      {this.id, this.name, this.createdAt, this.updatedAt});

  CategoryCollectionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
