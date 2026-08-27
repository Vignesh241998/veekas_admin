class ProductModel {
  final int id;

  final int categoryId;
  final String categoryName;

  final int subCategoryId;
  final String subCategoryName;

  final int brandId;
  final String brandName;

  final String productName;
  final String productCode;

  final String description;

  final double actualPrice;
  final double discountPrice;

  final int stock;

  final String? thumbnailImage;

  final bool isFeatured;
  final bool isNewArrival;
  final bool hasVariant;

  final String status;
  final String createdAt;

  ProductModel({
    required this.id,

    required this.categoryId,
    required this.categoryName,

    required this.subCategoryId,
    required this.subCategoryName,

    required this.brandId,
    required this.brandName,

    required this.productName,
    required this.productCode,

    required this.description,

    required this.actualPrice,
    required this.discountPrice,

    required this.stock,

    required this.thumbnailImage,

    required this.isFeatured,
    required this.isNewArrival,
    required this.hasVariant,

    required this.status,
    required this.createdAt,
  });

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductModel(
      id: json["id"] ?? 0,

      categoryId: json["category_id"] ?? 0,
      categoryName: json["category_name"] ?? "",

      subCategoryId: json["sub_category_id"] ?? 0,
      subCategoryName:
      json["sub_category_name"] ?? "",

      brandId: json["brand_id"] ?? 0,
      brandName: json["brand_name"] ?? "",

      productName:
      json["product_name"] ?? "",

      productCode:
      json["product_code"] ?? "",

      description:
      json["description"] ?? "",

      actualPrice:
      double.tryParse(
        json["actual_price"]?.toString() ?? "0",
      ) ??
          0.0,

      discountPrice:
      double.tryParse(
        json["discount_price"]?.toString() ?? "0",
      ) ??
          0.0,

      stock:
      int.tryParse(
        json["stock"]?.toString() ?? "0",
      ) ??
          0,

      thumbnailImage:
      json["thumbnail_image"]?.toString(),

      isFeatured:
      json["is_featured"] == true ||
          json["is_featured"] == 1 ||
          json["is_featured"] == "1",

      isNewArrival:
      json["is_new_arrival"] == true ||
          json["is_new_arrival"] == 1 ||
          json["is_new_arrival"] == "1",

      hasVariant:
      json["has_variant"] == true ||
          json["has_variant"] == 1 ||
          json["has_variant"] == "1",

      status:
      json["status"] ?? "",

      createdAt:
      json["created_at"]?.toString() ?? "",
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "category_id": categoryId,
      "category_name": categoryName,

      "sub_category_id": subCategoryId,
      "sub_category_name": subCategoryName,

      "brand_id": brandId,
      "brand_name": brandName,

      "product_name": productName,
      "product_code": productCode,

      "description": description,

      "actual_price": actualPrice,
      "discount_price": discountPrice,

      "stock": stock,

      "thumbnail_image": thumbnailImage,

      "is_featured": isFeatured,
      "is_new_arrival": isNewArrival,
      "has_variant": hasVariant,

      "status": status,

      "created_at": createdAt,
    };
  }
}