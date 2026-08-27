// ============================================================
// SHIPMENT LIST RESPONSE MODEL
// ============================================================

class ShipmentListResponseModel {
  final bool status;
  final String message;
  final List<ShipmentListModel> data;

  ShipmentListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShipmentListResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentListResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map(
            (item) => ShipmentListModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

// ============================================================
// SHIPMENT LIST MODEL
// ============================================================

class ShipmentListModel {
  final int id;
  final String orderNumber;
  final String deliveryPartner;
  final String trackingNumber;
  final String awbNumber;
  final String shipmentId;
  final String shippingStatus;
  final DateTime? expectedDeliveryDate;
  final String labelUrl;

  ShipmentListModel({
    required this.id,
    required this.orderNumber,
    required this.deliveryPartner,
    required this.trackingNumber,
    required this.awbNumber,
    required this.shipmentId,
    required this.shippingStatus,
    this.expectedDeliveryDate,
    required this.labelUrl,
  });

  factory ShipmentListModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentListModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      orderNumber:
      json['order_number']?.toString() ?? '',

      deliveryPartner:
      json['delivery_partner']?.toString() ?? '',

      trackingNumber:
      json['tracking_number']?.toString() ?? '',

      awbNumber:
      json['awb_number']?.toString() ?? '',

      shipmentId:
      json['shipment_id']?.toString() ?? '',

      shippingStatus:
      json['shipping_status']?.toString() ?? '',

      expectedDeliveryDate:
      json['expected_delivery_date'] != null
          ? DateTime.tryParse(
        json['expected_delivery_date'].toString(),
      )
          : null,

      labelUrl:
      json['label_url']?.toString() ?? '',
    );
  }
}

// ============================================================
// SHIPMENT DETAIL RESPONSE MODEL
// ============================================================

class ShipmentDetailResponseModel {
  final bool status;
  final String message;
  final ShipmentDetailModel? data;

  ShipmentDetailResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ShipmentDetailResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentDetailResponseModel(
      status: json['status'] == true,

      message:
      json['message']?.toString() ?? '',

      data: json['data'] != null
          ? ShipmentDetailModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// SHIPMENT DETAIL MODEL
// ============================================================

class ShipmentDetailModel {
  final int id;
  final int orderId;

  final String deliveryPartner;
  final String trackingNumber;
  final String awbNumber;
  final String shipmentId;
  final String labelUrl;

  final DateTime? pickupDate;
  final DateTime? expectedDeliveryDate;

  final String shippingStatus;
  final String status;

  final ShipmentOrderModel? order;

  ShipmentDetailModel({
    required this.id,
    required this.orderId,
    required this.deliveryPartner,
    required this.trackingNumber,
    required this.awbNumber,
    required this.shipmentId,
    required this.labelUrl,
    this.pickupDate,
    this.expectedDeliveryDate,
    required this.shippingStatus,
    required this.status,
    this.order,
  });

  factory ShipmentDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentDetailModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      orderId: int.tryParse(
        json['order_id'].toString(),
      ) ??
          0,

      deliveryPartner:
      json['delivery_partner']?.toString() ?? '',

      trackingNumber:
      json['tracking_number']?.toString() ?? '',

      awbNumber:
      json['awb_number']?.toString() ?? '',

      shipmentId:
      json['shipment_id']?.toString() ?? '',

      labelUrl:
      json['label_url']?.toString() ?? '',

      pickupDate:
      json['pickup_date'] != null
          ? DateTime.tryParse(
        json['pickup_date'].toString(),
      )
          : null,

      expectedDeliveryDate:
      json['expected_delivery_date'] != null
          ? DateTime.tryParse(
        json['expected_delivery_date'].toString(),
      )
          : null,

      shippingStatus:
      json['shipping_status']?.toString() ?? '',

      status:
      json['status']?.toString() ?? '',

      order: json['order'] != null
          ? ShipmentOrderModel.fromJson(
        json['order'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// SHIPMENT ORDER MODEL
// ============================================================

class ShipmentOrderModel {
  final int id;
  final String orderNumber;
  final double grandTotal;
  final String orderStatus;

  final ShipmentCustomerModel? user;
  final ShipmentAddressModel? address;

  ShipmentOrderModel({
    required this.id,
    required this.orderNumber,
    required this.grandTotal,
    required this.orderStatus,
    this.user,
    this.address,
  });

  factory ShipmentOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentOrderModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      orderNumber:
      json['order_number']?.toString() ?? '',

      grandTotal:
      double.tryParse(
        json['grand_total'].toString(),
      ) ??
          0,

      orderStatus:
      json['order_status']?.toString() ?? '',

      user: json['user'] != null
          ? ShipmentCustomerModel.fromJson(
        json['user'] as Map<String, dynamic>,
      )
          : null,

      address: json['address'] != null
          ? ShipmentAddressModel.fromJson(
        json['address'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// CUSTOMER MODEL
// ============================================================

class ShipmentCustomerModel {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;

  ShipmentCustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
  });

  String get fullName =>
      '$firstName $lastName'.trim();

  factory ShipmentCustomerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentCustomerModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      firstName:
      json['first_name']?.toString() ?? '',

      lastName:
      json['last_name']?.toString() ?? '',

      mobile:
      json['mobile']?.toString() ?? '',

      email:
      json['email']?.toString() ?? '',
    );
  }
}

// ============================================================
// ADDRESS MODEL
// ============================================================

class ShipmentAddressModel {
  final int id;
  final String fullName;
  final String mobile;

  final String addressLine1;
  final String addressLine2;
  final String landmark;

  final String city;
  final String state;
  final String country;
  final String pincode;

  ShipmentAddressModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory ShipmentAddressModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShipmentAddressModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      fullName:
      json['full_name']?.toString() ?? '',

      mobile:
      json['mobile']?.toString() ?? '',

      addressLine1:
      json['address_line1']?.toString() ?? '',

      addressLine2:
      json['address_line2']?.toString() ?? '',

      landmark:
      json['landmark']?.toString() ?? '',

      city:
      json['city']?.toString() ?? '',

      state:
      json['state']?.toString() ?? '',

      country:
      json['country']?.toString() ?? '',

      pincode:
      json['pincode']?.toString() ?? '',
    );
  }

  String get fullAddress {
    final parts = <String>[];

    if (addressLine1.isNotEmpty) {
      parts.add(addressLine1);
    }

    if (addressLine2.isNotEmpty) {
      parts.add(addressLine2);
    }

    if (landmark.isNotEmpty) {
      parts.add(landmark);
    }

    if (city.isNotEmpty) {
      parts.add(city);
    }

    if (state.isNotEmpty) {
      parts.add(state);
    }

    if (country.isNotEmpty) {
      parts.add(country);
    }

    if (pincode.isNotEmpty) {
      parts.add(pincode);
    }

    return parts.join(', ');
  }
}