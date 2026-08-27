import 'package:dio/dio.dart';

import '../../../../core/api/dio_client.dart';
import '../shipment_tracking_modal.dart';


class ShipmentTrackingRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // TRACK SHIPMENT
  // ============================================================

  Future<ShipmentTrackingModel> trackShipment(
      String trackingNumber,
      ) async {
    try {
      final response = await _dio.get(
        '/track/$trackingNumber',
      );

      final data = response.data;

      if (data['status'] == true) {
        final result =
        ShipmentTrackingResponseModel.fromJson(data);

        if (result.data != null) {
          return result.data!;
        }

        throw Exception(
          'Shipment tracking details not found.',
        );
      }

      throw Exception(
        data['message'] ??
            'Shipment tracking details not found.',
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;

      // ==========================================================
      // 404 / INVALID TRACKING NUMBER
      // ==========================================================

      if (e.response?.statusCode == 404) {
        throw Exception(
          errorData is Map
              ? errorData['message'] ??
              'Shipment not found. Please check your tracking number.'
              : 'Shipment not found. Please check your tracking number.',
        );
      }

      throw Exception(
        errorData is Map
            ? errorData['message'] ??
            'Unable to track shipment.'
            : 'Unable to track shipment.',
      );
    }
  }
}