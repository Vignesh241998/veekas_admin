import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../product/Modal/product_modal.dart';
import '../repository/customer_product_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final customerProductRepositoryProvider =
Provider<CustomerProductRepository>((ref) {
  return CustomerProductRepository();
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final customerProductViewModelProvider =
StateNotifierProvider<
    CustomerProductViewModel,
    AsyncValue<List<ProductModel>>
>(
      (ref) => CustomerProductViewModel(
    ref.read(customerProductRepositoryProvider),
  ),
);

// ============================================================
// CUSTOMER PRODUCT VIEW MODEL
// ============================================================

class CustomerProductViewModel
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final CustomerProductRepository _repository;

  CustomerProductViewModel(this._repository)
      : super(const AsyncLoading()) {
    getProducts();
  }

  // ============================================================
  // GET PRODUCTS
  // ============================================================

  Future<void> getProducts() async {
    try {
      state = const AsyncLoading();

      final products =
      await _repository.getProducts();

      state = AsyncData(products);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // REFRESH PRODUCTS
  // ============================================================

  Future<void> refreshProducts() async {
    await getProducts();
  }
}