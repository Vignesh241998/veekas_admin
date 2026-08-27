import 'package:dio/dio.dart';

import '../../../core/api/dio_client.dart';
import '../modal/order_modal.dart';

class OrderRepository {
  final Dio _dio = DioClient.instance;

// ============================================================
// GET ALL ORDERS
// ============================================================

  Future<List<OrderListModel>> getOrders() async {
    try {
      final response = await _dio.get(
        '/orders',
      );

      final data = response.data;

      if (data['status'] == true) {
        final result =
        OrderListResponseModel.fromJson(data);

        return result.data;
      }

      throw Exception(
        data['message'] ??
            'Unable to load orders.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to load orders.'
            : 'Unable to load orders.',
      );
    }
  }

// ============================================================
// GET ORDER DETAILS
// ============================================================

  Future<OrderDetailModel> getOrderDetails(
      int orderId,
      ) async {
    try {
      final response = await _dio.get(
        '/orders/$orderId',
      );

      final data = response.data;

      if (data['status'] == true) {
        final result =
        OrderDetailResponseModel.fromJson(data);

        if (result.data != null) {
          return result.data!;
        }

        throw Exception(
          'Order details not found.',
        );
      }

      throw Exception(
        data['message'] ??
            'Unable to load order details.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to load order details.'
            : 'Unable to load order details.',
      );
    }
  }

// ============================================================
// UPDATE ORDER STATUS
// ============================================================

  Future<void> updateOrderStatus({
    required int orderId,
    required String orderStatus,
  }) async {
    try {
      final response = await _dio.post(
        '/orders/status/$orderId',
        data: {
          'order_status': orderStatus,
        },
      );

      final data = response.data;

      if (data['status'] != true) {
        throw Exception(
          data['message'] ??
              'Unable to update order status.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to update order status.'
            : 'Unable to update order status.',
      );
    }
  }
}
