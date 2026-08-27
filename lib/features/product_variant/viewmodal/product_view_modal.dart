import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../modal/product_variant_modal.dart';
import '../repository/product_variant_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final productVariantRepositoryProvider =
Provider<ProductVariantRepository>((ref) {
  return ProductVariantRepository();
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final productVariantViewModelProvider =
StateNotifierProvider<
    ProductVariantViewModel,
    AsyncValue<List<ProductVariantModel>>>(
      (ref) {
    return ProductVariantViewModel(
      ref.read(
        productVariantRepositoryProvider,
      ),
    );
  },
);

// ============================================================
// VIEW MODEL
// ============================================================

class ProductVariantViewModel
    extends StateNotifier<
        AsyncValue<List<ProductVariantModel>>> {
  final ProductVariantRepository repository;

  ProductVariantViewModel(
      this.repository,
      ) : super(
    const AsyncValue.data([]),
  );

  // ============================================================
  // GET
  // ============================================================

  Future<void> getVariants(
      int productId,
      ) async {
    state = const AsyncValue.loading();

    try {
      final result =
      await repository.getVariantsByProduct(
        productId,
      );

      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // ALIAS - CUSTOMER SCREEN
  // ============================================================

  Future<void> getVariantsByProduct(
      int productId,
      ) async {
    await getVariants(productId);
  }

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
    final result =
    await repository.addVariant(
      productId: productId,
      attributes: attributes,
      actualPrice: actualPrice,
      discountPrice: discountPrice,
      stock: stock,
    );

    final current =
        state.value ?? [];

    state = AsyncValue.data([
      result,
      ...current,
    ]);

    return result;
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<ProductVariantModel> updateVariant({
    required int variantId,
    required List<Map<String, String>> attributes,
    required double actualPrice,
    required double discountPrice,
    required int stock,
  }) async {
    final result =
    await repository.updateVariant(
      variantId: variantId,
      attributes: attributes,
      actualPrice: actualPrice,
      discountPrice: discountPrice,
      stock: stock,
    );

    final current =
        state.value ?? [];

    final updatedList =
    current.map((variant) {
      if (variant.id == variantId) {
        return result;
      }

      return variant;
    }).toList();

    state =
        AsyncValue.data(updatedList);

    return result;
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteVariant(
      int variantId,
      ) async {
    await repository.deleteVariant(
      variantId,
    );

    final current =
        state.value ?? [];

    final updatedList =
    current.where(
          (variant) =>
      variant.id != variantId,
    ).toList();

    state =
        AsyncValue.data(updatedList);
  }

  // ============================================================
  // OLD NAME COMPATIBILITY
  // ============================================================

  Future<void> deleteProductVariant(
      int variantId,
      ) async {
    await deleteVariant(variantId);
  }
}