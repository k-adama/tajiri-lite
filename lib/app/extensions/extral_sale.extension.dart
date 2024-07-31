import 'package:tajiri_sdk/tajiri_sdk.dart';

extension ToSaleItem on ExtraSale {
  SaleItem toSaleItem() {
    return SaleItem(
        itemId: "",
        itemName: name,
        totalAmount: 0,
        qty: qtySales,
        mainCategoryId: "",
        waitresses: []);
  }
}
