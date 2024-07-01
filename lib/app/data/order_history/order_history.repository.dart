import 'package:tajiri_waitress/app/services/api_result.service.dart';
import 'package:tajiri_waitress/app/services/http.service.dart';
import 'package:tajiri_waitress/app/services/network_exceptions.service.dart';

class OrdersRepository {
  HttpService server = HttpService();

  Future<ApiResultService<dynamic>> getOrders(
      String? startDate, String? endDate, String? ownerId) async {
    final queryParameters = {
      'startDate': startDate,
      'endDate': endDate,
      'ownerId': ownerId,
    };
    try {
      final client =
          server.client(requireAuth: true, requireRestaurantId: true);
      final response =
          await client.get('/orders/', queryParameters: queryParameters);

      return ApiResultService.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResultService.failure(
          error: NetworkExceptionsService.getDioException(e),
          statusCode: NetworkExceptionsService.getDioStatus(e));
    }
  }
}
