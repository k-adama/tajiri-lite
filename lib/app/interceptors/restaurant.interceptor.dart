import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tajiri_waitress/app/config/constants/user.constant.dart';
import 'package:tajiri_waitress/app/services/local_storage.service.dart';
import 'package:tajiri_sdk/src/models/staff.model.dart';

class RestaurantInterceptor extends Interceptor {
  final bool requireRestaurantId;

  RestaurantInterceptor({required this.requireRestaurantId});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (requireRestaurantId) {
      final String userEncoding =
          LocalStorageService.instance.get(UserConstant.keyUser) ?? "";
      final userDecoding = Staff.fromJson(
          jsonDecode(LocalStorageService.instance.get(UserConstant.keyUser)!));
      final String restaurantId = userDecoding.restaurantId;
      if (restaurantId.isNotEmpty) {
        options.headers.addAll({'restaurantId': restaurantId});
      }
    }
    handler.next(options);
  }
}
