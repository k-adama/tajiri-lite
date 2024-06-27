import 'package:tajiri_waitress/domain/entities/local_cart_enties/main_item.entity.dart';

class BagDataEntity {
  int index;
  String? idOrderToUpdate;
  String? orderNumber;
  List<MainCartEntity> bagProducts;
  List<MainCartEntity>? deleteProducts;

  String? waitressId;
  String? settleOrderId;

  BagDataEntity({
    required this.index,
    required this.bagProducts,
    this.idOrderToUpdate,
    this.orderNumber,
    this.waitressId,
    this.settleOrderId = "ON_PLACE",
    List<MainCartEntity>? deleteProducts,
  }) : deleteProducts = deleteProducts ?? [];

  factory BagDataEntity.fromJson(Map<String, dynamic> json) {
    return BagDataEntity(
      index: json['index'],
      waitressId: json['waitressId'],
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

// class BagDataEntity {
//   BagDataEntity({
//     int? index,
//     List<BagProductData>? bagProducts,
//   }) {
//     _index = index;
//     _bagProducts = bagProducts;
//   }

//   BagDataEntity.fromJson(dynamic json) {
//     _index = json['index'];
//     if (json['bag_products'] != null) {
//       _bagProducts = [];
//       json['bag_products'].forEach((v) {
//         _bagProducts?.add(BagProductData.fromJson(v));
//       });
//     }
//   }
//   int? _index;
//   List<BagProductData>? _bagProducts;

//   BagDataEntity copyWith({
//     int? index,
//     List<BagProductData>? bagProducts,
//   }) =>
//       BagDataEntity(
//         index: index ?? _index,
//         bagProducts: bagProducts ?? _bagProducts,
//       );

//   int? get index => _index;
//   List<BagProductData>? get bagProducts => _bagProducts;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['index'] = _index;
//     if (_bagProducts != null) {
//       map['bag_products'] = _bagProducts?.map((v) {
//         return v.toJsonInsert();
//       }).toList();
//     }
//     return map;
//   }
// }

// class BagProductData {
//   final List<MainItemEntity>? carts;
//   BagProductData({this.carts});

//   factory BagProductData.fromJson(Map data) {
//     List<BagProductData> newList = [];
//     List<MainItemEntity> newListMaintItem = [];
//     data["products"]?.forEach((item) {
//       newList.add(BagProductData.fromJson(item));
//       item['carts']?.forEach((element) {
//         newListMaintItem.add(MainItemEntity.fromJson(element));
//       });
//     });
//     return BagProductData(carts: newListMaintItem //data['cart_main_item']
//         );
//   }
//   BagProductData copyWith() {
//     return BagProductData(
//       carts: carts ?? carts,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (carts != null) map["products"] = toJsonCart();
//     return map;
//   }

//   Map<String, dynamic> toJsonInsert() {
//     final map = <String, dynamic>{};
//     if (carts != null) {
//       map["products"] = toJsonCart();
//     }
//     return map;
//   }

//   List<Map<String, dynamic>> toJsonCart() {
//     List<Map<String, dynamic>> list = [];
//     carts?.forEach((element) {
//       final map = <String, dynamic>{};
//       map['carts'] = carts;
//       list.add(map);
//     });
//     return list;
//   }
// }
