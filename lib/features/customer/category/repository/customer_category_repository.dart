import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/dio_client.dart';
import '../../../category/model/category_model.dart';

class CustomerCategoryRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET ACTIVE CATEGORIES
  // ============================================================

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(
        ApiConstants.categories,
      );

      final List list = response.data["data"] ?? [];

      final categories = list
          .map(
            (e) => CategoryModel.fromJson(e),
      )
          .toList();

      // Customer should see only active categories
      return categories
          .where(
            (category) =>
        category.status.toLowerCase() == "active",
      )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch categories",
      );
    } catch (e) {
      throw Exception(
        "Unable to fetch categories",
      );
    }
  }
}  