class PaymentMethodEntity {
  PaymentMethodEntity({
    String? id,
    String? name,
    bool? status,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _status = status;
    _restaurantId = restaurantId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  String? _id;
  String? _name;
  bool? _status;
  String? _restaurantId;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  String? get name => _name;
  bool? get status => _status;
  String? get restaurantId => _restaurantId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  PaymentMethodEntity.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'];
    _restaurantId = json['restaurantId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  PaymentMethodEntity copyWith({
    String? id,
    String? name,
    bool? status,
    String? restaurantId,
    String? createdAt,
    String? updatedAt,
  }) =>
      PaymentMethodEntity(
        id: id ?? _id,
        name: name ?? _name,
        status: status ?? _status,
        restaurantId: restaurantId ?? _restaurantId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['status'] = _status;
    map['restaurantId'] = _restaurantId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

class PaymentValuesEntity {
  String? paymentMethodId;
  String? customerId;
  int? amount;
  String? phoneCustomer;
  String? status;
  PaymentMethodEntity? paymentMethod;

  PaymentValuesEntity({this.paymentMethodId, this.customerId, this.amount, this.phoneCustomer, this.status, this.paymentMethod});

  PaymentValuesEntity.fromJson(Map<String, dynamic> json) {
    paymentMethodId = json['paymentMethodId'];
    customerId = json['customerId'];
    amount = json['amount'];
    phoneCustomer = json['phoneCustomer'];
    status = json['status'];
    paymentMethod = PaymentMethodEntity.fromJson(json['paymentMethod']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['paymentMethodId'] = paymentMethodId;
    data['customerId'] = customerId;
    data['amount'] = amount;
    data['phoneCustomer'] = phoneCustomer;
    data['status'] = status;
    data['paymentMethod'] = paymentMethod;
    return data;
  }
}