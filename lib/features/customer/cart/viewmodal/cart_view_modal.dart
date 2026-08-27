import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../shared/providers/app_providers.dart';

import '../model/cart_model.dart';
import '../repository/cart_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final cartRepositoryProvider =
Provider<CartRepository>((ref) {
  return CartRepository(
    ref.read(apiServiceProvider),
  );
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final cartViewModelProvider =
StateNotifierProvider<
    CartViewModel,
    AsyncValue<CartResponseModel?>>(
      (ref) {
    return CartViewModel(
      ref.read(
        cartRepositoryProvider,
      ),
    );
  },
);

// ============================================================
// VIEW MODEL
// ============================================================

class CartViewModel
    extends StateNotifier<
        AsyncValue<CartResponseModel?>> {
  final CartRepository _repository;

  CartViewModel(
      this._repository,
      ) : super(
    const AsyncValue.data(null),
  );

  // ============================================================
  // GET CART
  // ============================================================

  Future<void> getCart() async {
    try {
      final result =
      await _repository.getCart();

      state =
          AsyncValue.data(result);
    } catch (e, stackTrace) {
      state =
          AsyncValue.error(
            e,
            stackTrace,
          );
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<CartModel> addToCart({
    required int productId,
    int? variantId,
    required int quantity,
  }) async {
    final result =
    await _repository.addToCart(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
    );

    // Refresh cart from server.
    // This automatically updates badge count.
    await getCart();

    return result;
  }

  // ============================================================
  // UPDATE CART
  // ============================================================

  Future<void> updateCart({
    required int cartId,
    required int quantity,
  }) async {
    await _repository.updateCart(
      cartId: cartId,
      quantity: quantity,
    );

    // Refresh from server.
    await getCart();
  }

  // ============================================================
  // DELETE CART
  // ============================================================

  Future<void> deleteCart(
      int cartId,
      ) async {
    await _repository.deleteCart(
      cartId,
    );

    await getCart();
  }

  // ============================================================
  // RESTORE CART
  // ============================================================

  Future<void> restoreCart(
      int cartId,
      ) async {
    await _repository.restoreCart(
      cartId,
    );

    await getCart();
  }

  // ============================================================
  // CART COUNT
  // ============================================================

  int get cartCount {
    final cart =
        state.value;

    if (cart == null) {
      return 0;
    }

    // Laravel now returns total quantity.
    return cart.totalItems;
  }

  // ============================================================
  // GRAND TOTAL
  // ============================================================

  double get grandTotal {
    final cart =
        state.value;

    if (cart == null) {
      return 0;
    }

    return cart.grandTotal;
  }

  // ============================================================
  // CART ITEMS
  // ============================================================

  List<CartModel> get cartItems {
    final cart =
        state.value;

    if (cart == null) {
      return [];
    }

    return cart.items;
  }
}