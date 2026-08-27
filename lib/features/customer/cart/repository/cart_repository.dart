import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/storage/preference_service.dart';

import '../model/cart_model.dart';

class CartRepository {
  final ApiService _apiService;

  CartRepository(this._apiService);

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<CartModel> addToCart({
    required int productId,
    int? variantId,
    required int quantity,
  }) async {
    try {
      final userId =
      PreferenceService.getUserId();

      if (userId == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final response =
      await _apiService.post(
        ApiConstants.cart,
        data: {
          'user_id': userId,
          'product_id': productId,
          'variant_id': variantId,
          'quantity': quantity,
        },
      );

      if (response.data['status'] == true) {
        return CartModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );
      }

      throw Exception(
        response.data['message'] ??
            'Failed to add product to cart',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to add product to cart',
      );
    }
  }

  // ============================================================
  // GET CART
  // ============================================================

  Future<CartResponseModel> getCart() async {
    try {
      final userId =
      PreferenceService.getUserId();

      if (userId == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final response =
      await _apiService.get(
        ApiConstants.cartByUser(
          userId,
        ),
      );

      if (response.data['status'] == true) {
        return CartResponseModel.fromJson(
          Map<String, dynamic>.from(
            response.data,
          ),
        );
      }

      throw Exception(
        response.data['message'] ??
            'Failed to get cart',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to get cart',
      );
    }
  }

  // ============================================================
  // UPDATE CART
  // ============================================================

  Future<void> updateCart({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final response =
      await _apiService.post(
        ApiConstants.updateCart(
          cartId,
        ),
        data: {
          'quantity': quantity,
        },
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to update cart',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to update cart',
      );
    }
  }

  // ============================================================
  // DELETE CART
  // ============================================================

  Future<void> deleteCart(
      int cartId,
      ) async {
    try {
      final response =
      await _apiService.post(
        ApiConstants.deleteCart(
          cartId,
        ),
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to remove cart item',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to remove cart item',
      );
    }
  }

  // ============================================================
  // RESTORE CART
  // ============================================================

  Future<void> restoreCart(
      int cartId,
      ) async {
    try {
      final response =
      await _apiService.post(
        ApiConstants.restoreCart(
          cartId,
        ),
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to restore cart item',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to restore cart item',
      );
    }
  }
}