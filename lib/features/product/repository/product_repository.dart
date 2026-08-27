import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/dio_client.dart';
import '../Modal/product_modal.dart';

class ProductRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET PRODUCTS
  // ============================================================

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(
        ApiConstants.products,
      );

      final List list = response.data["data"] ?? [];

      return list
          .map(
            (e) => ProductModel.fromJson(e),
      )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch products",
      );
    }
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<String> addProduct({
    required int categoryId,
    required int subCategoryId,
    required int brandId,
    required String productName,
    required String description,
    required double actualPrice,
    required double discountPrice,
    required int stock,
    PlatformFile? thumbnailImage,
    required bool isFeatured,
    required bool isNewArrival,
    required bool hasVariant,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "brand_id": brandId,
        "product_name": productName,
        "description": description,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "stock": stock,
        "is_featured": isFeatured ? 1 : 0,
        "is_new_arrival": isNewArrival ? 1 : 0,
        "has_variant": hasVariant ? 1 : 0,
        // "is_featured": isFeatured,
        // "is_new_arrival": isNewArrival,
        // "has_variant": hasVariant,
      };

      if (thumbnailImage != null &&
          thumbnailImage.bytes != null) {
        data["thumbnail_image"] = MultipartFile.fromBytes(
          thumbnailImage.bytes!,
          filename: thumbnailImage.name,
        );
      }

      final formData = FormData.fromMap(data);

      final response = await _dio.post(
        ApiConstants.products,
        data: formData,
      );

      return response.data["message"] ??
          "Product Added Successfully";
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to add product",
      );
    }
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================
  Future<String> updateProduct({
    required int productId,
    required int categoryId,
    required int subCategoryId,
    required int brandId,
    required String productName,
    required String description,
    required double actualPrice,
    required double discountPrice,
    required int stock,
    PlatformFile? thumbnailImage,
    required bool isFeatured,
    required bool isNewArrival,
    required bool hasVariant,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "brand_id": brandId,
        "product_name": productName,
        "description": description,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "stock": stock,
        "is_featured": isFeatured ? 1 : 0,
        "is_new_arrival": isNewArrival ? 1 : 0,
        "has_variant": hasVariant ? 1 : 0,
        // "is_featured": isFeatured,
        // "is_new_arrival": isNewArrival,
        // "has_variant": hasVariant,
      };

      if (thumbnailImage != null &&
          thumbnailImage.bytes != null) {
        data["thumbnail_image"] = MultipartFile.fromBytes(
          thumbnailImage.bytes!,
          filename: thumbnailImage.name,
        );
      }

      final formData = FormData.fromMap(data);

      final response = await _dio.post(
        "${ApiConstants.products}/$productId",
        data: formData,
      );

      return response.data["message"] ??
          "Product Updated Successfully";
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to update product",
      );
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<String> deleteProduct(int productId) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.deleteProduct}/$productId",
      );

      return response.data["message"] ??
          "Product Deleted Successfully";
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete product",
      );
    }
  }
}