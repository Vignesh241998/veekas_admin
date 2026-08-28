class ShipmentTrackingResponseModel {
  final bool status;
  final String message;
  final ShipmentTrackingModel? data;

  ShipmentTrackingResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ShipmentTrackingResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentTrackingResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? ShipmentTrackingModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// SHIPMENT TRACKING MODEL
// ============================================================

class ShipmentTrackingModel {
  final String trackingNumber;
  final String shippingStatus;
  final DateTime? expectedDeliveryDate;
  final String deliveryPartner;

  ShipmentTrackingModel({
    required this.trackingNumber,
    required this.shippingStatus,
    this.expectedDeliveryDate,
    required this.deliveryPartner,
  });

  factory ShipmentTrackingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentTrackingModel(
      trackingNumber:
      json['tracking_number']?.toString() ?? '',

      shippingStatus:
      json['shipping_status']?.toString() ?? '',

      expectedDeliveryDate:
      json['expected_delivery_date'] != null
          ? DateTime.tryParse(
        json['expected_delivery_date'].toString(),
      )
          : null,

      deliveryPartner:
      json['delivery_partner']?.toString() ?? '',
    );
  }
}