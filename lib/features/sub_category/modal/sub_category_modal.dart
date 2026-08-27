class SubCategoryModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String subCategoryName;
  final String subCategoryImage;
  final String status;
  final String createdAt;

  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryName,
    required this.subCategoryImage,
    required this.status,
    required this.createdAt,
  });

  factory SubCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubCategoryModel(
      id: json["id"] ?? 0,

      categoryId: json["category_id"] ?? 0,

      categoryName: json["category_name"] ?? "",

      subCategoryName:
      json["sub_category_name"] ?? "",

      subCategoryImage:
      json["sub_category_image"] ?? "",

      status: json["status"] ?? "",

      createdAt:
      json["created_at"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_id": categoryId,
      "category_name": categoryName,
      "sub_category_name": subCategoryName,
      "sub_category_image": subCategoryImage,
      "status": status,
      "created_at": createdAt,
    };
  }
}