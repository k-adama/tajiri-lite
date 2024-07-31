import 'package:tajiri_sdk/tajiri_sdk.dart';

extension OrderCopyWith on Order {
  Order copyWith({
    String? id,
    int? orderNumber,
    int? subTotal,
    int? grandTotal,
    int? tax,
    String? tableId,
    String? waitressId,
    String? restaurantId,
    String? createdId,
    String? customerType,
    String? customerId,
    String? orderType,
    String? pinCode,
    String? provider,
    String? address,
    String? couponCode,
    String? orderNotes,
    int? discountAmount,
    DateTime? deliveryDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Payment>? payments,
    List<OrderProduct>? orderProducts,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      subTotal: subTotal ?? this.subTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      tax: tax ?? this.tax,
      tableId: tableId ?? this.tableId,
      waitressId: waitressId ?? this.waitressId,
      restaurantId: restaurantId ?? this.restaurantId,
      createdId: createdId ?? this.createdId,
      customerType: customerType ?? this.customerType,
      customerId: customerId ?? this.customerId,
      orderType: orderType ?? this.orderType,
      pinCode: pinCode ?? this.pinCode,
      provider: provider ?? this.provider,
      address: address ?? this.address,
      couponCode: couponCode ?? this.couponCode,
      orderNotes: orderNotes ?? this.orderNotes,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payments: payments ?? this.payments,
      orderProducts: orderProducts ?? this.orderProducts,
    );
  }

  List<Payment> get validPayments {
    return payments.where((payment) => payment.status == "COMPLETED").toList();
  }
}
