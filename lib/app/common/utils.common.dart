import 'package:tajiri_sdk/tajiri_sdk.dart';

enum ListingType {
  table,
  waitress;
}

String formatNumber(double number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
  } else {
    return number.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }
  
}
String getNameFromOrderDetail(OrderProduct? orderProduct) {
  if (orderProduct == null) {
    return 'N/A';
  }
  if (orderProduct.product == null) {
    return 'Produit supprimé';
  } else {
    return orderProduct.product.name ?? 'N/A';
  }
}
ListingType? checkListingType(Staff? user) {
  if (false) { //user?.restaurantUser?[0].restaurant?.listingEnable != true
    return null;
  }

  return false//user!.restaurantUser?[0].restaurant?.listingType == "TABLE"
      ? ListingType.table
      : ListingType.waitress;
}