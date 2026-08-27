import 'package:dio/dio.dart';

import '../../../../core/api/dio_client.dart';
import '../payment_modal.dart';

class PaymentRepository {
  final Dio _dio = DioClient.instance;

// ============================================================
// CREATE PAYMENT
// POST /payments
// ============================================================

  Future<PaymentResponseModel> createPayment({
    required int orderId,
  }) async {
    try {
      final response = await _dio.post(
        '/payments',
        data: {
          'order_id': orderId,
        },
      );

      final data = response.data;

      if (data['status'] == true) {
        return PaymentResponseModel.fromJson(data);
      }

      throw Exception(
        data['message'] ?? 'Unable to create payment.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message']?.toString() ??
            'Unable to create payment.'
            : 'Unable to create payment.',
      );
    }
  }

// ============================================================
// PAYMENT SUCCESS
// POST /payments/success/{id}
// ============================================================

  Future<PaymentResponseModel> paymentSuccess({
    required int paymentId,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/success/$paymentId',
      );

      final data = response.data;

      if (data['status'] == true) {
        return PaymentResponseModel.fromJson(data);
      }

      throw Exception(
        data['message'] ?? 'Payment failed.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message']?.toString() ?? 'Payment failed.'
            : 'Payment failed.',
      );
    }
  }

// ============================================================
// PAYMENT FAILED
// POST /payments/failed/{id}
// ============================================================

  Future<PaymentResponseModel> paymentFailed({
    required int paymentId,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/failed/$paymentId',
      );

      final data = response.data;

      if (data['status'] == true) {
        return PaymentResponseModel.fromJson(data);
      }

      throw Exception(
        data['message'] ?? 'Payment failed.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message']?.toString() ?? 'Payment failed.'
            : 'Payment failed.',
      );
    }
  }
}
