import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../Modal/sub_category_modal.dart';
import '../repository/sub_category_repository.dart';


// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final subCategoryRepositoryProvider =
Provider<SubCategoryRepository>((ref) {
  return SubCategoryRepository();
});


// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final subCategoryViewModelProvider =
StateNotifierProvider<
    SubCategoryViewModel,
    AsyncValue<List<SubCategoryModel>>
>(
      (ref) => SubCategoryViewModel(
    ref.read(subCategoryRepositoryProvider),
  ),
);


// ============================================================
// VIEW MODEL
// ============================================================

class SubCategoryViewModel
    extends StateNotifier<
        AsyncValue<List<SubCategoryModel>>> {

  final SubCategoryRepository _repository;

  SubCategoryViewModel(this._repository)
      : super(const AsyncLoading()) {

    getSubCategories();
  }


  // ============================================================
  // GET SUB CATEGORIES
  // ============================================================

  Future<void> getSubCategories() async {
    try {

      state = const AsyncLoading();

      final subCategories =
      await _repository.getSubCategories();

      state = AsyncData(
        subCategories,
      );

    } catch (e, stackTrace) {

      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }


  // ============================================================
  // ADD SUB CATEGORY
  // ============================================================

  Future<bool> addSubCategory({
    required int categoryId,
    required String subCategoryName,
    PlatformFile? image,
  }) async {

    try {

      await _repository.addSubCategory(
        categoryId: categoryId,
        subCategoryName: subCategoryName,
        image: image,
      );

      // Refresh sub category list
      await getSubCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // UPDATE SUB CATEGORY
  // ============================================================

  Future<bool> updateSubCategory({
    required int subCategoryId,
    required int categoryId,
    required String subCategoryName,
    PlatformFile? image,
  }) async {

    try {

      await _repository.updateSubCategory(
        subCategoryId: subCategoryId,
        categoryId: categoryId,
        subCategoryName: subCategoryName,
        image: image,
      );

      // Refresh sub category list
      await getSubCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }


  // ============================================================
  // DELETE SUB CATEGORY
  // ============================================================

  Future<bool> deleteSubCategory(
      int subCategoryId,
      ) async {

    try {

      await _repository.deleteSubCategory(
        subCategoryId,
      );

      // Refresh sub category list
      await getSubCategories();

      return true;

    } catch (e) {

      rethrow;
    }
  }
}