class PaymentResponseModel {
  final bool status;
  final String message;
  final PaymentDataModel? data;

  PaymentResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaymentResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? PaymentDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

class PaymentDataModel {
  final int id;
  final int orderId;
  final String transactionId;
  final String? gatewayOrderId;
  final String paymentGateway;
  final String paymentMethod;
  final double amount;
  final String currency;
  final String paymentStatus;
  final String? gatewayResponse;
  final String? paidAt;
  final String status;

  PaymentDataModel({
    required this.id,
    required this.orderId,
    required this.transactionId,
    this.gatewayOrderId,
    required this.paymentGateway,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.paymentStatus,
    this.gatewayResponse,
    this.paidAt,
    required this.status,
  });

  factory PaymentDataModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaymentDataModel(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      transactionId: json['transaction_id']?.toString() ?? '',
      gatewayOrderId: json['gateway_order_id']?.toString(),
      paymentGateway: json['payment_gateway']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      currency: json['currency']?.toString() ?? 'INR',
      paymentStatus: json['payment_status']?.toString() ?? '',
      gatewayResponse: json['gateway_response']?.toString(),
      paidAt: json['paid_at']?.toString(),
      status: json['status']?.toString() ?? '',
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
