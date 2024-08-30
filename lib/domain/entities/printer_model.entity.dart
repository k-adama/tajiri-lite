import 'package:tajiri_sdk/tajiri_sdk.dart';

class PrinterModelEntity {
  String? userName;
  String? restoName;
  String? userPhone;

  DateTime? createdOrder;
  String? statusOrder;
  String? orderNumber;
  String? orderCustomerId;
  String? orderPaymentMethodId;
  String? orderWaitressId;
  int grandTotal;

  List<OrderPrinterProduct> orderPrinterProducts;

  PrinterModelEntity({
    required this.userName,
    required this.restoName,
    required this.userPhone,
    required this.createdOrder,
    required this.statusOrder,
    required this.orderNumber,
    required this.orderCustomerId,
    required this.orderPaymentMethodId,
    required this.orderWaitressId,
    required this.orderPrinterProducts,
    required this.grandTotal,
  });
}

class OrderPrinterProduct {
  int quantity;
  String? orderProductid;
  String productName;
  String typeOfCooking;
  int productPrice;

  OrderPrinterProduct({
    required this.quantity,
    required this.productName,
    required this.orderProductid,
    required this.productPrice,
    required this.typeOfCooking,
  });

  int get totalPrice => quantity * productPrice;

  OrderPrinterProduct copyWith({
    int? quantity,
    String? orderProductId,
    String? productName,
    String? typeOfCooking,
    int? productPrice,
  }) {
    return OrderPrinterProduct(
      quantity: quantity ?? this.quantity,
      orderProductid: orderProductId ?? this.orderProductid,
      productName: productName ?? this.productName,
      typeOfCooking: typeOfCooking ?? this.typeOfCooking,
      productPrice: productPrice ?? this.productPrice,
    );
  }
}

extension OrderToPrinterModelEntity on Order {
  PrinterModelEntity toPrinterModelEntity(
      String? userName, String? restoName, String? userPhone) {
    return PrinterModelEntity(
      userName: userName ?? "",
      restoName: restoName ?? "",
      userPhone: userPhone ?? "",
      createdOrder: createdAt,
      statusOrder: status,
      orderNumber: orderNumber.toString(),
      orderCustomerId: customerId,
      orderPaymentMethodId:
          payments.isEmpty ? null : payments[0].paymentMethodId,
      orderWaitressId: waitressId,
      grandTotal: grandTotal,
      orderPrinterProducts: orderProducts.map((orderProduct) {
        return orderProduct.toOrderPrinterProduct();
      }).toList(),
    );
  }
}

extension ToOrderPrinterProduct on OrderProduct {
  OrderPrinterProduct toOrderPrinterProduct() {
    final typeOfCooking =
        (productTypeOfCooking != null) ? '(${productTypeOfCooking?.name})' : '';
    return OrderPrinterProduct(
        quantity: quantity,
        productName: product.name,
        productPrice: price,
        typeOfCooking: typeOfCooking,
        orderProductid: id);
  }
}
