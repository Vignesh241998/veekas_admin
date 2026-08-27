import 'package:dio/dio.dart';

import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/storage/preference_service.dart';

import '../customer_order_model.dart';

class CustomerOrderRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<CustomerPlaceOrderResponseModel> placeOrder({
    required int addressId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.orders,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
        },
      );

      return CustomerPlaceOrderResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message']?.toString() ??
            'Unable to place order.'
            : 'Unable to place order.',
      );
    }
  }

  // ============================================================
  // GET CUSTOMER ORDERS
  // ============================================================

  Future<List<CustomerOrderResponseModel>>
  getCustomerOrders() async {
    try {
      // Get logged-in user ID from preferences
      final userId = PreferenceService.getUserId();

      if (userId == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final response = await _dio.get(
        ApiConstants.customerOrders
      );

      final responseData =
      Map<String, dynamic>.from(response.data);

      if (responseData['status'] != true) {
        throw Exception(
          responseData['message']?.toString() ??
              'Unable to fetch orders.',
        );
      }

      final List data =
          responseData['data'] ?? [];

      return data
          .map(
            (item) =>
            CustomerOrderResponseModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList();
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message']?.toString() ??
            'Unable to fetch orders.'
            : 'Unable to fetch orders.',
      );
    } catch (e) {
      rethrow;
    }
  }
}