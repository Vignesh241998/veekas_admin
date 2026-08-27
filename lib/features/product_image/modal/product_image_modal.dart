class ProductImageModel {
  final int id;
  final int productId;
  final String? productName;
  final String? image;
  final String status;
  final DateTime? createdAt;

  ProductImageModel({
    required this.id,
    required this.productId,
    this.productName,
    this.image,
    required this.status,
    this.createdAt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,

      productName: json['product_name']?.toString(),

      image: json['image']?.toString(),

      status: json['status']?.toString() ?? 'ACTIVE',

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}