// ============================================================
// DASHBOARD RESPONSE MODEL
// ============================================================

class DashboardResponseModel {
  final bool status;
  final String message;
  final DashboardDataModel? data;

  DashboardResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? DashboardDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// DASHBOARD DATA MODEL
// ============================================================

class DashboardDataModel {
  final DashboardSummaryModel summary;

  final List<OrdersLast7DaysModel> ordersLast7Days;

  final List<OrdersByStatusModel> ordersByStatus;

  DashboardDataModel({
    required this.summary,
    required this.ordersLast7Days,
    required this.ordersByStatus,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      summary: DashboardSummaryModel.fromJson(
        json['summary'] ?? {},
      ),

      ordersLast7Days: (json['orders_last_7_days'] as List? ?? [])
          .map(
            (item) => OrdersLast7DaysModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),

      ordersByStatus: (json['orders_by_status'] as List? ?? [])
          .map(
            (item) => OrdersByStatusModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

// ============================================================
// DASHBOARD SUMMARY MODEL
// ============================================================

class DashboardSummaryModel {
  final int totalProducts;
  final int totalOrders;
  final int totalCustomers;
  final double totalRevenue;

  DashboardSummaryModel({
    required this.totalProducts,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalRevenue,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalProducts: _parseInt(json['total_products']),

      totalOrders: _parseInt(json['total_orders']),

      totalCustomers: _parseInt(json['total_customers']),

      totalRevenue: _parseDouble(json['total_revenue']),
    );
  }
}

// ============================================================
// LAST 7 DAYS ORDERS MODEL
// ============================================================

class OrdersLast7DaysModel {
  final String date;
  final int orders;

  OrdersLast7DaysModel({
    required this.date,
    required this.orders,
  });

  factory OrdersLast7DaysModel.fromJson(Map<String, dynamic> json) {
    return OrdersLast7DaysModel(
      date: json['date']?.toString() ?? '',
      orders: _parseInt(json['orders']),
    );
  }
}

// ============================================================
// ORDERS BY STATUS MODEL
// ============================================================

class OrdersByStatusModel {
  final String status;
  final int count;

  OrdersByStatusModel({
    required this.status,
    required this.count,
  });

  factory OrdersByStatusModel.fromJson(Map<String, dynamic> json) {
    return OrdersByStatusModel(
      status: json['status']?.toString() ?? '',
      count: _parseInt(json['count']),
    );
  }
}

// ============================================================
// HELPER METHODS
// ============================================================

int _parseInt(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
}

double _parseDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is int) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}