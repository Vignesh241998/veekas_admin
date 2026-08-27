import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/dio_client.dart';
import '../Modal/brand_modal.dart';

class BrandRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET BRANDS
  // ============================================================

  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await _dio.get(
        ApiConstants.brand,
      );

      final List list =
      response.data["data"];

      return list
          .map(
            (e) => BrandModel.fromJson(e),
      )
          .toList();

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch brands",
      );
    }
  }

  // ============================================================
  // ADD BRAND
  // ============================================================

  Future<String> addBrand({
    required String brandName,
    PlatformFile? image,
  }) async {
    try {

      final formData = FormData.fromMap({
        "brand_name": brandName,
      });

      // Image is optional
      if (image != null) {

        formData.files.add(
          MapEntry(
            "brand_image",

            MultipartFile.fromBytes(
              image.bytes!,
              filename: image.name,
            ),
          ),
        );
      }

      final response = await _dio.post(
        ApiConstants.brand,
        data: formData,
      );

      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to add brand",
      );
    }
  }

  // ============================================================
  // UPDATE BRAND
  // ============================================================

  Future<String> updateBrand({
    required int brandId,
    required String brandName,
    PlatformFile? image,
  }) async {
    try {

      final formData = FormData.fromMap({
        "brand_name": brandName,
      });

      // Image is optional during update
      if (image != null) {

        formData.files.add(
          MapEntry(
            "brand_image",

            MultipartFile.fromBytes(
              image.bytes!,
              filename: image.name,
            ),
          ),
        );
      }

      final response = await _dio.post(
        "${ApiConstants.brand}/$brandId",
        data: formData,
      );

      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to update brand",
      );
    }
  }

  // ============================================================
  // DELETE BRAND
  // ============================================================

  Future<String> deleteBrand(
      int brandId,
      ) async {
    try {

      final response = await _dio.post(
        "${ApiConstants.deleteBrand}/$brandId",
      );

      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete brand",
      );
    }
  }
}