// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
//
// import '../../../core/api/api_constants.dart';
// import '../../../core/api/dio_client.dart';
// import '../model/category_model.dart';
//
// class CategoryRepository {
//   final Dio _dio = DioClient.instance;
//
//   /// ===============================
//   /// Category List
//   /// ===============================
//   Future<List<CategoryModel>> getCategories() async {
//     try {
//       final response = await _dio.get(
//         ApiConstants.categories,
//       );
//
//       final List list = response.data["data"];
//
//       return list
//           .map((e) => CategoryModel.fromJson(e))
//           .toList();
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data["message"] ??
//             "Unable to fetch categories",
//       );
//     }
//   }
//
//   /// ===============================
//   /// Add Category
//   /// ===============================
//   Future<String> addCategory({
//     required String categoryName,
//     required PlatformFile image,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "category_name": categoryName,
//         "category_image": MultipartFile.fromBytes(
//           image.bytes!,
//           filename: image.name,
//         ),
//       });
//
//       final response = await _dio.post(
//         ApiConstants.categories,
//         data: formData,
//       );
//
//       return response.data["message"];
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data["message"] ??
//             "Unable to add category",
//       );
//     }
//   }
//
//   /// ===============================
//   /// Update Category
//   /// ===============================
//   Future<String> updateCategory({
//     required int categoryId,
//     required String categoryName,
//     PlatformFile? image,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "category_name": categoryName,
//       });
//
//       if (image != null) {
//         formData.files.add(
//           MapEntry(
//             "category_image",
//             MultipartFile.fromBytes(
//               image.bytes!,
//               filename: image.name,
//             ),
//           ),
//         );
//       }
//
//       final response = await _dio.post(
//         "${ApiConstants.categories}/$categoryId",
//         data: formData,
//       );
//
//       return response.data["message"];
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data["message"] ??
//             "Unable to update category",
//       );
//     }
//   }
//
//   /// ===============================
//   /// Delete Category
//   /// ===============================
//   Future<String> deleteCategory(int categoryId) async {
//     try {
//       final response = await _dio.post(
//         "${ApiConstants.deleteCategory}/$categoryId",
//       );
//
//       return response.data["message"];
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data["message"] ??
//             "Unable to delete category",
//       );
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/dio_client.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET CATEGORIES
  // ============================================================

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(
        ApiConstants.categories,
      );

      final List list = response.data["data"];

      return list
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch categories",
      );
    }
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<String> addCategory({
    required String categoryName,
    required PlatformFile image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "category_name": categoryName,

        "category_image": MultipartFile.fromBytes(
          image.bytes!,
          filename: image.name,
        ),
      });

      final response = await _dio.post(
        ApiConstants.categories,
        data: formData,
      );

      return response.data["message"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to add category",
      );
    }
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<String> updateCategory({
    required int categoryId,
    required String categoryName,
    PlatformFile? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "category_name": categoryName,
      });

      // Image is optional during update
      if (image != null) {
        formData.files.add(
          MapEntry(
            "category_image",
            MultipartFile.fromBytes(
              image.bytes!,
              filename: image.name,
            ),
          ),
        );
      }

      final response = await _dio.post(
        "${ApiConstants.categories}/$categoryId",
        data: formData,
      );

      return response.data["message"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to update category",
      );
    }
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<String> deleteCategory(int categoryId) async {
    try {
      final response = await _dio.post(
        "${ApiConstants.deleteCategory}/$categoryId",
      );

      return response.data["message"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to delete category",
      );
    }
  }
}