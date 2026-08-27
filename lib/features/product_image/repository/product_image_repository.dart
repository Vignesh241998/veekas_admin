import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/api/dio_client.dart';
import '../modal/product_image_modal.dart';



class ProductImageRepository {
  final Dio _dio = DioClient.instance;

  // ============================================================
  // GET ALL PRODUCT IMAGES
  // ============================================================

  Future<List<ProductImageModel>> getProductImages() async {
    try {
      final response = await _dio.get('/product-images');

      final data = response.data['data'];

      if (data is! List) {
        return [];
      }

      return data
          .map(
            (json) => ProductImageModel.fromJson(
          Map<String, dynamic>.from(json),
        ),
      )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to fetch product images',
      );
    } catch (e) {
      throw Exception('Failed to fetch product images: $e');
    }
  }

  // ============================================================
  // GET PRODUCT IMAGES BY PRODUCT ID
  // ============================================================

  Future<List<ProductImageModel>> getImagesByProduct(
      int productId,
      ) async {
    try {
      final response = await _dio.get(
        '/product-images/$productId',
      );

      final data = response.data['data'];

      if (data is! List) {
        return [];
      }

      return data
          .map(
            (json) => ProductImageModel.fromJson(
          {
            ...Map<String, dynamic>.from(json),
            'product_id': productId,
          },
        ),
      )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to fetch product images',
      );
    } catch (e) {
      throw Exception(
        'Failed to fetch product images: $e',
      );
    }
  }

  // ============================================================
  // ADD / UPLOAD PRODUCT IMAGES
  // ============================================================

  // Future<void> addProductImages({
  //   required int productId,
  //   required List<PlatformFile> images,
  // }) async {
  //   try {
  //     final List<MultipartFile> multipartImages = [];
  //
  //     for (final image in images) {
  //       if (image.bytes == null) {
  //         continue;
  //       }
  //
  //       multipartImages.add(
  //         MultipartFile.fromBytes(
  //           image.bytes!,
  //           filename: image.name,
  //         ),
  //       );
  //     }
  //
  //     if (multipartImages.isEmpty) {
  //       throw Exception('Please select at least one image');
  //     }
  //
  //     final formData = FormData.fromMap({
  //       'product_id': productId,
  //       'images': multipartImages,
  //     });
  //
  //     final response = await _dio.post(
  //       '/product-images',
  //       data: formData,
  //     );
  //
  //     if (response.data['status'] != true) {
  //       throw Exception(
  //         response.data['message'] ??
  //             'Failed to upload product images',
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(
  //       e.response?.data?['message'] ??
  //           e.message ??
  //           'Failed to upload product images',
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // ============================================================
// ADD / UPLOAD PRODUCT IMAGES
// ============================================================

  Future<void> addProductImages({
    required int productId,
    required List<PlatformFile> images,
  }) async {
    try {
      if (images.isEmpty) {
        throw Exception(
          'Please select at least one image',
        );
      }

      final List<MultipartFile> multipartImages = [];

      for (final image in images) {
        if (image.bytes == null) {
          continue;
        }

        multipartImages.add(
          MultipartFile.fromBytes(
            image.bytes!,
            filename: image.name,
          ),
        );
      }

      if (multipartImages.isEmpty) {
        throw Exception(
          'Please select valid image files',
        );
      }

      final formData = FormData();

      // Product ID
      formData.fields.add(
        MapEntry(
          'product_id',
          productId.toString(),
        ),
      );

      // Multiple images
      for (final image in multipartImages) {
        formData.files.add(
          MapEntry(
            'images[]',
            image,
          ),
        );
      }

      final response = await _dio.post(
        '/product-images',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to upload product images',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to upload product images',
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // UPDATE PRODUCT IMAGE
  // ============================================================

  Future<void> updateProductImage({
    required int id,
    required PlatformFile image,
  }) async {
    try {
      if (image.bytes == null) {
        throw Exception('Selected image is empty');
      }

      final multipartImage = MultipartFile.fromBytes(
        image.bytes!,
        filename: image.name,
      );

      final formData = FormData.fromMap({
        'image': multipartImage,
      });

      final response = await _dio.post(
        '/product-images/$id',
        data: formData,
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to update product image',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to update product image',
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // DELETE PRODUCT IMAGE
  // ============================================================

  Future<void> deleteProductImage(int id) async {
    try {
      final response = await _dio.post(
        '/product-images/delete/$id',
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to delete product image',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to delete product image',
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // RESTORE PRODUCT IMAGE
  // ============================================================

  Future<void> restoreProductImage(int id) async {
    try {
      final response = await _dio.post(
        '/product-images/restore/$id',
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to restore product image',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to restore product image',
      );
    } catch (e) {
      rethrow;
    }
  }
}