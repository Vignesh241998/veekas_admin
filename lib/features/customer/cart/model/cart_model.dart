import '../../../product_variant/modal/variant_attribute_modal.dart';

// ============================================================
// CART VARIANT MODEL
// ============================================================

class CartVariantModel {
  final int variantId;
  final List<VariantAttributeModel> attributes;

  CartVariantModel({
    required this.variantId,
    required this.attributes,
  });

  factory CartVariantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final List<dynamic> attributesJson =
    json['attributes'] is List
        ? json['attributes']
        : [];

    return CartVariantModel(
      variantId:
      int.tryParse(
        json['variant_id'].toString(),
      ) ??
          0,

      attributes: attributesJson
          .whereType<Map>()
          .map(
            (item) =>
            VariantAttributeModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList(),
    );
  }
}

// ============================================================
// CART ITEM
// ============================================================

class CartModel {
  final int cartId;
  final int userId;
  final int productId;

  final String productName;
  final String productCode;

  final String category;
  final String subCategory;
  final String brand;

  final String? thumbnailImage;

  final bool hasVariant;

  final CartVariantModel? variant;

  final double price;
  final int quantity;
  final double totalPrice;

  final String status;
  final String createdAt;

  CartModel({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.thumbnailImage,
    required this.hasVariant,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory CartModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartModel(
      cartId:
      int.tryParse(
        json['cart_id'].toString(),
      ) ??
          0,

      userId:
      int.tryParse(
        json['user_id'].toString(),
      ) ??
          0,

      productId:
      int.tryParse(
        json['product_id'].toString(),
      ) ??
          0,

      productName:
      json['product_name']?.toString() ?? '',

      productCode:
      json['product_code']?.toString() ?? '',

      category:
      json['category']?.toString() ?? '',

      subCategory:
      json['sub_category']?.toString() ?? '',

      brand:
      json['brand']?.toString() ?? '',

      thumbnailImage:
      json['thumbnail_image']?.toString(),

      hasVariant:
      json['has_variant'] == true ||
          json['has_variant'] == 1 ||
          json['has_variant'] == '1',

      variant:
      json['variant'] is Map
          ? CartVariantModel.fromJson(
        Map<String, dynamic>.from(
          json['variant'],
        ),
      )
          : null,

      price:
      double.tryParse(
        json['price'].toString(),
      ) ??
          0,

      quantity:
      int.tryParse(
        json['quantity'].toString(),
      ) ??
          0,

      totalPrice:
      double.tryParse(
        json['total_price'].toString(),
      ) ??
          0,

      status:
      json['status']?.toString() ?? '',

      createdAt:
      json['created_at']?.toString() ?? '',
    );
  }
}

// ============================================================
// CART RESPONSE
// ============================================================

class CartResponseModel {
  final int totalItems;
  final double grandTotal;
  final List<CartModel> items;

  CartResponseModel({
    required this.totalItems,
    required this.grandTotal,
    required this.items,
  });

  factory CartResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final List<dynamic> data =
    json['data'] is List
        ? json['data']
        : [];

    return CartResponseModel(
      totalItems:
      int.tryParse(
        json['total_items'].toString(),
      ) ??
          0,

      grandTotal:
      double.tryParse(
        json['grand_total'].toString(),
      ) ??
          0,

      items: data
          .whereType<Map>()
          .map(
            (item) =>
            CartModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList(),
    );
  }
}