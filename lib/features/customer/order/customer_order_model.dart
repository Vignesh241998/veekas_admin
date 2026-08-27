// ============================================================
// PLACE ORDER RESPONSE MODEL
// ============================================================

class CustomerPlaceOrderResponseModel {
  final bool status;
  final String message;
  final OrderDataModel? data;

  CustomerPlaceOrderResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory CustomerPlaceOrderResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerPlaceOrderResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? OrderDataModel.fromJson(
        Map<String, dynamic>.from(json['data']),
      )
          : null,
    );
  }
}

// ============================================================
// PLACED ORDER DATA
// ============================================================

class OrderDataModel {
  final int orderId;
  final String orderNumber;
  final double grandTotal;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;

  OrderDataModel({
    required this.orderId,
    required this.orderNumber,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
  });

  factory OrderDataModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderDataModel(
      orderId: _toInt(json['order_id']),
      orderNumber: json['order_number']?.toString() ?? '',
      grandTotal: _toDouble(json['grand_total']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}

// ============================================================
// CUSTOMER ORDER HISTORY RESPONSE MODEL
// ============================================================

class CustomerOrderResponseModel {
  final int id;
  final String orderNumber;
  final String userName;
  final String mobile;
  final double grandTotal;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? trackingNumber;
  final DateTime? createdAt;

  CustomerOrderResponseModel({
    required this.id,
    required this.orderNumber,
    required this.userName,
    required this.mobile,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.trackingNumber,
    this.createdAt,
  });

  factory CustomerOrderResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerOrderResponseModel(
      id: _toInt(json['id']),
      orderNumber: json['order_number']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      grandTotal: _toDouble(json['grand_total']),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      trackingNumber: json['tracking_number'] != null
          ? json['tracking_number'].toString()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
        json['created_at'].toString(),
      )
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}

// ============================================================
// CUSTOMER ORDER LIST RESPONSE
// ============================================================

