import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/dio_client.dart';
import '../Modal/sub_category_modal.dart';

class SubCategoryRepository {
  final Dio _dio = DioClient.instance;


  // ============================================================
  // GET SUB CATEGORIES
  // ============================================================

  Future<List<SubCategoryModel>> getSubCategories() async {
    try {

      final response = await _dio.get(
        ApiConstants.subCategories,
      );

      final List list = response.data["data"];

      return list
          .map(
            (e) => SubCategoryModel.fromJson(e),
      )
          .toList();

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch sub categories",
      );
    }
  }


  // ============================================================
  // ADD SUB CATEGORY
  // ============================================================

  Future<String> addSubCategory({
    required int categoryId,
    required String subCategoryName,
    PlatformFile? image,
  }) async {
    try {

      final formData = FormData.fromMap({

        "category_id": categoryId,

        "sub_category_name":
        subCategoryName,
      });


      // Image is optional
      if (image != null) {

        formData.files.add(
          MapEntry(
            "sub_category_image",

            MultipartFile.fromBytes(
              image.bytes!,
              filename: image.name,
            ),
          ),
        );
      }


      final response = await _dio.post(
        ApiConstants.subCategories,
        data: formData,
      );


      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to add sub category",
      );
    }
  }


  // ============================================================
  // UPDATE SUB CATEGORY
  // ============================================================

  Future<String> updateSubCategory({
    required int subCategoryId,
    required int categoryId,
    required String subCategoryName,
    PlatformFile? image,
  }) async {
    try {

      final formData = FormData.fromMap({

        "category_id": categoryId,

        "sub_category_name":
        subCategoryName,
      });


      // Image is optional during update
      if (image != null) {

        formData.files.add(
          MapEntry(
            "sub_category_image",

            MultipartFile.fromBytes(
              image.bytes!,
              filename: image.name,
            ),
          ),
        );
      }


      final response = await _dio.post(
        "${ApiConstants.subCategories}/$subCategoryId",
        data: formData,
      );


      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to update sub category",
      );
    }
  }


  // ============================================================
  // DELETE SUB CATEGORY
  // ============================================================

  Future<String> deleteSubCategory(
      int subCategoryId,
      ) async {
    try {

      final response = await _dio.post(
        "${ApiConstants.deleteSubCategory}/$subCategoryId",
      );


      return response.data["message"];

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete sub category",
      );
    }
  }
}