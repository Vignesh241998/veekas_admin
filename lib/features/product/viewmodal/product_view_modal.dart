import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../Modal/product_modal.dart';
import '../repository/product_repository.dart';


// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final productRepositoryProvider =
Provider<ProductRepository>((ref) {
  return ProductRepository();
});


// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final productViewModelProvider =
StateNotifierProvider<
    ProductViewModel,
    AsyncValue<List<ProductModel>>
>(
      (ref) => ProductViewModel(
    ref.read(productRepositoryProvider),
  ),
);


// ============================================================
// PRODUCT VIEW MODEL
// ============================================================

class ProductViewModel
    extends StateNotifier<AsyncValue<List<ProductModel>>> {

  final ProductRepository _repository;

  ProductViewModel(this._repository)
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
  // ADD PRODUCT
  // ============================================================

  Future<bool> addProduct({
    required int categoryId,
    required int subCategoryId,
    required int brandId,

    required String productName,
    required String description,

    required double actualPrice,
    required double discountPrice,

    required int stock,

    PlatformFile? thumbnailImage,

    required bool isFeatured,
    required bool isNewArrival,
    required bool hasVariant,
  }) async {

    try {

      await _repository.addProduct(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        brandId: brandId,

        productName: productName,
        description: description,

        actualPrice: actualPrice,
        discountPrice: discountPrice,

        stock: stock,

        // IMPORTANT
        thumbnailImage: thumbnailImage,

        isFeatured: isFeatured,
        isNewArrival: isNewArrival,
        hasVariant: hasVariant,
      );

      await getProducts();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<bool> updateProduct({
    required int productId,

    required int categoryId,
    required int subCategoryId,
    required int brandId,

    required String productName,
    required String description,

    required double actualPrice,
    required double discountPrice,

    required int stock,

    PlatformFile? thumbnailImage,

    required bool isFeatured,
    required bool isNewArrival,
    required bool hasVariant,
  }) async {

    try {

      await _repository.updateProduct(
        productId: productId,

        categoryId: categoryId,
        subCategoryId: subCategoryId,
        brandId: brandId,

        productName: productName,
        description: description,

        actualPrice: actualPrice,
        discountPrice: discountPrice,

        stock: stock,

        // IMPORTANT
        thumbnailImage: thumbnailImage,

        isFeatured: isFeatured,
        isNewArrival: isNewArrival,
        hasVariant: hasVariant,
      );

      await getProducts();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<bool> deleteProduct(
      int productId,
      ) async {

    try {

      await _repository.deleteProduct(
        productId,
      );

      await getProducts();

      return true;

    } catch (e) {

      rethrow;
    }
  }
}