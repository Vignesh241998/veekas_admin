class OrderListResponseModel {
  final bool status;
  final String message;
  final List<OrderListModel> data;

  OrderListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderListResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderListResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map(
            (item) => OrderListModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

// ============================================================
// ORDER LIST MODEL
// ============================================================

class  OrderListModel {
  final int id;
  final String orderNumber;
  final String userName;
  final String mobile;
  final double grandTotal;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime? createdAt;

  OrderListModel({
    required this.id,
    required this.orderNumber,
    required this.userName,
    required this.mobile,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.createdAt,
  });

  factory OrderListModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderListModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      grandTotal:
      double.tryParse(json['grand_total'].toString()) ?? 0,
      paymentMethod:
      json['payment_method']?.toString() ?? '',
      paymentStatus:
      json['payment_status']?.toString() ?? '',
      orderStatus:
      json['order_status']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
        json['created_at'].toString(),
      )
          : null,
    );
  }
}

// ============================================================
// ORDER DETAIL RESPONSE
// ============================================================

class OrderDetailResponseModel {
  final bool status;
  final String message;
  final OrderDetailModel? data;

  OrderDetailResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory OrderDetailResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderDetailResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? OrderDetailModel.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// ORDER DETAIL MODEL
// ============================================================

class OrderDetailModel {
  final int id;
  final String orderNumber;

  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double grandTotal;

  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String status;

  final OrderUserModel? user;
  final OrderAddressModel? address;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.status,
    this.user,
    this.address,
    required this.items,
  });

  factory OrderDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderDetailModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      orderNumber:
      json['order_number']?.toString() ?? '',

      subtotal:
      double.tryParse(json['subtotal'].toString()) ?? 0,

      deliveryCharge:
      double.tryParse(
        json['delivery_charge'].toString(),
      ) ??
          0,

      discount:
      double.tryParse(json['discount'].toString()) ?? 0,

      grandTotal:
      double.tryParse(
        json['grand_total'].toString(),
      ) ??
          0,

      paymentMethod:
      json['payment_method']?.toString() ?? '',

      paymentStatus:
      json['payment_status']?.toString() ?? '',

      orderStatus:
      json['order_status']?.toString() ?? '',

      status:
      json['status']?.toString() ?? '',

      user: json['user'] != null
          ? OrderUserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      )
          : null,

      address: json['address'] != null
          ? OrderAddressModel.fromJson(
        json['address'] as Map<String, dynamic>,
      )
          : null,

      items: (json['items'] as List? ?? [])
          .map(
            (item) => OrderItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}

// ============================================================
// USER MODEL
// ============================================================

class OrderUserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;

  OrderUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
  });

  String get fullName =>
      '$firstName $lastName'.trim();

  factory OrderUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderUserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

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

class OrderAddressModel {
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

  final String addressType;

  OrderAddressModel({
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
    required this.addressType,
  });

  factory OrderAddressModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderAddressModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

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

      addressType:
      json['address_type']?.toString() ?? '',
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

    if (city.isNotEmpty || state.isNotEmpty) {
      parts.add(
        [city, state]
            .where(
              (value) => value.isNotEmpty,
        )
            .join(', '),
      );
    }

    if (country.isNotEmpty || pincode.isNotEmpty) {
      parts.add(
        [country, pincode]
            .where(
              (value) => value.isNotEmpty,
        )
            .join(' - '),
      );
    }

    return parts.join(', ');
  }
}

// ============================================================
// ORDER ITEM MODEL
// ============================================================

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int? variantId;

  final int quantity;
  final double price;
  final double totalPrice;
  final String status;

  final OrderProductModel? product;
  final OrderVariantModel? variant;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
    this.product,
    this.variant,
  });

  factory OrderItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderItemModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      orderId:
      int.tryParse(json['order_id'].toString()) ?? 0,

      productId:
      int.tryParse(json['product_id'].toString()) ?? 0,

      variantId: json['variant_id'] != null
          ? int.tryParse(
        json['variant_id'].toString(),
      )
          : null,

      quantity:
      int.tryParse(json['quantity'].toString()) ?? 0,

      price:
      double.tryParse(json['price'].toString()) ?? 0,

      totalPrice:
      double.tryParse(
        json['total_price'].toString(),
      ) ??
          0,

      status:
      json['status']?.toString() ?? '',

      product: json['product'] != null
          ? OrderProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      )
          : null,

      variant: json['variant'] != null
          ? OrderVariantModel.fromJson(
        json['variant'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// PRODUCT MODEL
// ============================================================

class OrderProductModel {
  final int id;
  final String productName;
  final String productCode;

  OrderProductModel({
    required this.id,
    required this.productName,
    required this.productCode,
  });

  factory OrderProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderProductModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      productName:
      json['product_name']?.toString() ?? '',

      productCode:
      json['product_code']?.toString() ?? '',
    );
  }
}

// ============================================================
// VARIANT MODEL
// ============================================================

class OrderVariantModel {
  final int id;
  final String sku;
  final double price;

  OrderVariantModel({
    required this.id,
    required this.sku,
    required this.price,
  });

  factory OrderVariantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OrderVariantModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      sku:
      json['sku']?.toString() ?? '',

      price:
      double.tryParse(json['price'].toString()) ?? 0,
    );
  }
}
