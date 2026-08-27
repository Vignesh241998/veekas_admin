import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/dio_client.dart';
import '../../../product/Modal/product_modal.dart';


class CustomerProductRepository {
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
}