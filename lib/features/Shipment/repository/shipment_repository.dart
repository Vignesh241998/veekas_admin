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
              'Unable to create Shipment.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to create Shipment.'
            : 'Unable to create Shipment.',
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
          'Shipment details not found.',
        );
      }

      throw Exception(
        data['message'] ??
            'Unable to load Shipment details.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to load Shipment details.'
            : 'Unable to load Shipment details.',
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
              'Unable to update Shipment status.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to update Shipment status.'
            : 'Unable to update Shipment status.',
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
              'Unable to cancel Shipment.',
        );
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to cancel Shipment.'
            : 'Unable to cancel Shipment.',
      );
    }
  }
}