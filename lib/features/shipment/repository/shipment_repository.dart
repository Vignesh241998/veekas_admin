import 'package:dio/dio.dart';

import '../../../core/api/dio_client.dart';
import '../modal/shipment_modal.dart';

class ShipmentRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET ALL SHIPMENTS
  // ============================================================

  Future<List<ShipmentListModel>> getShipments() async {
    try {
      final response = await _dio.get(
        '/shipments',
      );

      final data = response.data;

      if (data['status'] == true) {
        final result =
        ShipmentListResponseModel.fromJson(data);

        return result.data;
      }

      throw Exception(
        data['message'] ??
            'Unable to load shipments.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to load shipments.'
            : 'Unable to load shipments.',
      );
    }
  }

  // ============================================================
  // CREATE SHIPMENT
  // ============================================================

  Future<void> createShipment({
    required int orderId,
    required String deliveryPartner,
  }) async {
    try {
      final response = await _dio.post(
        '/shipments',
        data: {
          'order_id': orderId,
          'delivery_partner': deliveryPartner,
        },
      );

      final data = response.data;

      if (data['status'] != true) {
        throw Exception(
          data['message'] ??
              'Unable to create shipment.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to create shipment.'
            : 'Unable to create shipment.',
      );
    }
  }

  // ============================================================
  // GET SHIPMENT DETAILS
  // ============================================================

  Future<ShipmentDetailModel> getShipmentDetails(
      int shipmentId,
      ) async {
    try {
      final response = await _dio.get(
        '/shipments/$shipmentId',
      );

      final data = response.data;

      if (data['status'] == true) {
        final result =
        ShipmentDetailResponseModel.fromJson(data);

        if (result.data != null) {
          return result.data!;
        }

        throw Exception(
          'shipment details not found.',
        );
      }

      throw Exception(
        data['message'] ??
            'Unable to load shipment details.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to load shipment details.'
            : 'Unable to load shipment details.',
      );
    }
  }

  // ============================================================
  // UPDATE SHIPPING STATUS
  // ============================================================

  Future<void> updateShippingStatus({
    required int shipmentId,
    required String shippingStatus,
  }) async {
    try {
      final response = await _dio.post(
        '/shipments/status/$shipmentId',
        data: {
          'shipping_status': shippingStatus,
        },
      );

      final data = response.data;

      if (data['status'] != true) {
        throw Exception(
          data['message'] ??
              'Unable to update shipment status.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to update shipment status.'
            : 'Unable to update shipment status.',
      );
    }
  }

  // ============================================================
  // CANCEL SHIPMENT
  // ============================================================

  Future<void> cancelShipment(
      int shipmentId,
      ) async {
    try {
      final response = await _dio.post(
        '/shipments/cancel/$shipmentId',
      );

      final data = response.data;

      if (data['status'] != true) {
        throw Exception(
          data['message'] ??
              'Unable to cancel shipment.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to cancel shipment.'
            : 'Unable to cancel shipment.',
      );
    }
  }
}