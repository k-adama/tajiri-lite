import 'package:tajiri_waitress/app/services/api_result.service.dart';
import 'package:tajiri_waitress/app/services/http.service.dart';
import 'package:tajiri_waitress/app/services/network_exceptions.service.dart';
import 'package:tajiri_waitress/domain/entities/food_data.entity.dart';
import 'package:tajiri_waitress/domain/entities/orders_data.entity.dart';

class ProductsRepository {
  HttpService server = HttpService();

  Future<ApiResultService<List<FoodDataEntity>>> getFoods(
      String? typeQuery) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client
          .get('/products/foods/', queryParameters: {"typeQuery": typeQuery});

      return ApiResultService.success(
        data: (response.data as List)
            .map((element) => FoodDataEntity.fromJson(element))
            .toList(),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<dynamic>> getBundlePacks() async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response = await client.get(
        '/products/bundle-packs/',
      );

      return ApiResultService.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<OrdersDataEntity>> createOrder(dynamic data) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.post(
        '/orders/',
        data: data,
      );
      return ApiResultService.success(
        data: OrdersDataEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }

  Future<ApiResultService<OrdersDataEntity>> updateOrder(
      dynamic data, String id) async {
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: false);
      final response = await client.put(
        '/orders/$id/',
        data: data,
      );
      return ApiResultService.success(
        data: OrdersDataEntity.fromJson(response.data),
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }
}
