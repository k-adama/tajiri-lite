import 'package:tajiri_waitress/domain/entities/orders_details.entity.dart';
import 'package:tajiri_waitress/domain/entities/user.entity.dart';

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
String getNameFromOrderDetail(OrderDetailsEntity? orderDetail) {
  if (orderDetail == null) {
    return 'N/A';
  }
  if (orderDetail.food == null) {
    if (orderDetail.bundle != null) {
      return orderDetail.bundle['name'] ?? 'Produit supprimé';
    } else {
      return 'Produit supprimé';
    }
  } else {
    return orderDetail.food?.name ?? 'N/A';
  }
}
ListingType? checkListingType(UserEntity? user) {
  if (user?.restaurantUser?[0].restaurant?.listingEnable != true) {
    return null;
  }

  return user!.restaurantUser?[0].restaurant?.listingType == "TABLE"
      ? ListingType.table
      : ListingType.waitress;
}