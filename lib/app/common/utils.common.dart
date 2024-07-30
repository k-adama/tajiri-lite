import 'package:intl/intl.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

enum ListingType {
  table,
  waitress;
}

final customFormatForView = DateFormat('dd-MM-yyyy');
final customFormatForRequest = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

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

  return orderProduct.product.name;
}

ListingType? checkListingType(Staff? user) {
  return ListingType.waitress;
}

String convertTofrenchDate(String originalDate) {
  // Parse la date d'entrée
  DateTime parsedDate = customFormatForRequest.parse(originalDate);
  // Formate la date dans le format de sortie
  String formattedDate = customFormatForView.format(parsedDate);

  return formattedDate;
}
