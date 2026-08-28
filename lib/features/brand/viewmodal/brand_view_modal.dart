import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../modal/brand_modal.dart';
import '../repository/brand_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final brandRepositoryProvider =
Provider<BrandRepository>((ref) {
  return BrandRepository();
});

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final brandViewModelProvider =
StateNotifierProvider<
    BrandViewModel,
    AsyncValue<List<BrandModel>>
>(
      (ref) => BrandViewModel(
    ref.read(brandRepositoryProvider),
  ),
);

// ============================================================
// VIEW MODEL
// ============================================================

class BrandViewModel
    extends StateNotifier<AsyncValue<List<BrandModel>>> {

  final BrandRepository _repository;

  BrandViewModel(this._repository)
      : super(const AsyncLoading()) {
    getBrands();
  }

  // ============================================================
  // GET BRANDS
  // ============================================================

  Future<void> getBrands() async {
    try {

      state = const AsyncLoading();

      final brands =
      await _repository.getBrands();

      state = AsyncData(brands);

    } catch (e, stackTrace) {

      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // ADD BRAND
  // ============================================================

  Future<bool> addBrand({
    required String brandName,
    PlatformFile? image,
  }) async {
    try {

      await _repository.addBrand(
        brandName: brandName,
        image: image,
      );

      // Refresh brand list
      await getBrands();

      return true;

    } catch (e) {

      rethrow;
    }
  }

  // ============================================================
  // UPDATE BRAND
  // ============================================================

  Future<bool> updateBrand({
    required int brandId,
    required String brandName,
    PlatformFile? image,
  }) async {
    try {

      await _repository.updateBrand(
        brandId: brandId,
        brandName: brandName,
        image: image,
      );

      // Refresh brand list
      await getBrands();

      return true;

    } catch (e) {

      rethrow;
    }
  }

  // ============================================================
  // DELETE BRAND
  // ============================================================

  Future<bool> deleteBrand(
      int brandId,
      ) async {
    try {

      await _repository.deleteBrand(
        brandId,
      );

      // Refresh brand list
      await getBrands();

      return true;

    } catch (e) {

      rethrow;
    }
  }
}