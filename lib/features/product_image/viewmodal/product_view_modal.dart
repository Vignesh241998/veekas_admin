import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../modal/product_image_modal.dart';
import '../repository/product_image_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final productImageRepositoryProvider =
Provider<ProductImageRepository>((ref) {
  return ProductImageRepository();
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final productImageViewModelProvider = StateNotifierProvider<
    ProductImageViewModel,
    AsyncValue<List<ProductImageModel>>
>(
      (ref) => ProductImageViewModel(
    ref.read(productImageRepositoryProvider),
  ),
);

// ============================================================
// VIEW MODEL
// ============================================================

class ProductImageViewModel
    extends StateNotifier<AsyncValue<List<ProductImageModel>>> {
  final ProductImageRepository _repository;

  ProductImageViewModel(this._repository)
      : super(const AsyncValue.data([]));

  // ============================================================
  // GET ALL PRODUCT IMAGES
  // ============================================================

  Future<void> getProductImages() async {
    state = const AsyncValue.loading();

    try {
      final images =
      await _repository.getProductImages();

      state = AsyncValue.data(images);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ============================================================
  // GET IMAGES BY PRODUCT
  // ============================================================

  Future<void> getImagesByProduct(
      int productId,
      ) async {
    state = const AsyncValue.loading();

    try {
      final images =
      await _repository.getImagesByProduct(
        productId,
      );

      state = AsyncValue.data(images);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ============================================================
  // ADD / UPLOAD PRODUCT IMAGES
  // ============================================================

  Future<void> addProductImages({
    required int productId,
    required List<PlatformFile> images,
  }) async {
    await _repository.addProductImages(
      productId: productId,
      images: images,
    );

    // Do NOT call getProductImages() here.
    //
    // The Product Image Screen will reload
    // only the currently selected product.
  }

  // ============================================================
  // UPDATE PRODUCT IMAGE
  // ============================================================

  Future<void> updateProductImage({
    required int id,
    required PlatformFile image,
  }) async {
    await _repository.updateProductImage(
      id: id,
      image: image,
    );

    // Do NOT call getProductImages() here.
    //
    // The Product Image Screen will reload
    // only the currently selected product.
  }

  // ============================================================
  // DELETE PRODUCT IMAGE
  // ============================================================

  Future<void> deleteProductImage(
      int id,
      ) async {
    await _repository.deleteProductImage(id);

    // Do NOT call getProductImages() here.
    //
    // The Product Image Screen will reload
    // only the currently selected product.
  }

  // ============================================================
  // RESTORE PRODUCT IMAGE
  // ============================================================

  Future<void> restoreProductImage(
      int id,
      ) async {
    await _repository.restoreProductImage(id);

    // Do NOT call getProductImages() here.
    //
    // The Product Image Screen will reload
    // only the currently selected product.
  }
}