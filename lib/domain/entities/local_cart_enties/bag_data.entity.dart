import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';

class BagDataEntity {
  int index;
  String? idOrderToUpdate;
  String? orderNumber;
  List<MainCartEntity> bagProducts;
  List<MainCartEntity>? deleteProducts;

  String? waitressId;
  String? tableId;
  String? settleOrderId;

  BagDataEntity({
    required this.index,
    required this.bagProducts,
    this.idOrderToUpdate,
    this.orderNumber,
    this.waitressId,
    this.tableId,
    this.settleOrderId = "ON_PLACE",
    List<MainCartEntity>? deleteProducts,
  }) : deleteProducts = deleteProducts ?? [];

  factory BagDataEntity.fromJson(Map<String, dynamic> json) {
    return BagDataEntity(
      index: json['index'],
      waitressId: json['waitressId'],
      tableId: json['tableId'],
      settleOrderId: json['settleOrderId'],
      idOrderToUpdate: json['idOrderToUpdate'],
      orderNumber: json['orderNumber'],
      bagProducts: (json['bagProducts'] as List<dynamic>)
          .map((itemJson) => MainCartEntity.fromJson(itemJson))
          .toList(),
      deleteProducts: (json['deleteProducts'] as List<dynamic>)
          .map((itemJson) => MainCartEntity.fromJson(itemJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'index': index,
      'waitressId': waitressId,
      'tableId': tableId,
      'settleOrderId': settleOrderId,
      'idOrderToUpdate': idOrderToUpdate,
      'orderNumber': orderNumber,
      'bagProducts': bagProducts.map((item) => item.toJson()).toList(),
      'deleteProducts': deleteProducts?.map((item) => item.toJson()).toList(),
    };
    return data;
  }

  BagDataEntity copyWith() {
    return BagDataEntity(
      index: this.index,
      waitressId: this.waitressId,
      tableId: this.tableId,
      idOrderToUpdate: this.idOrderToUpdate,
      settleOrderId: this.settleOrderId,
      orderNumber: this.orderNumber,
      bagProducts: List<MainCartEntity>.from(
          this.bagProducts.map((item) => item.copyWith())),
      deleteProducts: List<MainCartEntity>.from(
          this.deleteProducts!.map((item) => item.copyWith())),
    );
  }
}
