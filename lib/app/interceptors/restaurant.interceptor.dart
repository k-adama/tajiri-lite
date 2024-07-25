import 'package:dio/dio.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';

class RestaurantInterceptor extends Interceptor {
  final bool requireRestaurantId;

  RestaurantInterceptor({required this.requireRestaurantId});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (requireRestaurantId) {
      final userDecoding = AppHelpersCommon.getUserInLocalStorage();

      final String restaurantId = userDecoding!.restaurantId;
      if (restaurantId.isNotEmpty) {
        options.headers.addAll({'restaurantId': restaurantId});
      }
    }
    handler.next(options);
  }
}
