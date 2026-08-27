class BrandModel {
  final int id;
  final String brandName;
  final String brandImage;
  final String status;
  final String createdAt;
  final String updatedAt;

  BrandModel({
    required this.id,
    required this.brandName,
    required this.brandImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BrandModel(
      id: json["id"] ?? 0,

      brandName:
      json["brand_name"] ?? "",

      brandImage:
      json["brand_image"] ?? "",

      status:
      json["status"] ?? "",

      createdAt:
      json["created_at"]?.toString() ?? "",

      updatedAt:
      json["updated_at"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "brand_name": brandName,
      "brand_image": brandImage,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}