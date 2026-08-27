import 'variant_attribute_modal.dart';

class ProductVariantModel {
  final int? id;
  final int productId;

  final double actualPrice;
  final double discountPrice;

  final int stock;

  final String sku;
  final String status;

  final List<VariantAttributeModel> attributes;

  ProductVariantModel({
    this.id,
    required this.productId,
    required this.actualPrice,
    required this.discountPrice,
    required this.stock,
    required this.sku,
    required this.status,
    required this.attributes,
  });

  factory ProductVariantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final List<dynamic> attributesJson =
    json['attributes'] is List
        ? json['attributes']
        : [];

    return ProductVariantModel(
      id: json['id'] != null
          ? int.tryParse(json['id'].toString())
          : null,

      productId: int.tryParse(
        json['product_id'].toString(),
      ) ??
          0,

      actualPrice: double.tryParse(
        json['actual_price'].toString(),
      ) ??
          0,

      discountPrice: double.tryParse(
        json['discount_price'].toString(),
      ) ??
          0,

      stock: int.tryParse(
        json['stock'].toString(),
      ) ??
          0,

      sku: json['sku']?.toString() ?? '',

      status: json['status']?.toString() ?? '',

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