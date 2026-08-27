import 'package:dio/dio.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/dio_client.dart';

import '../modal/product_variant_modal.dart';

class ProductVariantRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // ADD
  // ============================================================

  Future<ProductVariantModel> addVariant({
    required int productId,
    required List<Map<String, String>> attributes,
    required double actualPrice,
    required double discountPrice,
    required int stock,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.productVariants,
        data: {
          'product_id': productId,
          'attributes': attributes,
          'actual_price': actualPrice,
          'discount_price': discountPrice,
          'stock': stock,
        },
      );

      if (response.data['status'] == true) {
        return ProductVariantModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );
      }

      throw Exception(
        response.data['message'] ??
            'Failed to add variant',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to add variant',
      );
    }
  }

  // ============================================================
  // GET
  // ============================================================

  Future<List<ProductVariantModel>>
  getVariantsByProduct(
      int productId,
      ) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.productVariants}/$productId',
      );

      if (response.data['status'] == true) {
        final List<dynamic> data =
            response.data['data'] ?? [];

        return data
            .map(
              (item) =>
              ProductVariantModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
        )
            .toList();
      }

      throw Exception(
        response.data['message'] ??
            'Failed to get variants',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to get variants',
      );
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  /*Future<ProductVariantModel> updateVariant({
    required int variantId,
    required List<Map<String, String>> attributes,
    required double actualPrice,
    required double discountPrice,
    required int stock,
  }) async
  {
    try {
      final response = await _dio.put(
        '${ApiConstants.productVariants}/$variantId',
        data: {
          'attributes': attributes,
          'actual_price': actualPrice,
          'discount_price': discountPrice,
          'stock': stock,
        },
      );

      if (response.data['status'] == true) {
        return ProductVariantModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );
      }

      throw Exception(
        response.data['message'] ??
            'Failed to update variant',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to update variant',
      );
    }
  }*/
  Future<ProductVariantModel> updateVariant({
    required int variantId,
    required List<Map<String, String>> attributes,
    required double actualPrice,
    required double discountPrice,
    required int stock,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.productVariants}/$variantId',
        data: {
          'attributes': attributes,
          'actual_price': actualPrice,
          'discount_price': discountPrice,
          'stock': stock,
        },
      );

      if (response.data['status'] == true) {
        return ProductVariantModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );
      }

      throw Exception(
        response.data['message'] ??
            'Failed to update variant',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to update variant',
      );
    }
  }

  // ============================================================
  // DELETE
  // ============================================================
  Future<void> deleteVariant(
      int variantId,
      ) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.productVariants}/delete/$variantId',
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to delete variant',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to delete variant',
      );
    }
  }
  // Future<void> deleteVariant(
  //     int variantId,
  //     ) async
  // {
  //   try {
  //     final response = await _dio.post(
  //       '${ApiConstants.productVariants}/$variantId',
  //     );
  //
  //     if (response.data['status'] != true) {
  //       throw Exception(
  //         response.data['message'] ??
  //             'Failed to delete variant',
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(
  //       e.response?.data?['message'] ??
  //           e.message ??
  //           'Failed to delete variant',
  //     );
  //   }
  // }
}