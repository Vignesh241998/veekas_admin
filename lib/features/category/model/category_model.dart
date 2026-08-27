class CategoryModel {
  final int id;
  final String categoryName;
  final String categoryImage;
  final String status;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] ?? 0,
      categoryName: json["category_name"] ?? "",
      categoryImage: json["category_image"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_name": categoryName,
      "category_image": categoryImage,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}